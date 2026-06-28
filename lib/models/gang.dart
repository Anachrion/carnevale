class ListEntry {
  final int id;
  final int position;
  final String entryType;
  final int entryId;
  final String name;
  final int cost;

  const ListEntry({
    required this.id,
    required this.position,
    required this.entryType,
    required this.entryId,
    required this.name,
    required this.cost,
  });
}

class Gang {
  final int id;
  final String name;
  final String faction;
  final int points;
  final int totalCost;
  final List<ListEntry> entries;

  const Gang({
    required this.id,
    required this.name,
    required this.faction,
    required this.points,
    this.totalCost = 0,
    this.entries = const [],
  });
}
