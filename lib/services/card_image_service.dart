// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'settings_service.dart';

/// Serves card face images without bundling them (~600 MB) in the app.
///
/// The backend hosts the PNGs under /cards and exposes GET /api/v1/cards/manifest, which lists
/// each card's `internal_version` and versioned front/back URLs. On mobile we download faces into
/// an on-device cache directory and re-download one only when its version increases; on web we hand
/// the URL straight to [NetworkImage] and let the browser's HTTP cache do the caching.
///
/// Whether faces are pre-fetched in bulk is governed by the user's [CardDownloadMode] setting:
/// `onDemand` (the default) caches a face lazily the first time it's viewed; `always`/`wifiOnly`
/// bulk-download on launch (the latter only on Wi-Fi).
class CardImageService {
  static final CardImageService _instance = CardImageService._();
  factory CardImageService() => _instance;
  CardImageService._();

  final _client = ApiClient();

  /// filename (e.g. "guild-baroni-front.png") -> face metadata from the manifest.
  final Map<String, _Face> _faces = {};

  /// Backend origin (e.g. "https://host"), derived from the dio base URL by dropping "/api/v1".
  late final String _origin =
      _client.dio.options.baseUrl.replaceFirst(RegExp(r'/api/v1/?$'), '');

  Directory? _cacheDir; // null on web
  SharedPreferences? _prefs;
  static const _versionsKey = 'card_image_versions';
  static const _manifestKey = 'card_manifest_versions';

  /// filename -> version currently stored on disk. Persisted so a stale face is re-fetched only
  /// after its version actually changes, not on every launch.
  Map<String, int> _downloaded = {};

  /// Filenames whose on-demand background download is currently in flight, so a face that stays on
  /// screen (rebuilding [provider] repeatedly) is fetched once, not once per frame.
  final Set<String> _fetching = {};

  bool _manifestLoaded = false;

  /// True once an *unfiltered* manifest (the whole catalog) has been loaded this session. Pruning
  /// orphaned faces off disk is only safe against a fresh full manifest — a faction-filtered one,
  /// or a persisted-but-possibly-stale seed, would look like every other gang's cards were removed.
  bool _fullManifestLoaded = false;

  /// True while a [sync] is in flight, so a second call (e.g. the settings button tapped during the
  /// startup sync) doesn't kick off a concurrent download.
  bool _syncing = false;

  /// Live progress of an in-flight [sync], or null when idle. Lives on the service — not on any
  /// widget — so a sync started from Settings keeps reporting even after that screen is disposed,
  /// and the button reflects the real state when you navigate back.
  final ValueNotifier<CardSyncStatus?> syncStatus = ValueNotifier(null);

  /// Prepares the on-disk cache (mobile) and loads the manifest. Non-fatal on failure: faces then
  /// fall back to on-demand network loads.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (!kIsWeb) {
      // Re-downloadable images belong in the OS cache dir (excluded from iCloud/device backups),
      // not Application Support where older builds kept them. Migrate by deleting the old copy.
      final cacheBase = await getApplicationCacheDirectory();
      _cacheDir = Directory('${cacheBase.path}/card_images');
      await _cacheDir!.create(recursive: true);
      await _deleteLegacyCache();

      final raw = _prefs!.getString(_versionsKey);
      if (raw != null) {
        _downloaded = (jsonDecode(raw) as Map)
            .map((k, v) => MapEntry(k as String, (v as num).toInt()));
      }
    }
    // Seed faces from the last persisted manifest, so versioned URLs keep resolving even if this
    // launch's manifest fetch fails (on web that's the only thing standing between us and the
    // unversioned, year-immutable fallback URL — see [_urlFor]).
    _seedFacesFromPrefs();
    try {
      await loadManifest();
    } catch (e) {
      debugPrint('Card manifest load failed: $e');
    }
  }

  Future<void> _deleteLegacyCache() async {
    try {
      final legacy = Directory(
        '${(await getApplicationSupportDirectory()).path}/card_images',
      );
      if (await legacy.exists()) await legacy.delete(recursive: true);
    } catch (e) {
      debugPrint('Legacy card cache cleanup failed: $e');
    }
  }

  void _seedFacesFromPrefs() {
    final raw = _prefs?.getString(_manifestKey);
    if (raw == null) return;
    try {
      (jsonDecode(raw) as Map).forEach((k, v) {
        final filename = k as String;
        final version = (v as num).toInt();
        _faces[filename] = _Face('/cards/$filename?v=$version', version);
      });
      _manifestLoaded = _faces.isNotEmpty;
    } catch (e) {
      debugPrint('Persisted card manifest read failed: $e');
    }
  }

  /// Fetches the manifest and indexes every face by filename. [faction] narrows it to one gang.
  Future<void> loadManifest({String? faction}) async {
    final res = await _client.dio.get<Map<String, dynamic>>(
      '/cards/manifest',
      queryParameters: (faction != null) ? {'faction': faction} : null,
    );
    final cards = (res.data?['cards'] as List?) ?? const [];
    // A full (unfiltered) load is the authoritative catalog: rebuild the index from scratch so
    // cards removed or renamed on the backend drop out of [_faces] and get pruned off disk. A
    // faction-filtered load only augments, so it can't wipe the other gangs' faces.
    if (faction == null) _faces.clear();
    for (final c in cards) {
      final m = c as Map<String, dynamic>;
      final version = (m['internal_version'] as num?)?.toInt() ?? 1;
      final faces = [
        (m['front_url'], (m['front_bytes'] as num?)?.toInt()),
        (m['back_url'], (m['back_bytes'] as num?)?.toInt()),
      ];
      for (final (url, bytes) in faces) {
        if (url is String && url.isNotEmpty) {
          _faces[_filenameOf(url)] = _Face(_pathOf(url), version, bytes: bytes);
        }
      }
    }
    _manifestLoaded = true;
    if (faction == null) {
      _fullManifestLoaded = true;
      await _persistManifest();
    }
  }

  Future<void> _persistManifest() async {
    final map = {for (final e in _faces.entries) e.key: e.value.version};
    await _prefs?.setString(_manifestKey, jsonEncode(map));
  }

  String _filenameOf(String url) => Uri.parse(url).pathSegments.last;

  /// The root-relative path (with the ?v= buster), dropping any origin the backend might include.
  String _pathOf(String url) {
    final uri = Uri.parse(url);
    return uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
  }

  /// Deletes cached faces that are no longer in the catalog — cards that were removed, or whose face
  /// filename changed across a version (the old name would otherwise linger on disk forever, since
  /// [sync] only ever visits faces that are still in the manifest). No-op until a fresh full
  /// manifest has loaded this session, so a filtered load or a stale seed can't wipe real faces.
  Future<void> _pruneOrphans(Directory dir) async {
    if (!_fullManifestLoaded) return;
    try {
      var changed = false;
      for (final entity in dir.listSync()) {
        if (entity is! File) continue;
        final name = entity.uri.pathSegments.last;
        if (_faces.containsKey(name)) continue;
        try {
          await entity.delete();
          await FileImage(entity).evict();
        } catch (e) {
          debugPrint('Card image prune failed for $name: $e');
        }
        if (_downloaded.remove(name) != null) changed = true;
      }
      if (changed) await _prefs?.setString(_versionsKey, jsonEncode(_downloaded));
    } catch (e) {
      debugPrint('Card image prune failed: $e');
    }
  }

  /// Absolute, version-busted URL for a face. Falls back to an unversioned URL only when no manifest
  /// has ever been seen (fresh install, first fetch failed) — once one has, the persisted seed keeps
  /// producing versioned URLs, so an intermediary cache can't pin an old face under a reused name.
  String _urlFor(String filename) {
    final path = _faces[filename]?.urlPath ?? '/cards/$filename';
    return '$_origin$path';
  }

  /// [ImageProvider] for a card face filename, or null when the profile has no printed card.
  /// Web -> network (browser cache). Mobile -> the cached file if present (kicking off a background
  /// refresh if its version is behind), else network now while it's cached in the background so the
  /// next view is local. This lazy caching is what makes the default `onDemand` mode useful.
  ImageProvider? provider(String filename) {
    if (filename.isEmpty) return null;
    final dir = _cacheDir;
    if (kIsWeb || dir == null) {
      return NetworkImage(_urlFor(filename));
    }
    final file = File('${dir.path}/$filename');
    if (file.existsSync()) {
      final face = _faces[filename];
      if (face != null && (_downloaded[filename] ?? -1) != face.version) {
        _cacheInBackground(filename); // on disk but a version behind — refresh it
      }
      return FileImage(file);
    }
    _cacheInBackground(filename);
    return NetworkImage(_urlFor(filename));
  }

  /// Downloads a single face to disk in the background (deduped), so viewing it once caches it.
  void _cacheInBackground(String filename) {
    if (kIsWeb || _cacheDir == null) return;
    if (_fetching.contains(filename)) return;
    final face = _faces[filename];
    if (face == null) return; // no manifest entry yet — nothing versioned to fetch
    _fetching.add(filename);
    unawaited(
      _downloadFace(filename, face).whenComplete(() => _fetching.remove(filename)),
    );
  }

  /// Fetches one face's bytes and writes them to the cache, recording its version. Returns whether
  /// it succeeded. Shared by [sync] and the on-demand [_cacheInBackground] path.
  Future<bool> _downloadFace(String filename, _Face face) async {
    final dir = _cacheDir;
    if (dir == null) return false;
    try {
      final res = await _client.dio.get<List<int>>(
        _urlFor(filename),
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = res.data;
      if (bytes == null) return false;
      final file = File('${dir.path}/$filename');
      // Write beside the real path and rename on success. A download killed halfway (app
      // backgrounded, signal lost) must not leave a truncated image where the next launch would
      // treat it as a complete face — rename is atomic, a half-written .part never gets promoted.
      final temp = File('${file.path}.part');
      await temp.writeAsBytes(bytes);
      await temp.rename(file.path);
      // The on-disk path is our [FileImage] cache key and carries no version, so overwriting the
      // bytes leaves Flutter's in-memory ImageCache holding the OLD decoded face. Evict it so the
      // new version shows without an app restart.
      await FileImage(file).evict();
      _downloaded[filename] = face.version;
      await _prefs?.setString(_versionsKey, jsonEncode(_downloaded));
      return true;
    } catch (e) {
      debugPrint('Card image download failed for $filename: $e');
      return false;
    }
  }

  /// The faces a [sync] would download right now (missing, or a version behind).
  List<MapEntry<String, _Face>> _staleFaces(Directory dir) {
    return _faces.entries.where((e) {
      final file = File('${dir.path}/${e.key}');
      return !file.existsSync() || (_downloaded[e.key] ?? -1) != e.value.version;
    }).toList();
  }

  /// How much a full sync would download now: the number of faces and the summed byte size of the
  /// ones whose size the manifest reported. Used by the Settings button to show the cost up front.
  ({int count, int bytes}) pendingDownload() {
    final dir = _cacheDir;
    if (dir == null) return (count: 0, bytes: 0);
    var count = 0;
    var bytes = 0;
    for (final entry in _staleFaces(dir)) {
      count++;
      bytes += entry.value.bytes ?? 0;
    }
    return (count: count, bytes: bytes);
  }

  /// Runs a bulk sync only if the user's [CardDownloadMode] permits it on the current connection.
  /// Called at startup. The manual Settings action bypasses this and calls [sync] directly.
  Future<void> maybeAutoSync() async {
    if (kIsWeb) return;
    switch (SettingsService().cardDownloadMode) {
      case CardDownloadMode.onDemand:
        return; // faces cache lazily as they're viewed
      case CardDownloadMode.always:
        await sync();
      case CardDownloadMode.wifiOnly:
        final results = await Connectivity().checkConnectivity();
        if (results.contains(ConnectivityResult.wifi)) await sync();
    }
  }

  /// Downloads every face whose on-disk copy is missing or a version behind (mobile only; no-op on
  /// web). Safe to run in the background and to call repeatedly. Progress is published on
  /// [syncStatus] for the whole run. Already-downloaded, up-to-date faces are skipped, so an
  /// interrupted sync resumes rather than starting over. Pass [refresh] (the manual Settings action)
  /// to re-fetch the manifest first, picking up newly added cards and version bumps.
  Future<void> sync({bool refresh = false}) async {
    final dir = _cacheDir;
    if (kIsWeb || dir == null) return;
    if (_syncing) return; // a sync is already running; let it finish
    _syncing = true;
    syncStatus.value = const CardSyncStatus(0, 0);
    try {
      if (refresh) {
        // A failure here is non-fatal as long as we already have a manifest to work from.
        try {
          await loadManifest();
        } catch (e) {
          debugPrint('Card manifest reload failed: $e');
        }
      } else if (!_manifestLoaded) {
        try {
          await loadManifest();
        } catch (_) {
          return;
        }
      }

      final stale = _staleFaces(dir);
      var done = 0;
      syncStatus.value = CardSyncStatus(done, stale.length);
      for (final entry in stale) {
        await _downloadFace(entry.key, entry.value);
        done++;
        syncStatus.value = CardSyncStatus(done, stale.length);
      }

      await _pruneOrphans(dir);
    } finally {
      _syncing = false;
      syncStatus.value = null;
    }
  }
}

/// Snapshot of an in-flight card-image sync: [done] of [total] faces downloaded.
@immutable
class CardSyncStatus {
  const CardSyncStatus(this.done, this.total);

  final int done;
  final int total;
}

class _Face {
  const _Face(this.urlPath, this.version, {this.bytes});

  /// Root-relative, version-busted path, e.g. "/cards/guild-baroni-front.png?v=3".
  final String urlPath;
  final int version;

  /// File size in bytes as reported by the manifest, or null (persisted seed, or not reported).
  final int? bytes;
}
