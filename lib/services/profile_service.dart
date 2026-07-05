import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_exception.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._();
  factory ProfileService() => _instance;
  ProfileService._();

  final _client = ApiClient();
  List<api.Profile>? _cache;

  Future<List<api.Profile>> loadAll() async {
    if (_cache != null) return _cache!;
    try {
      final res = await _client.profiles.getProfiles();
      _cache = (res.data?.toList() ?? [])
        ..sort((a, b) => a.name.compareTo(b.name));
      return _cache!;
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<List<api.Profile>> search(
    String query, {
    Set<String>? factions,
  }) async {
    final all = await loadAll();
    final q = query.toLowerCase().trim();
    return all.where((p) {
      final matchesFaction =
          factions == null || factions.isEmpty || factions.contains(p.faction);
      final matchesQuery = q.isEmpty || p.name.toLowerCase().contains(q);
      return matchesFaction && matchesQuery;
    }).toList();
  }

  Future<List<String>> factions() async {
    final all = await loadAll();
    return all.map((p) => p.faction).toSet().toList()..sort();
  }
}
