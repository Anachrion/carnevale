class EntryStatValue {
  final int current;
  final int starting;

  const EntryStatValue({required this.current, required this.starting});
}

class EntryState {
  final EntryStatValue lifePoints;
  final EntryStatValue willPoints;
  final EntryStatValue commandPoints;
  final bool stunned;
  final bool hidden;
  final bool guarding;
  final bool carryingObjective;
  final int underwaterCounters;

  const EntryState({
    required this.lifePoints,
    required this.willPoints,
    required this.commandPoints,
    required this.stunned,
    required this.hidden,
    required this.guarding,
    required this.carryingObjective,
    required this.underwaterCounters,
  });
}

class Spell {
  final int id;
  final String name;
  final String discipline;
  final int cost;
  final int difficulty;
  final bool cantrip;
  final String description;

  const Spell({
    required this.id,
    required this.name,
    required this.discipline,
    required this.cost,
    required this.difficulty,
    required this.cantrip,
    required this.description,
  });
}

class ListEntry {
  final int id;
  final int position;
  final String entryType;
  final int entryId;
  final String name;
  final int cost;
  final EntryState? state;

  // Spell selection (rulebook p24). Only Mage models can be given spells.
  final bool mage;
  final int spellSlots;
  final List<String> disciplines;
  final String? spellDiscipline;
  final Spell? cantrip;
  final List<Spell> spells;

  const ListEntry({
    required this.id,
    required this.position,
    required this.entryType,
    required this.entryId,
    required this.name,
    required this.cost,
    this.state,
    this.mage = false,
    this.spellSlots = 0,
    this.disciplines = const [],
    this.spellDiscipline,
    this.cantrip,
    this.spells = const [],
  });

  ListEntry copyWith({EntryState? state}) => ListEntry(
        id: id,
        position: position,
        entryType: entryType,
        entryId: entryId,
        name: name,
        cost: cost,
        state: state ?? this.state,
        mage: mage,
        spellSlots: spellSlots,
        disciplines: disciplines,
        spellDiscipline: spellDiscipline,
        cantrip: cantrip,
        spells: spells,
      );
}

class Gang {
  final int id;
  final String name;
  final String faction;
  final int points;
  final int totalCost;
  final List<ListEntry> entries;
  final bool selectionValid;
  final List<String> selectionErrors;

  const Gang({
    required this.id,
    required this.name,
    required this.faction,
    required this.points,
    this.totalCost = 0,
    this.entries = const [],
    this.selectionValid = true,
    this.selectionErrors = const [],
  });
}
