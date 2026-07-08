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
  }

  String _filenameOf(String url) => Uri.parse(url).pathSegments.last;

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
  /// web). Safe to run in the background and to call repeatedly. [onProgress] reports (done, total).
  /// With [force] every face is re-downloaded even if an up-to-date copy already exists — used by
  /// the manual "sync card images" action in settings to repair a partial or corrupt cache.
  Future<void> sync({bool force = false, void Function(int done, int total)? onProgress}) async {
    final dir = _cacheDir;
    if (kIsWeb || dir == null) return;
    if (!_manifestLoaded) {
      try {
        await loadManifest();
      } catch (_) {
        return;
      }
    }

    final stale = _faces.entries.where((e) {
      final file = File('${dir.path}/${e.key}');
      return force || !file.existsSync() || (_downloaded[e.key] ?? -1) != e.value.version;
    }).toList();

    var done = 0;
    for (final entry in stale) {
      try {
        final res = await _client.dio.get<List<int>>(
          _urlFor(entry.key),
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = res.data;
        if (bytes != null) {
          await File('${dir.path}/${entry.key}').writeAsBytes(bytes);
          _downloaded[entry.key] = entry.value.version;
        }
      } catch (e) {
        debugPrint('Card image download failed for ${entry.key}: $e');
      }
      done++;
      onProgress?.call(done, stale.length);
    }
    await _prefs?.setString(_versionsKey, jsonEncode(_downloaded));
  }
}

class _Face {
  const _Face(this.urlPath, this.version);

  /// Root-relative, version-busted path, e.g. "/cards/guild-baroni-front.png?v=3".
  final String urlPath;
  final int version;
}
