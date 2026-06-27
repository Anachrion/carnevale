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

  factory ListEntry.fromJson(Map<String, dynamic> j) => ListEntry(
        id: j['id'] as int,
        position: j['position'] as int,
        referenceId: j['reference_id'] as int,
        name: j['name'] as String,
        cost: j['cost'] as int,
      );
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

  Gang copyWith({List<ListEntry>? entries, int? totalCost}) => Gang(
        id: id,
        name: name,
        faction: faction,
        points: points,
        totalCost: totalCost ?? this.totalCost,
        entries: entries ?? this.entries,
      );

  factory Gang.fromJson(Map<String, dynamic> j) => Gang(
        id: j['id'] as int,
        name: j['name'] as String,
        faction: j['faction'] as String,
        points: j['points'] as int,
        totalCost: j['total_cost'] as int? ?? 0,
        entries: j['entries'] != null
            ? (j['entries'] as List<dynamic>)
                .map((e) => ListEntry.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );
}
