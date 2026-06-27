class ListEntry {
  final int id;
  final int position;
  final int referenceId;
  final String name;
  final int cost;

  const ListEntry({
    required this.id,
    required this.position,
    required this.referenceId,
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
