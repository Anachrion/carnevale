import 'package:carnevale_api/carnevale_api.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;

  static const _host = 'localhost:3000';

  /// Base URL for the ActionCable WebSocket endpoint, shared with [GameService].
  static const cableUrl = 'ws://$_host/cable';

  ApiClient._() {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://$_host/api/v1',
      // Without this, Devise's failure app treats requests as HTML and redirects
      // (302) instead of returning the documented JSON error body on 401/422.
      headers: {'Accept': 'application/json'},
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
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
