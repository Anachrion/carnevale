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
  final String frontImage;
  final String backImage;
  final int cardReferenceId;

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
    required this.frontImage,
    required this.backImage,
    required this.cardReferenceId,
  });
}
