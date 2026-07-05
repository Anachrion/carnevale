import 'package:carnevale_api/carnevale_api.dart' as api;

class GamePlayer {
  final int id;
  final int userId;
  final String username;
  final bool host;
  final api.GangSummary? list;
  final String? role;
  final bool ready;
  final bool wonRoleRoll;
  final bool wonDeploymentRoll;
  final List<api.Agenda> agendas;

  const GamePlayer({
    required this.id,
    required this.userId,
    required this.username,
    required this.host,
    this.list,
    this.role,
    this.ready = false,
    this.wonRoleRoll = false,
    this.wonDeploymentRoll = false,
    this.agendas = const [],
  });
}

class Game {
  final int id;
  final String name;
  final String joinCode;
  final String status;
  final int ducatLimit;
  final String? boardSize;
  final api.Scenario scenario;
  final String viewerVisibility;
  final List<GamePlayer> players;

  const Game({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.status,
    required this.ducatLimit,
    this.boardSize,
    required this.scenario,
    required this.viewerVisibility,
    this.players = const [],
  });

  GamePlayer? playerFor(int userId) => players.where((p) => p.userId == userId).firstOrNull;
}
