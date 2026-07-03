class Agenda {
  final int id;
  final String name;
  final String description;

  const Agenda({required this.id, required this.name, required this.description});
}

class GangSummary {
  final int id;
  final String? name;
  final String faction;
  final int points;
  final int totalCost;

  const GangSummary({
    required this.id,
    required this.name,
    required this.faction,
    required this.points,
    required this.totalCost,
  });
}

class GamePlayer {
  final int id;
  final int userId;
  final String username;
  final bool host;
  final GangSummary? list;
  final String? role;
  final String? deploymentZone;
  final int? roleRoll;
  final int? deploymentRoll;
  final bool ready;
  final List<Agenda> agendas;

  const GamePlayer({
    required this.id,
    required this.userId,
    required this.username,
    required this.host,
    this.list,
    this.role,
    this.deploymentZone,
    this.roleRoll,
    this.deploymentRoll,
    this.ready = false,
    this.agendas = const [],
  });
}

class Scenario {
  final int id;
  final String name;
  final int ducats;
  final bool asymmetric;
  final String setup;
  final String primaryObjective;
  final List<String> agendas;
  final List<String> specialRules;
  final String duration;
  final List<String> deploymentZones;
  final String? illustration;

  const Scenario({
    required this.id,
    required this.name,
    required this.ducats,
    required this.asymmetric,
    required this.setup,
    required this.primaryObjective,
    required this.agendas,
    required this.specialRules,
    required this.duration,
    required this.deploymentZones,
    this.illustration,
  });
}

class Game {
  final int id;
  final String joinCode;
  final String status;
  final int ducatLimit;
  final String? boardSize;
  final Scenario scenario;
  final int? roleRollWinnerId;
  final int? deploymentRollWinnerId;
  final List<GamePlayer> players;

  const Game({
    required this.id,
    required this.joinCode,
    required this.status,
    required this.ducatLimit,
    this.boardSize,
    required this.scenario,
    this.roleRollWinnerId,
    this.deploymentRollWinnerId,
    this.players = const [],
  });

  GamePlayer? playerFor(int userId) => players.where((p) => p.userId == userId).firstOrNull;
}
