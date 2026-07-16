import 'dart:convert';
import 'dart:io';

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'api_exception.dart';

/// One rules PDF offered by the Rules page.
@immutable
class RulesDoc {
  const RulesDoc({required this.key, required this.title, required this.url});

  factory RulesDoc.fromJson(Map<String, dynamic> json) => RulesDoc(
        key: json['key'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
      );

  /// Stable id from the backend. Doubles as the cache filename, so it never changes for a document.
  final String key;
  final String title;

  /// Absolute URL on TT Combat's CDN. Carries a `?v=` cache buster that changes whenever they
  /// republish the file, which is what tells us a cached copy has gone out of date.
  final String url;

  Map<String, dynamic> toJson() => {'key': key, 'title': title, 'url': url};
}

/// Lists the rules PDFs and keeps them on disk so they open instantly, and — the point of the whole
/// exercise — still open at a table with no signal.
///
/// The list itself comes from our backend (GET /rules_documents) rather than being baked into the
/// app, so a link TT Combat has republished can be fixed with a deploy instead of a release. The
/// PDFs are fetched straight from TT Combat's CDN, which means they must NOT go through
/// [ApiClient.dio]: its interceptor attaches the user's bearer token and our client key to every
/// request, and neither has any business being sent to a third party. Hence [_downloader], a bare
/// Dio with no interceptors.
class RulesService {
  static final RulesService _instance = RulesService._();
  factory RulesService() => _instance;
  RulesService._();

  final _client = ApiClient();
  // A bare Dio (no interceptors) for third-party CDN fetches. Timeouts bound a slow/black-hole
  // network so a rules download can't hang forever; the receive window is generous because a
  // rulebook PDF is large.
  final _downloader = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 60),
  ));

  static const _documentsKey = 'rules_documents';
  static const _cachedUrlsKey = 'rules_document_urls';

  Directory? _cacheDir; // null on web, which has no disk cache
  SharedPreferences? _prefs;

  /// Document key -> the URL the copy currently on disk was downloaded from. Persisted, so a cached
  /// PDF is only re-fetched once its URL actually changes rather than on every launch.
  Map<String, String> _cachedUrls = {};

  bool _initialised = false;

  Future<void> _init() async {
    if (_initialised) return;
    _prefs = await SharedPreferences.getInstance();
    if (!kIsWeb) {
      final base = await getApplicationSupportDirectory();
      _cacheDir = Directory('${base.path}/rules_pdfs');
      await _cacheDir!.create(recursive: true);
      final raw = _prefs!.getString(_cachedUrlsKey);
      if (raw != null) {
        _cachedUrls = (jsonDecode(raw) as Map)
            .map((k, v) => MapEntry(k as String, v as String));
      }
    }
    _initialised = true;
  }

  /// The documents to list, newest URLs first. Falls back to the last list we saw when the backend
  /// is unreachable: an already-downloaded rulebook is readable offline, but only if we can still
  /// show a row to tap. Throws only when we have never successfully loaded the list.
  Future<List<RulesDoc>> loadDocuments() async {
    await _init();
    try {
      final res = await _client.rules.getRulesDocuments();
      final docs = (res.data ?? const <api.RulesDocument>[])
          .map((d) => RulesDoc(key: d.key, title: d.title, url: d.url))
          .toList();
      await _prefs?.setString(
        _documentsKey,
        jsonEncode(docs.map((d) => d.toJson()).toList()),
      );
      await _pruneOrphans(docs);
      return docs;
    } on DioException catch (e) {
      final cached = _cachedDocuments();
      if (cached.isNotEmpty) return cached;
      throw ApiException.from(e);
    }
  }

  List<RulesDoc> _cachedDocuments() {
    final raw = _prefs?.getString(_documentsKey);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List)
          .map((j) => RulesDoc.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Cached rules document list unreadable: $e');
      return const [];
    }
  }

  File? _fileFor(RulesDoc doc) {
    final dir = _cacheDir;
    return dir == null ? null : File('${dir.path}/${doc.key}.pdf');
  }

  /// True when [doc] is on disk at its current URL, i.e. it will open with no network at all.
  bool isDownloaded(RulesDoc doc) {
    final file = _fileFor(doc);
    if (file == null) return false;
    return _cachedUrls[doc.key] == doc.url && file.existsSync();
  }

  /// Path to the on-disk copy of [doc], downloading it first if it is missing or if TT Combat has
  /// republished the file since we cached it. Returns null on web, which has no disk cache — those
  /// callers hand the URL to the viewer and let the browser stream it.
  Future<String?> localPath(
    RulesDoc doc, {
    void Function(int received, int total)? onProgress,
  }) async {
    await _init();
    final file = _fileFor(doc);
    if (file == null) return null;
    if (isDownloaded(doc)) return file.path;

    // Download beside the real path and rename on success. A download killed halfway (app
    // backgrounded, signal lost) must not leave a truncated file where the next launch would
    // mistake it for a complete PDF — rename is atomic, a half-written .part never gets promoted.
    final temp = File('${file.path}.part');
    try {
      await _downloader.download(
        doc.url,
        temp.path,
        onReceiveProgress: onProgress,
      );
      await temp.rename(file.path);
      _cachedUrls[doc.key] = doc.url;
      await _prefs?.setString(_cachedUrlsKey, jsonEncode(_cachedUrls));
      return file.path;
    } on DioException catch (e) {
      if (await temp.exists()) await temp.delete();
      // A previous edition beats no rules at all: if the re-download of a republished PDF failed
      // but we still hold the copy we downloaded last time, open that rather than an error screen.
      // It stays marked out of date, so the next visit tries the new URL again.
      if (await file.exists()) return file.path;
      throw ApiException.from(e);
    }
  }

  /// Deletes cached PDFs for documents the backend no longer offers. Keyed on the document key, so
  /// a `.part` file being written by a download in flight — whose key is by definition still in the
  /// list — is never touched.
  Future<void> _pruneOrphans(List<RulesDoc> docs) async {
    final dir = _cacheDir;
    if (dir == null) return;
    final keys = docs.map((d) => d.key).toSet();
    try {
      var changed = false;
      for (final entity in dir.listSync()) {
        if (entity is! File) continue;
        final name = entity.uri.pathSegments.last;
        final key = name.replaceFirst(RegExp(r'\.pdf(\.part)?$'), '');
        if (keys.contains(key)) continue;
        try {
          await entity.delete();
        } catch (e) {
          debugPrint('Rules PDF prune failed for $name: $e');
        }
        if (_cachedUrls.remove(key) != null) changed = true;
      }
      if (changed) await _prefs?.setString(_cachedUrlsKey, jsonEncode(_cachedUrls));
    } catch (e) {
      debugPrint('Rules PDF prune failed: $e');
    }
  }
}
