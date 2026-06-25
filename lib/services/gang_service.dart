import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gang.dart';

class GangService {
  static final GangService _instance = GangService._();
  factory GangService() => _instance;
  GangService._();

  static const _key = 'gangs';

  List<Gang>? _cache;

  Future<List<Gang>> loadAll() async {
    if (_cache != null) return List.unmodifiable(_cache!);
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      _cache = [];
    } else {
      final list = jsonDecode(raw) as List<dynamic>;
      _cache = list.map((e) => Gang.fromJson(e as Map<String, dynamic>)).toList();
    }
    return List.unmodifiable(_cache!);
  }

  Future<void> save(Gang gang) async {
    final all = List<Gang>.from(await loadAll());
    final idx = all.indexWhere((g) => g.id == gang.id);
    if (idx >= 0) {
      all[idx] = gang;
    } else {
      all.add(gang);
    }
    await _persist(all);
  }

  Future<void> delete(String id) async {
    final all = List<Gang>.from(await loadAll());
    all.removeWhere((g) => g.id == id);
    await _persist(all);
  }

  Future<void> _persist(List<Gang> gangs) async {
    _cache = gangs;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(gangs.map((g) => g.toJson()).toList()));
  }

  String generateId() => DateTime.now().microsecondsSinceEpoch.toString();
}
