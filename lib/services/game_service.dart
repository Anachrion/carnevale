import 'package:built_value/serializer.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/game.dart' as models;
import '../models/gang.dart';
import 'action_cable_client.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'gang_service.dart';

class AvailableGang {
  final api.GangSummary gang;
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

  // Wraps a call so a DioException surfaces as a uniform, user-presentable ApiException (F-P2-2).
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<List<api.Scenario>> loadScenarios() => _guard(() async {
    final res = await _client.scenarios.getScenarios();
    return res.data?.toList() ?? [];
  });

  Future<List<models.Game>> loadMyGames({String visibility = 'active'}) =>
      _guard(() async {
        final res = await _client.games.getGames(visibility: visibility);
        return (res.data?.toList() ?? []).map(_mapGame).toList();
      });

  Future<models.Game> archiveGame(int gameId) => _guard(() async {
    final res = await _client.games.archiveGame(id: gameId);
    return _mapGame(res.data!);
  });

  Future<models.Game> unarchiveGame(int gameId) => _guard(() async {
    final res = await _client.games.unarchiveGame(id: gameId);
    return _mapGame(res.data!);
  });

  Future<void> deleteGame(int gameId) => _guard(() async {
    await _client.games.deleteGame(id: gameId);
  });

  Future<models.Game> createGame({
    required int scenarioId,
    String? name,
    int? ducatLimit,
    String? boardSize,
  }) => _guard(() async {
    final res = await _client.games.createGame(
      createGameInput: api.CreateGameInput(
        (b) => b
          ..scenarioId = scenarioId
          ..name = name
          ..ducatLimit = ducatLimit
          ..boardSize = boardSize,
      ),
    );
    return _mapGame(res.data!);
  });

  Future<models.Game> joinGame(String joinCode) => _guard(() async {
    final res = await _client.games.joinGame(
      joinGameInput: api.JoinGameInput((b) => b..joinCode = joinCode),
    );
    return _mapGame(res.data!);
  });

  Future<models.Game> getGame(int id) => _guard(() async {
    final res = await _client.games.getGame(id: id);
    return _mapGame(res.data!);
  });

  Future<models.Game> pickRole(int gameId, String role) => _guard(() async {
    final roleEnum = role == 'attacker'
        ? api.RoleInputRoleEnum.attacker
        : api.RoleInputRoleEnum.defender;
    final res = await _client.games.pickRole(
      id: gameId,
      roleInput: api.RoleInput((b) => b..role = roleEnum),
    );
    return _mapGame(res.data!);
  });

  Future<List<AvailableGang>> availableGangs(int gameId) => _guard(() async {
    final res = await _client.games.getAvailableGangs(id: gameId);
    return (res.data?.toList() ?? [])
        .map(
          (a) => AvailableGang(gang: a.list, selectable: a.selectable),
        )
        .toList();
  });

  Future<models.Game> selectGang(int gameId, int listId) => _guard(() async {
    final res = await _client.games.selectGang(
      id: gameId,
      selectGangInput: api.SelectGangInput((b) => b..listId = listId),
    );
    return _mapGame(res.data!);
  });

  Future<List<api.Agenda>> drawAgendas(int gameId) => _guard(() async {
    final res = await _client.games.drawAgendas(id: gameId);
    return res.data?.agendas.toList() ?? [];
  });

  Future<models.Game> markReady(int gameId) => _guard(() async {
    final res = await _client.games.markReady(id: gameId);
    return _mapGame(res.data!);
  });

  /// Either player's selected gang, in full — available once that player has picked one,
  /// regardless of whose turn it currently is.
  Future<Gang> playerList(int gameId, int playerId) => _guard(() async {
    final res = await _client.games.getPlayerList(
      id: gameId,
      playerId: playerId,
    );
    return GangService().mapGang(res.data!);
  });

  /// Updates status counters on one of the current player's own models — only the values
  /// passed change, the rest keep their current state. Returns the model's full updated
  /// state; the server also broadcasts a game_state event to both players.
  Future<EntryState> updateCounters(
    int gameId,
    int listEntryId, {
    bool? stunned,
    bool? hidden,
    bool? guarding,
    bool? carryingObjective,
    int? underwaterCounters,
  }) => _guard(() async {
    final res = await _client.games.updateCounters(
      id: gameId,
      listEntryId: listEntryId,
      updateCountersInput: api.UpdateCountersInput(
        (b) => b
          ..counters.stunned = stunned
          ..counters.hidden = hidden
          ..counters.guarding = guarding
          ..counters.carryingObjective = carryingObjective
          ..counters.underwaterCounters = underwaterCounters,
      ),
    );
    return GangService().mapEntryState(res.data!);
  });

  /// Sets current HP/WP/CP on one of the current player's own models — only the stats passed
  /// change (absolute values, not deltas), the rest keep their current value. Returns the
  /// model's full updated state; the server also broadcasts a game_state event to both players.
  Future<EntryState> updateStats(
    int gameId,
    int listEntryId, {
    int? lifePoints,
    int? willPoints,
    int? commandPoints,
  }) => _guard(() async {
    final res = await _client.games.updateStats(
      id: gameId,
      listEntryId: listEntryId,
      updateStatsInput: api.UpdateStatsInput(
        (b) => b
          ..stats.lifePoints = lifePoints
          ..stats.willPoints = willPoints
          ..stats.commandPoints = commandPoints,
      ),
    );
    return GangService().mapEntryState(res.data!);
  });

  /// Fetches an initial snapshot and opens a live ActionCable subscription for
  /// [gameId], keeping [currentGame] in sync until [stopWatching] is called.
  Future<models.Game> watch(int gameId) async {
    stopWatching();

    final game = await getGame(gameId);
    currentGame = game;
    notifyListeners();

    _watchedGameId = gameId;
    // The client mints a fresh single-use cable ticket for every connection attempt; on reconnect
    // we refetch the snapshot, since any broadcasts sent while the socket was down are lost.
    _cable = ActionCableClient(_client.cableConnectionUrl)
      ..onReconnect = _resyncSnapshot;
    _cable!.subscribe({
      'channel': 'GameChannel',
      'game_id': gameId,
    }, _onChannelMessage);
    await _cable!.connect();
    return game;
  }

  Future<void> _resyncSnapshot() async {
    final id = _watchedGameId;
    if (id == null) return;
    try {
      currentGame = await getGame(id);
      notifyListeners();
    } catch (_) {
      // Keep the last-known snapshot; a later broadcast or reconnect will refresh it.
    }
  }

  void stopWatching() {
    if (_watchedGameId != null) {
      _cable?.unsubscribe({
        'channel': 'GameChannel',
        'game_id': _watchedGameId,
      });
    }
    _cable?.dispose();
    _cable = null;
    _watchedGameId = null;
    currentGame = null;
  }

  void _onChannelMessage(Map<String, dynamic> message) {
    if (message['event'] != 'game_state') return;
    try {
      // A malformed or schema-drifted payload makes deserializeWith throw; that would escape the
      // stream.listen callback (which has no onError) and kill live updates. Swallow it and keep
      // the last-known snapshot — the next broadcast or a reconnect resync will recover.
      final decoded = api.standardSerializers.deserializeWith(
        api.Game.serializer,
        message['game'],
      );
      if (decoded == null) return;
      currentGame = _mapGame(decoded);
      notifyListeners();
    } catch (e, st) {
      debugPrint(
        'GameService: ignoring malformed game_state broadcast: $e\n$st',
      );
    }
  }

  models.Game _mapGame(api.Game g) => models.Game(
    id: g.id,
    name: g.name,
    joinCode: g.joinCode,
    status: wireEnum(g.status, const FullType(api.GameStatusEnum)),
    ducatLimit: g.ducatLimit,
    boardSize: g.boardSize,
    scenario: g.scenario,
    viewerVisibility: g.viewerVisibility.name,
    players: g.players.map(_mapPlayer).toList(),
  );

  models.GamePlayer _mapPlayer(api.GamePlayer p) => models.GamePlayer(
    id: p.id,
    userId: p.userId,
    username: p.username,
    host: p.host,
    list: p.list,
    role: p.role?.name,
    ready: p.ready,
    wonRoleRoll: p.wonRoleRoll,
    wonDeploymentRoll: p.wonDeploymentRoll,
    agendas: p.agendas.toList(),
  );

  /// Converts a generated enum constant back to its wire value (e.g.
  /// `GameStatusEnum.gangSelection` -> `'gang_selection'`) via the same
  /// serializer used for the wire format, rather than hand-maintaining a
  /// separate camelCase-to-snake_case mapping.
  @visibleForTesting
  String wireEnum(Object enumValue, FullType type) =>
      api.standardSerializers.serialize(enumValue, specifiedType: type)
          as String;
}
