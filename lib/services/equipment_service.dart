import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import '../models/equipment.dart';
import 'api_client.dart';
import 'api_exception.dart';

class EquipmentService {
  static final EquipmentService _instance = EquipmentService._();
  factory EquipmentService() => _instance;
  EquipmentService._();

  final _client = ApiClient();

  Future<List<Equipment>> getAll() async {
    try {
      final res = await _client.equipment.getEquipment();
      return (res.data?.toList() ?? []).map(_map).toList();
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  Equipment _map(api.Equipment e) => Equipment(
    id: e.id,
    name: e.name,
    description: e.description,
    cost: e.cost,
  );
}
