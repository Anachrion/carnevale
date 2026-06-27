import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._();
  factory ProfileService() => _instance;
  ProfileService._();

  static const _base = 'http://localhost:3000/api/v1';

  List<Profile>? _profiles;

  Future<List<Profile>> loadAll() async {
    if (_profiles != null) return _profiles!;
    final res = await http.get(Uri.parse('$_base/profiles'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API error ${res.statusCode}: ${res.body}');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    _profiles = list.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _profiles!;
  }

  Future<List<Profile>> search(String query, {Set<String>? factions}) async {
    final all = await loadAll();
    final q = query.toLowerCase().trim();
    return all.where((p) {
      final matchesFaction = factions == null || factions.isEmpty || factions.contains(p.faction);
      final matchesQuery = q.isEmpty || p.name.toLowerCase().contains(q);
      return matchesFaction && matchesQuery;
    }).toList();
  }

  Future<List<String>> factions() async {
    final all = await loadAll();
    return all.map((p) => p.faction).toSet().toList()..sort();
  }

  void invalidateCache() => _profiles = null;
}
