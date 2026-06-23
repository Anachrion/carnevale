import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/profile.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._();
  factory ProfileService() => _instance;
  ProfileService._();

  List<Profile>? _profiles;

  Future<List<Profile>> loadAll() async {
    if (_profiles != null) return _profiles!;
    final raw = await rootBundle.loadString('assets/data/profiles.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _profiles = list.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _profiles!;
  }

  Future<List<Profile>> search(String query, {String? faction}) async {
    final all = await loadAll();
    final q = query.toLowerCase().trim();
    return all.where((p) {
      final matchesFaction = faction == null || p.faction == faction;
      final matchesQuery = q.isEmpty || p.name.toLowerCase().contains(q);
      return matchesFaction && matchesQuery;
    }).toList();
  }

  Future<List<String>> factions() async {
    final all = await loadAll();
    return all.map((p) => p.faction).toSet().toList()..sort();
  }
}
