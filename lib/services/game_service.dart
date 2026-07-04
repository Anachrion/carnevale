import 'package:built_value/serializer.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/foundation.dart';

import '../models/game.dart' as models;
import 'action_cable_client.dart';
import 'api_client.dart';

class AvailableGang {
  final models.GangSummary gang;
  final bool selectable;

  const AvailableGang({required this.gang, required this.selectable});
}

/// Owns both REST calls for the game-setup flow and the live ActionCable
/// subscription for whichever game is currently open. [currentGame] is always
/// the latest full snapshot from the server — every update, REST or
/// broadcast, fully replaces it rather than patching fields locally.
class GameService extends ChangeNotifier {
  static final GameService _instance = GameService._();
  factory GameService() => _instance;
  GameService._();

  final _client = ApiClient();
  ActionCableClient? _cable;
  int? _watchedGameId;

  models.Game? currentGame;

  Future<List<models.Scenario>> loadScenarios() async {
    final res = await _client.scenarios.getScenarios();
    return (res.data?.toList() ?? []).map(_mapScenario).toList();
  }

  Future<List<models.Game>> loadMyGames() async {
    final res = await _client.games.getGames();
    return (res.data?.toList() ?? []).map(_mapGame).toList();
  }

  Future<models.Game> createGame({required int scenarioId, int? ducatLimit, String? boardSize}) async {
    final res = await _client.games.createGame(
      createGameInput: api.CreateGameInput((b) => b
        ..scenarioId = scenarioId
        ..ducatLimit = ducatLimit
        ..boardSize = boardSize),
    );
    return _mapGame(res.data!);
  }

  Future<models.Game> joinGame(String joinCode) async {
    final res = await _client.games.joinGame(
      joinGameInput: api.JoinGameInput((b) => b..joinCode = joinCode),
    );
    return _mapGame(res.data!);
  }

  Future<models.Game> getGame(int id) async {
    final res = await _client.games.getGame(id: id);
    return _mapGame(res.data!);
  }

  Future<models.Game> pickRole(int gameId, String role) async {
    final roleEnum = role == 'attacker' ? api.RoleInputRoleEnum.attacker : api.RoleInputRoleEnum.defender;
    final res = await _client.games.pickRole(
      id: gameId,
      roleInput: api.RoleInput((b) => b..role = roleEnum),
    );
    return _mapGame(res.data!);
  }

  Future<List<AvailableGang>> availableGangs(int gameId) async {
    final res = await _client.games.getAvailableGangs(id: gameId);
    return (res.data?.toList() ?? [])
        .map((a) => AvailableGang(gang: _mapGangSummary(a.list), selectable: a.selectable))
        .toList();
  }

  Future<models.Game> selectGang(int gameId, int listId) async {
    final res = await _client.games.selectGang(
      id: gameId,
      selectGangInput: api.SelectGangInput((b) => b..listId = listId),
    );
    return _mapGame(res.data!);
  }

  Future<List<models.Agenda>> drawAgendas(int gameId) async {
    final res = await _client.games.drawAgendas(id: gameId);
    return (res.data?.agendas.toList() ?? []).map(_mapAgenda).toList();
  }

  Future<models.Game> pickDeploymentZone(int gameId, String zone) async {
    final zoneEnum = zone == 'A' ? api.DeploymentZoneInputZoneEnum.A : api.DeploymentZoneInputZoneEnum.B;
    final res = await _client.games.pickDeploymentZone(
      id: gameId,
      deploymentZoneInput: api.DeploymentZoneInput((b) => b..zone = zoneEnum),
    );
    return _mapGame(res.data!);
  }

  Future<models.Game> markReady(int gameId) async {
    final res = await _client.games.markReady(id: gameId);
    return _mapGame(res.data!);
  }

  /// Fetches an initial snapshot and opens a live ActionCable subscription for
  /// [gameId], keeping [currentGame] in sync until [stopWatching] is called.
  Future<models.Game> watch(int gameId, {required String authToken}) async {
    stopWatching();

    final game = await getGame(gameId);
    currentGame = game;
    notifyListeners();

    _watchedGameId = gameId;
    _cable = ActionCableClient('${ApiClient.cableUrl}?token=$authToken')..connect();
    _cable!.subscribe({'channel': 'GameChannel', 'game_id': gameId}, _onChannelMessage);
    return game;
  }

  void stopWatching() {
    if (_watchedGameId != null) {
      _cable?.unsubscribe({'channel': 'GameChannel', 'game_id': _watchedGameId});
    }
    _cable?.dispose();
    _cable = null;
    _watchedGameId = null;
    currentGame = null;
  }

  void _onChannelMessage(Map<String, dynamic> message) {
    if (message['event'] != 'game_state') return;
    final decoded = api.standardSerializers.deserializeWith(api.Game.serializer, message['game']);
    if (decoded == null) return;
    currentGame = _mapGame(decoded);
    notifyListeners();
  }

  models.Game _mapGame(api.Game g) => models.Game(
        id: g.id,
        joinCode: g.joinCode,
        status: wireEnum(g.status, const FullType(api.GameStatusEnum)),
        ducatLimit: g.ducatLimit,
        boardSize: g.boardSize,
        scenario: _mapScenario(g.scenario),
        roleRollWinnerId: g.roleRollWinnerId,
        deploymentRollWinnerId: g.deploymentRollWinnerId,
        players: g.players.map(_mapPlayer).toList(),
      );

  models.GamePlayer _mapPlayer(api.GamePlayer p) => models.GamePlayer(
        id: p.id,
        userId: p.userId,
        username: p.username,
        host: p.host,
        list: p.list == null ? null : _mapGangSummary(p.list!),
        role: p.role?.name,
        deploymentZone: p.deploymentZone?.name,
        ready: p.ready,
        agendas: p.agendas.map(_mapAgenda).toList(),
      );

  models.GangSummary _mapGangSummary(api.GangSummary g) => models.GangSummary(
        id: g.id,
        name: g.name,
        faction: g.faction,
        points: g.points,
        totalCost: g.totalCost,
      );

  models.Scenario _mapScenario(api.Scenario s) => models.Scenario(
        id: s.id,
        name: s.name,
        ducats: s.ducats,
        asymmetric: s.asymmetric,
        setup: s.setup,
        primaryObjective: s.primaryObjective,
        agendas: s.agendas.toList(),
        specialRules: s.specialRules.toList(),
        duration: s.duration,
        deploymentZones: s.deploymentZones.toList(),
        illustration: s.illustration,
      );

  models.Agenda _mapAgenda(api.Agenda a) => models.Agenda(id: a.id, name: a.name, description: a.description);

  /// Converts a generated enum constant back to its wire value (e.g.
  /// `GameStatusEnum.gangSelection` -> `'gang_selection'`) via the same
  /// serializer used for the wire format, rather than hand-maintaining a
  /// separate camelCase-to-snake_case mapping.
  @visibleForTesting
  String wireEnum(Object enumValue, FullType type) =>
      api.standardSerializers.serialize(enumValue, specifiedType: type) as String;
}
