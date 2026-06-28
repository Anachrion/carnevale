import 'package:carnevale_api/carnevale_api.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;

  ApiClient._() {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api/v1'));
    lists = ListsApi(dio, standardSerializers);
    listEntries = ListEntriesApi(dio, standardSerializers);
    profiles = ProfilesApi(dio, standardSerializers);
    equipment = EquipmentApi(dio, standardSerializers);
  }

  late final ListsApi lists;
  late final ListEntriesApi listEntries;
  late final ProfilesApi profiles;
  late final EquipmentApi equipment;
}
