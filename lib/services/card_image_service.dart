import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

/// Serves card face images without bundling them (~600 MB) in the app.
///
/// The backend hosts the PNGs under /cards and exposes GET /api/v1/cards/manifest, which lists
/// each card's `internal_version` and versioned front/back URLs. On mobile we download faces into
/// a local cache directory and re-download one only when its version increases; on web we hand the
/// URL straight to [NetworkImage] and let the browser's HTTP cache do the caching.
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

  /// filename -> version currently stored on disk. Persisted so a stale face is re-fetched only
  /// after its version actually changes, not on every launch.
  Map<String, int> _downloaded = {};

  bool _manifestLoaded = false;

  /// True once an *unfiltered* manifest (the whole catalog) has been loaded. Pruning orphaned faces
  /// off disk is only safe against a full manifest — a faction-filtered one would look like every
  /// other gang's cards had been removed.
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
    if (!kIsWeb) {
      final base = await getApplicationSupportDirectory();
      _cacheDir = Directory('${base.path}/card_images');
      await _cacheDir!.create(recursive: true);
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs!.getString(_versionsKey);
      if (raw != null) {
        _downloaded = (jsonDecode(raw) as Map)
            .map((k, v) => MapEntry(k as String, (v as num).toInt()));
      }
    }
    try {
      await loadManifest();
    } catch (e) {
      debugPrint('Card manifest load failed: $e');
    }
  }

  /// Fetches the manifest and indexes every face by filename. [faction] narrows it to one gang.
  Future<void> loadManifest({String? faction}) async {
    final res = await _client.dio.get<Map<String, dynamic>>(
      '/cards/manifest',
      queryParameters: (faction != null) ? {'faction': faction} : null,
    );
    final cards = (res.data?['cards'] as List?) ?? const [];
    for (final c in cards) {
      final m = c as Map<String, dynamic>;
      final version = (m['internal_version'] as num?)?.toInt() ?? 1;
      for (final url in [m['front_url'], m['back_url']]) {
        if (url is String && url.isNotEmpty) {
          _faces[_filenameOf(url)] = _Face(url, version);
        }
      }
    }
    _manifestLoaded = true;
    if (faction == null) _fullManifestLoaded = true;
  }

  String _filenameOf(String url) => Uri.parse(url).pathSegments.last;

  /// Deletes cached faces that are no longer in the catalog — cards that were removed, or whose face
  /// filename changed across a version (the old name would otherwise linger on disk forever, since
  /// [sync] only ever visits faces that are still in the manifest). No-op until a full manifest has
  /// loaded, so a faction-filtered load can't wipe every other gang's faces.
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

  /// Absolute, version-busted URL for a face. Falls back to an unversioned URL when the manifest
  /// has not loaded yet, so the image still resolves.
  String _urlFor(String filename) {
    final path = _faces[filename]?.urlPath ?? '/cards/$filename';
    return '$_origin$path';
  }

  /// [ImageProvider] for a card face filename, or null when the profile has no printed card.
  /// Web -> network (browser cache). Mobile -> the cached file if present, else network while the
  /// background [sync] catches up.
  ImageProvider? provider(String filename) {
    if (filename.isEmpty) return null;
    final dir = _cacheDir;
    if (kIsWeb || dir == null) {
      return NetworkImage(_urlFor(filename));
    }
    final file = File('${dir.path}/$filename');
    if (file.existsSync()) return FileImage(file);
    return NetworkImage(_urlFor(filename));
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

      final stale = _faces.entries.where((e) {
        final file = File('${dir.path}/${e.key}');
        return !file.existsSync() || (_downloaded[e.key] ?? -1) != e.value.version;
      }).toList();

      var done = 0;
      syncStatus.value = CardSyncStatus(done, stale.length);
      for (final entry in stale) {
        try {
          final res = await _client.dio.get<List<int>>(
            _urlFor(entry.key),
            options: Options(responseType: ResponseType.bytes),
          );
          final bytes = res.data;
          if (bytes != null) {
            final file = File('${dir.path}/${entry.key}');
            await file.writeAsBytes(bytes);
            // The on-disk path is our [FileImage] cache key and carries no version, so overwriting
            // the bytes leaves Flutter's in-memory ImageCache holding the OLD decoded face. Evict it
            // so the new version shows without an app restart.
            await FileImage(file).evict();
            _downloaded[entry.key] = entry.value.version;
            // Persist after each face so a sync interrupted by the app being killed resumes from
            // here next launch instead of re-downloading everything it had already fetched.
            await _prefs?.setString(_versionsKey, jsonEncode(_downloaded));
          }
        } catch (e) {
          debugPrint('Card image download failed for ${entry.key}: $e');
        }
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
  const _Face(this.urlPath, this.version);

  /// Root-relative, version-busted path, e.g. "/cards/guild-baroni-front.png?v=3".
  final String urlPath;
  final int version;
}
