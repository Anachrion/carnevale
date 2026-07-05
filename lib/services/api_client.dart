import 'package:carnevale_api/carnevale_api.dart';
import 'package:dio/dio.dart';

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
    final dio = Dio(BaseOptions(
      baseUrl: '$_httpScheme://$_host/api/v1',
      // Without this, Devise's failure app treats requests as HTML and redirects
      // (302) instead of returning the documented JSON error body on 401/422.
      headers: {'Accept': 'application/json'},
    ));
    dio.interceptors.add(InterceptorsWrapper(
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
    session = SessionApi(dio, standardSerializers);
    lists = ListsApi(dio, standardSerializers);
    listEntries = ListEntriesApi(dio, standardSerializers);
    profiles = ProfilesApi(dio, standardSerializers);
    equipment = EquipmentApi(dio, standardSerializers);
    games = GamesApi(dio, standardSerializers);
    scenarios = ScenariosApi(dio, standardSerializers);
    spells = SpellsApi(dio, standardSerializers);
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
