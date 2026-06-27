import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gang.dart';

class GangService {
  static final GangService _instance = GangService._();
  factory GangService() => _instance;
  GangService._();

  static const _base = 'http://localhost:3000/api/v1';

  Future<List<Gang>> loadAll() async {
    final res = await http.get(Uri.parse('$_base/lists'));
    _check(res);
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => Gang.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Gang> loadOne(int id) async {
    final res = await http.get(Uri.parse('$_base/lists/$id'));
    _check(res);
    return Gang.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Gang> create(String name, String faction, int points) async {
    final res = await http.post(
      Uri.parse('$_base/lists'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'list': {'name': name, 'faction': faction, 'points': points}}),
    );
    _check(res);
    return Gang.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    final res = await http.delete(Uri.parse('$_base/lists/$id'));
    _check(res, allowNoContent: true);
  }

  Future<Gang> addEntry(int listId, int referenceId) async {
    final res = await http.post(
      Uri.parse('$_base/lists/$listId/entries'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'entry': {'reference_id': referenceId}}),
    );
    _check(res);
    return Gang.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Gang> removeEntry(int listId, int entryId) async {
    final res = await http.delete(Uri.parse('$_base/lists/$listId/entries/$entryId'));
    _check(res);
    return Gang.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  void _check(http.Response res, {bool allowNoContent = false}) {
    if (allowNoContent && res.statusCode == 204) return;
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API error ${res.statusCode}: ${res.body}');
    }
  }
}
