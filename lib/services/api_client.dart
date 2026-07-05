import 'package:carnevale_api/carnevale_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

  /// Base URL for the ActionCable WebSocket endpoint, shared with [GameService].
  static const cableUrl = '$_wsScheme://$_host/cable';

  /// Shared client key identifying this build as an official Carnevale frontend, injected at
  /// build time via `--dart-define=API_KEY=...`. Sent as `X-Api-Key` on every request. When the
  /// backend has API_KEY configured it rejects requests without it; when this build has no key
  /// baked in the header is omitted, matching the backend's fail-open behaviour for local dev.
  static const _apiKey = String.fromEnvironment('API_KEY');

  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: '$_httpScheme://$_host/api/v1',
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
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401 && !error.requestOptions.path.endsWith('/login')) {
          onUnauthorized?.call();
        }
        handler.next(error);
      },
    ));
    session = SessionApi(_dio, standardSerializers);
    lists = ListsApi(_dio, standardSerializers);
    listEntries = ListEntriesApi(_dio, standardSerializers);
    profiles = ProfilesApi(_dio, standardSerializers);
    equipment = EquipmentApi(_dio, standardSerializers);
    games = GamesApi(_dio, standardSerializers);
    scenarios = ScenariosApi(_dio, standardSerializers);
    spells = SpellsApi(_dio, standardSerializers);
  }

  late final Dio _dio;

  /// The underlying Dio, exposed only so tests can swap in a fake HttpClientAdapter and drive the
  /// services against canned responses.
  @visibleForTesting
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

  /// Called when a request fails with 401, so [AuthService] can clear the stale session.
  void Function()? onUnauthorized;

  late final SessionApi session;
  late final ListsApi lists;
  late final ListEntriesApi listEntries;
  late final ProfilesApi profiles;
  late final EquipmentApi equipment;
  late final GamesApi games;
  late final ScenariosApi scenarios;
  late final SpellsApi spells;
}
