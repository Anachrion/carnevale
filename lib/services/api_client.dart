// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'dart:ui' show PlatformDispatcher;

import 'package:carnevale_api/carnevale_api.dart';
import 'package:dio/dio.dart';

import 'settings_service.dart';

/// How a refresh attempt ended.
///
/// The distinction between the two failure modes is the whole point of this type. Only
/// [rejected] — the server answered and refused the refresh token — proves the session is
/// unrecoverable. [unavailable] means the attempt never reached a verdict (no connectivity, a
/// timeout, a 5xx while the backend restarts, a 429 from rate limiting); it says nothing about
/// the credential. Collapsing the two, as this code once did, logs the user out permanently
/// over a two-second network blip: the stored refresh token is the only way back into the
/// account, and clearing it cannot be undone once the network returns.
enum RefreshStatus { renewed, rejected, unavailable }

class RefreshOutcome {
  const RefreshOutcome.renewed(String this.token) : status = RefreshStatus.renewed;

  const RefreshOutcome.rejected()
      : status = RefreshStatus.rejected,
        token = null;

  const RefreshOutcome.unavailable()
      : status = RefreshStatus.unavailable,
        token = null;

  final RefreshStatus status;

  /// The new access token — non-null exactly when [status] is [RefreshStatus.renewed].
  final String? token;
}

class ApiClient {
  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;

  /// Backend host (and port), overridable at build time via `--dart-define=API_HOST=...`. Defaults
  /// to the local dev server so `flutter run` works with no extra flags.
  static const _host = String.fromEnvironment('API_HOST', defaultValue: 'localhost:3000');

  /// Whether to talk to the backend over TLS. Off by default (local dev is plain http/ws); set
  /// `--dart-define=API_USE_TLS=true` for any deployed environment so REST goes over https and the
  /// WebSocket over wss. Serving the backend itself over TLS is a deployment concern.
  static const _useTls = bool.fromEnvironment('API_USE_TLS', defaultValue: false);
  static const _httpScheme = _useTls ? 'https' : 'http';
  static const _wsScheme = _useTls ? 'wss' : 'ws';

  /// Backend origin (scheme + host, no trailing slash). The REST base URL is built on it, and
  /// anything that needs a plain web URL off the same server — the printable card sheets page, say
  /// — can link against it instead of re-deriving the host.
  static const origin = '$_httpScheme://$_host';

  /// Base URL for the ActionCable WebSocket endpoint, shared with [GameService].
  static const cableUrl = '$_wsScheme://$_host/cable';

  /// Shared client key identifying this build as an official Carnevale frontend, injected at
  /// build time via `--dart-define=API_KEY=...`. Sent as `X-Api-Key` on every request. When the
  /// backend has API_KEY configured it rejects requests without it; when this build has no key
  /// baked in the header is omitted, matching the backend's fail-open behaviour for local dev.
  static const _apiKey = String.fromEnvironment('API_KEY');

  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: '$origin/api/v1',
      // Bound every request so a black-hole network (captive portal, dead wifi that still accepts
      // SYNs) surfaces as a timeout the caller can show, instead of an indefinite hang / spinner.
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      // Without this, Devise's failure app treats requests as HTML and redirects
      // (302) instead of returning the documented JSON error body on 401/422.
      headers: {'Accept': 'application/json'},
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_apiKey.isNotEmpty) {
          options.headers['X-Api-Key'] = _apiKey;
        }
        if (authToken != null) {
          options.headers['Authorization'] = 'Bearer $authToken';
        }
        // Tell the backend which language to render server-side messages in (validation/auth
        // errors). Mirrors the app's own locale: the user's pinned choice, or the device locale
        // when they follow the system. Read fresh per request so it tracks a mid-session change.
        options.headers['Accept-Language'] = _acceptLanguage();
        handler.next(options);
      },
      onError: (error, handler) async {
        final options = error.requestOptions;
        final path = options.path;
        // /login and /token are the endpoints that mint tokens; a 401 from them is a real auth
        // failure, not an expired access token, so they never trigger a refresh-and-retry.
        final isAuthEndpoint = path.endsWith('/login') || path.endsWith('/token');
        final alreadyRetried = options.extra[_retriedKey] == true;

        // A 401 on any other request means the short-lived access token has expired. Renew it once
        // from the refresh token and replay the original request transparently; only clear the
        // session if the renewal itself fails. The already-retried guard stops a still-401 replay
        // from looping.
        if (error.response?.statusCode == 401 && !isAuthEndpoint && !alreadyRetried) {
          final outcome = await _refreshOnce();
          final newToken = outcome.token;
          if (newToken != null) {
            options
              ..extra[_retriedKey] = true
              ..headers['Authorization'] = 'Bearer $newToken';
            try {
              return handler.resolve(await _dio.fetch(options));
            } on DioException catch (e) {
              if (e.response?.statusCode == 401) onUnauthorized?.call();
              return handler.reject(e);
            }
          }
          // Only tear the session down when the server actually rejected the refresh token. If the
          // renewal simply couldn't reach the backend, surface the error and leave the stored
          // credentials alone so the next attempt can still recover.
          if (outcome.status == RefreshStatus.rejected) onUnauthorized?.call();
        }
        handler.next(error);
      },
    ));
    session = SessionApi(_dio, standardSerializers);
    lists = ListsApi(_dio, standardSerializers);
    listEntries = ListEntriesApi(_dio, standardSerializers);
    profiles = ProfilesApi(_dio, standardSerializers);
    collection = CollectionApi(_dio, standardSerializers);
    abilities = AbilitiesApi(_dio, standardSerializers);
    equipment = EquipmentApi(_dio, standardSerializers);
    games = GamesApi(_dio, standardSerializers);
    scenarios = ScenariosApi(_dio, standardSerializers);
    spells = SpellsApi(_dio, standardSerializers);
    rules = RulesApi(_dio, standardSerializers);
  }

  /// Language tag for the Accept-Language header: the user's pinned locale if set, otherwise the
  /// device's current locale. The backend only honours locales it supports and falls back to
  /// English otherwise, so sending the raw device language (which may be neither en nor fr) is safe.
  String _acceptLanguage() {
    final pinned = SettingsService().locale?.languageCode;
    return pinned ?? PlatformDispatcher.instance.locale.languageCode;
  }

  late final Dio _dio;

  /// The underlying Dio (base URL, client key and auth interceptors already wired). Exposed for
  /// endpoints that aren't in the generated client — the card image manifest and the static /cards
  /// files (see CardImageService) — and so tests can swap in a fake HttpClientAdapter.
  Dio get dio => _dio;

  /// Fetches a short-lived, single-use cable ticket over authenticated REST and returns the full
  /// ActionCable URL to connect with. Only the disposable ticket — never the reusable JWT — rides
  /// in the query string, so a URL that leaks into logs is already worthless. Called fresh for
  /// every connection attempt, including reconnects, since each ticket opens exactly one socket.
  Future<String> cableConnectionUrl() async {
    final res = await _dio.post<Map<String, dynamic>>('/cable_tickets');
    final ticket = res.data?['ticket'] as String?;
    if (ticket == null || ticket.isEmpty) {
      throw StateError('cable ticket missing from response');
    }
    return '$cableUrl?ticket=$ticket';
  }

  /// Set by [AuthService] once a user is logged in; sent as a Bearer token on every request.
  String? authToken;

  /// Called when a request fails with 401 and the session can't be recovered, so [AuthService]
  /// can clear the stale session.
  void Function()? onUnauthorized;

  /// Set by [AuthService]: renews the access token from the stored refresh token, reporting both
  /// the new token and *why* it failed when it didn't. Invoked on a 401 to recover silently
  /// instead of logging the user out.
  Future<RefreshOutcome> Function()? performRefresh;

  /// Marks a request that has already been replayed after a refresh, so a still-401 replay falls
  /// through to [onUnauthorized] instead of triggering another refresh.
  static const _retriedKey = 'carnevale_retried';

  Future<RefreshOutcome>? _refreshInFlight;

  /// Runs at most one refresh at a time: concurrent 401s (a screen firing several requests at once)
  /// all await the same renewal, so the single-use refresh token is rotated once, not once per
  /// request — which would invalidate all but the first.
  ///
  /// With no [performRefresh] wired there is no credential to renew from, which is a genuine
  /// dead end rather than a transient one — report it as [RefreshStatus.rejected].
  Future<RefreshOutcome> _refreshOnce() {
    return _refreshInFlight ??=
        (performRefresh?.call() ??
                Future<RefreshOutcome>.value(const RefreshOutcome.rejected()))
            .whenComplete(() => _refreshInFlight = null);
  }

  late final SessionApi session;
  late final ListsApi lists;
  late final ListEntriesApi listEntries;
  late final ProfilesApi profiles;
  late final CollectionApi collection;
  late final AbilitiesApi abilities;
  late final EquipmentApi equipment;
  late final GamesApi games;
  late final ScenariosApi scenarios;
  late final SpellsApi spells;
  late final RulesApi rules;
}
