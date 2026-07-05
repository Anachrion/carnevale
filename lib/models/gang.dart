import 'package:carnevale_api/carnevale_api.dart' as api;

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
  final api.EntryState? state;

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

  ListEntry copyWith({api.EntryState? state}) => ListEntry(
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
