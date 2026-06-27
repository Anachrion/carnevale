import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/profile.dart';
import 'api_client.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._();
  factory ProfileService() => _instance;
  ProfileService._();

  final _client = ApiClient();
  List<Profile>? _cache;

  Future<List<Profile>> loadAll() async {
    if (_cache != null) return _cache!;
    final res = await _client.profiles.getProfiles();
    _cache = (res.data?.toList() ?? []).map(_mapProfile).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _cache!;
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

  void invalidateCache() => _cache = null;

  Profile _mapProfile(api.Profile p) {
    final ref = p.cardReferences.isNotEmpty ? p.cardReferences.first : null;
    return Profile(
      id: p.id,
      name: p.name,
      faction: p.faction,
      ducats: p.ducats,
      movement: p.movement,
      attack: p.attack,
      dexterity: p.dexterity,
      lifePoints: p.lifePoints,
      mind: p.mind,
      willPoints: p.willPoints,
      protection: p.protection,
      actionPoints: p.actionPoints,
      commandPoints: p.commandPoints,
      size: p.size,
      abilities: p.abilities.toList(),
      keywords: p.keywords.toList(),
      version: p.version,
      weapons: p.weapons.map(_mapWeapon).toList(),
      specialRules: p.specialRules.map(_mapSpecialRule).toList(),
      frontImage: ref?.cardFront ?? '',
      backImage: ref?.cardBack ?? '',
      cardReferenceId: ref?.id ?? 0,
    );
  }

  Weapon _mapWeapon(api.Weapon w) => Weapon(
        name: w.name,
        damage: w.damage,
        range: w.range,
        penetration: w.penetration,
        evasion: w.evasion,
        abilities: w.abilities.toList(),
      );

  SpecialRule _mapSpecialRule(api.SpecialRule r) => SpecialRule(
        name: r.name,
        description: r.description,
        spellName: r.spellName,
        spellCost: r.spellCost,
        spellDifficulty: r.spellDifficulty,
        spellDescription: r.spellDescription,
      );
}
