import 'dart:convert';

class Weapon {
  final String name;
  final int damage;
  final int range;
  final int penetration;
  final int evasion;
  final List<String> abilities;

  const Weapon({
    required this.name,
    required this.damage,
    required this.range,
    required this.penetration,
    required this.evasion,
    required this.abilities,
  });

  factory Weapon.fromJson(Map<String, dynamic> j) => Weapon(
        name: j['name'] as String,
        damage: j['damage'] as int,
        range: j['range'] as int,
        penetration: j['penetration'] as int,
        evasion: j['evasion'] as int,
        abilities: _parseStringList(j['abilities']),
      );
}

class SpecialRule {
  final String name;
  final String description;
  final String? spellName;
  final int? spellCost;
  final int? spellDifficulty;
  final String? spellDescription;

  const SpecialRule({
    required this.name,
    required this.description,
    this.spellName,
    this.spellCost,
    this.spellDifficulty,
    this.spellDescription,
  });

  factory SpecialRule.fromJson(Map<String, dynamic> j) => SpecialRule(
        name: j['name'] as String,
        description: j['description'] as String,
        spellName: j['spell_name'] as String?,
        spellCost: j['spell_cost'] as int?,
        spellDifficulty: j['spell_difficulty'] as int?,
        spellDescription: j['spell_description'] as String?,
      );
}

class Profile {
  final int id;
  final String name;
  final String faction;
  final int ducats;
  final int movement;
  final int attack;
  final int dexterity;
  final int lifePoints;
  final int mind;
  final int willPoints;
  final int protection;
  final int actionPoints;
  final int commandPoints;
  final int size;
  final List<String> abilities;
  final List<String> keywords;
  final String version;
  final List<Weapon> weapons;
  final List<SpecialRule> specialRules;

  const Profile({
    required this.id,
    required this.name,
    required this.faction,
    required this.ducats,
    required this.movement,
    required this.attack,
    required this.dexterity,
    required this.lifePoints,
    required this.mind,
    required this.willPoints,
    required this.protection,
    required this.actionPoints,
    required this.commandPoints,
    required this.size,
    required this.abilities,
    required this.keywords,
    required this.version,
    required this.weapons,
    required this.specialRules,
  });

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        id: j['id'] as int,
        name: j['name'] as String,
        faction: j['faction'] as String,
        ducats: j['ducats'] as int,
        movement: j['movement'] as int,
        attack: j['attack'] as int,
        dexterity: j['dexterity'] as int,
        lifePoints: j['life_points'] as int,
        mind: j['mind'] as int,
        willPoints: j['will_points'] as int,
        protection: j['protection'] as int,
        actionPoints: j['action_points'] as int,
        commandPoints: j['command_points'] as int,
        size: j['size'] as int,
        abilities: _parseStringList(j['abilities']),
        keywords: _parseStringList(j['keywords']),
        version: j['version'] as String,
        weapons: _parseList(j['weapons'], Weapon.fromJson),
        specialRules: _parseList(j['special_rules'], SpecialRule.fromJson),
      );
}

List<String> _parseStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) return value.cast<String>();
  if (value is String) {
    try {
      final parsed = jsonDecode(value);
      if (parsed is List) return parsed.cast<String>();
    } catch (_) {}
  }
  return [];
}

List<T> _parseList<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
  if (value is String) {
    try {
      final parsed = jsonDecode(value);
      if (parsed is List) {
        return parsed.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
  }
  return [];
}
