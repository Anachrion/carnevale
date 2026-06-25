class GangMember {
  final int profileId;
  final String profileName;
  final String faction;
  final int ducats;
  final int count;

  const GangMember({
    required this.profileId,
    required this.profileName,
    required this.faction,
    required this.ducats,
    required this.count,
  });

  int get totalDucats => ducats * count;

  GangMember copyWith({int? count}) => GangMember(
        profileId: profileId,
        profileName: profileName,
        faction: faction,
        ducats: ducats,
        count: count ?? this.count,
      );

  Map<String, dynamic> toJson() => {
        'profileId': profileId,
        'profileName': profileName,
        'faction': faction,
        'ducats': ducats,
        'count': count,
      };

  factory GangMember.fromJson(Map<String, dynamic> j) => GangMember(
        profileId: j['profileId'] as int,
        profileName: j['profileName'] as String,
        faction: j['faction'] as String,
        ducats: j['ducats'] as int,
        count: j['count'] as int,
      );
}

class Gang {
  final String id;
  final String name;
  final String faction;
  final List<GangMember> members;
  final int pointLimit;

  const Gang({
    required this.id,
    required this.name,
    required this.faction,
    required this.members,
    this.pointLimit = 100,
  });

  int get totalDucats => members.fold(0, (sum, m) => sum + m.totalDucats);
  int get memberCount => members.fold(0, (sum, m) => sum + m.count);

  Gang copyWith({
    String? name,
    String? faction,
    List<GangMember>? members,
    int? pointLimit,
  }) =>
      Gang(
        id: id,
        name: name ?? this.name,
        faction: faction ?? this.faction,
        members: members ?? this.members,
        pointLimit: pointLimit ?? this.pointLimit,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'faction': faction,
        'members': members.map((m) => m.toJson()).toList(),
        'pointLimit': pointLimit,
      };

  factory Gang.fromJson(Map<String, dynamic> j) => Gang(
        id: j['id'] as String,
        name: j['name'] as String,
        faction: j['faction'] as String,
        members: (j['members'] as List<dynamic>)
            .map((e) => GangMember.fromJson(e as Map<String, dynamic>))
            .toList(),
        pointLimit: j['pointLimit'] as int? ?? 100,
      );
}
