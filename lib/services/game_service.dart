// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:built_value/serializer.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'action_cable_client.dart';
import 'api_client.dart';
import 'api_exception.dart';

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
  // Bumped by every watch()/stopWatching() so an in-flight watch that resumes after it has been
  // superseded (screen popped, or a newer watch started) can detect it lost the race and bail
  // instead of installing a leaked cable or clobbering currentGame with the wrong game (C-5).
  int _watchGeneration = 0;

  api.Game? currentGame;

  /// Whether the live subscription is currently on [gameId] — lets a screen re-established over
  /// another game (A-5) tell if it needs to re-watch.
  bool isWatching(int gameId) => _watchedGameId == gameId;

  /// Fired when the live connection hits an unrecoverable auth failure (the session expired while
  /// watching). The UI listens so it can route to re-login rather than spin on a dead credential.
  void Function()? onSessionExpired;

  /// Test seam: overrides the WebSocket transport the live cable opens, so tests can drive the
  /// connection with a fake channel instead of a real socket. Null in production.
  @visibleForTesting
  ChannelFactory? debugChannelFactory;

  // Wraps a call so a DioException surfaces as a uniform, user-presentable ApiException (F-P2-2).
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  // Applies a mutation's REST response to the live snapshot immediately, so the acting player's UI
  // updates without waiting for (or depending on) the ActionCable echo (A-1). Guarded by the
  // watched-game id so a response for a game we're no longer watching can't clobber currentGame.
  api.Game _applyGame(int gameId, api.Game game) {
    if (_watchedGameId == gameId) {
      currentGame = game;
      notifyListeners();
    }
    return game;
  }

  Future<List<api.Scenario>> loadScenarios() => _guard(() async {
    final res = await _client.scenarios.getScenarios();
    return res.data?.toList() ?? [];
  });

  Future<List<api.Game>> loadMyGames({String visibility = 'active'}) =>
      _guard(() async {
        final res = await _client.games.getGames(visibility: visibility);
        return res.data?.toList() ?? [];
      });

  Future<api.Game> archiveGame(int gameId) => _guard(() async {
    final res = await _client.games.archiveGame(id: gameId);
    return res.data!;
  });

  Future<api.Game> unarchiveGame(int gameId) => _guard(() async {
    final res = await _client.games.unarchiveGame(id: gameId);
    return res.data!;
  });

  Future<void> deleteGame(int gameId) => _guard(() async {
    await _client.games.deleteGame(id: gameId);
  });

  Future<api.Game> createGame({
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
    return res.data!;
  });

  Future<api.Game> joinGame(String joinCode) => _guard(() async {
    final res = await _client.games.joinGame(
      joinGameInput: api.JoinGameInput((b) => b..joinCode = joinCode),
    );
    return res.data!;
  });

  Future<api.Game> getGame(int id) => _guard(() async {
    final res = await _client.games.getGame(id: id);
    return res.data!;
  });

  Future<api.Game> pickRole(int gameId, String role) => _guard(() async {
    final roleEnum = role == 'attacker'
        ? api.RoleInputRoleEnum.attacker
        : api.RoleInputRoleEnum.defender;
    final res = await _client.games.pickRole(
      id: gameId,
      roleInput: api.RoleInput((b) => b..role = roleEnum),
    );
    return _applyGame(gameId, res.data!);
  });

  Future<List<AvailableGang>> availableGangs(int gameId) => _guard(() async {
    final res = await _client.games.getAvailableGangs(id: gameId);
    return (res.data?.toList() ?? [])
        .map((a) => AvailableGang(gang: a.list, selectable: a.selectable))
        .toList();
  });

  Future<api.Game> selectGang(int gameId, int listId) => _guard(() async {
    final res = await _client.games.selectGang(
      id: gameId,
      selectGangInput: api.SelectGangInput((b) => b..listId = listId),
    );
    return _applyGame(gameId, res.data!);
  });

  /// Clears the current player's gang pick while still in gang selection, so they can choose a
  /// different one (or none) before the opponent locks in and the game advances.
  Future<api.Game> deselectGang(int gameId) => _guard(() async {
    final res = await _client.games.deselectGang(id: gameId);
    return _applyGame(gameId, res.data!);
  });

  /// Draws a single in-play replacement agenda during `in_progress`. [origin] (`special_rule`/
  /// `command_point`) identifies what granted the draw. The opening hand isn't drawn here — the
  /// server deals it automatically when the game enters `agenda_draw`.
  Future<List<api.Agenda>> drawAgendas(int gameId, {required String origin}) =>
      _guard(() async {
        final res = await _client.games.drawAgendas(
          id: gameId,
          drawAgendaInput: api.DrawAgendaInput(
            (b) => b..origin = _drawOrigin(origin),
          ),
        );
        return res.data?.agendas.toList() ?? [];
      });

  /// Confirms the player's opening hand, ending their agenda_draw phase. Once both players
  /// confirm, the server takes the game straight to in_progress (deployment is done at the table).
  Future<api.Game> confirmAgendas(int gameId) => _guard(() async {
    final res = await _client.games.confirmAgendas(id: gameId);
    return _applyGame(gameId, res.data!);
  });

  /// Scores an agenda from the player's hand (flat 1 VP). Under a Cycle scenario the server
  /// auto-draws a replacement — nothing to request here.
  Future<api.Game> scoreAgenda(int gameId, int agendaId) => _guard(() async {
    final res = await _client.games.scoreAgenda(id: gameId, agendaId: agendaId);
    return _applyGame(gameId, res.data!);
  });

  /// Discards an in-play agenda via [origin] (`special_rule`/`command_point`).
  Future<api.Game> discardAgenda(
    int gameId,
    int agendaId, {
    required String origin,
  }) => _guard(() async {
    final res = await _client.games.discardAgenda(
      id: gameId,
      agendaId: agendaId,
      discardAgendaInput: api.DiscardAgendaInput(
        (b) => b..origin = _discardOrigin(origin),
      ),
    );
    return _applyGame(gameId, res.data!);
  });

  /// Pre-game mulligan: toss an impossible/duplicated agenda during setup; the server always
  /// draws a replacement.
  Future<api.Game> discardUnachievable(int gameId, int agendaId) =>
      discardAgenda(gameId, agendaId, origin: 'unachievable');

  Future<api.Game> advanceTurn(int gameId) => _guard(() async {
    final res = await _client.games.advanceTurn(id: gameId);
    return _applyGame(gameId, res.data!);
  });

  Future<api.Game> rewindTurn(int gameId) => _guard(() async {
    final res = await _client.games.rewindTurn(id: gameId);
    return _applyGame(gameId, res.data!);
  });

  /// Ends the game from this player's side (only valid on the last turn) — archives it for them
  /// while the opponent keeps playing.
  Future<api.Game> finishGame(int gameId) => _guard(() async {
    final res = await _client.games.finishGame(id: gameId);
    return _applyGame(gameId, res.data!);
  });

  Future<api.Game> unfinishGame(int gameId) => _guard(() async {
    final res = await _client.games.unfinishGame(id: gameId);
    return _applyGame(gameId, res.data!);
  });

  api.DrawAgendaInputOriginEnum _drawOrigin(String origin) => switch (origin) {
    'special_rule' => api.DrawAgendaInputOriginEnum.specialRule,
    'command_point' => api.DrawAgendaInputOriginEnum.commandPoint,
    _ => throw ArgumentError('Unknown draw origin: $origin'),
  };

  api.DiscardAgendaInputOriginEnum _discardOrigin(String origin) =>
      switch (origin) {
        'unachievable' => api.DiscardAgendaInputOriginEnum.unachievable,
        'special_rule' => api.DiscardAgendaInputOriginEnum.specialRule,
        'command_point' => api.DiscardAgendaInputOriginEnum.commandPoint,
        _ => throw ArgumentError('Unknown discard origin: $origin'),
      };

  /// Either player's selected gang, in full — available once that player has picked one,
  /// regardless of whose turn it currently is.
  Future<api.ModelList> playerList(int gameId, int playerId) =>
      _guard(() async {
        final res = await _client.games.getPlayerList(
          id: gameId,
          playerId: playerId,
        );
        return res.data!;
      });

  /// Conjures a model onto the board mid-game (a summon/raise granted by a special rule) and adds
  /// it to the current player's gang. Any model in the catalog may be summoned — the rule lives on
  /// the summoner's card, so the app tracks the summon rather than adjudicating it.
  ///
  /// A summoned model tracks HP, counters and activation like any hired one, but costs the gang
  /// nothing and can't push it over its ducat limit. Returns the player's updated gang.
  Future<api.ModelList> summon(int gameId, int cardReferenceId) =>
      _guard(() async {
        final res = await _client.games.summonModel(
          id: gameId,
          summonModelRequest: api.SummonModelRequest(
            (b) => b..cardReferenceId = cardReferenceId,
          ),
        );
        return res.data!;
      });

  /// Removes a summoned model. Only summoned models can be removed — the hired roster is frozen
  /// once the game starts.
  Future<api.ModelList> dismissSummon(int gameId, int listEntryId) =>
      _guard(() async {
        final res = await _client.games.dismissSummon(
          id: gameId,
          listEntryId: listEntryId,
        );
        return res.data!;
      });

  /// Updates status counters on one of the current player's own models — only the values
  /// passed change, the rest keep their current state. Returns the model's full updated
  /// state; the server also broadcasts a game_state event to both players.
  ///
  /// [activated] marks the model as having activated this turn. The server records *which* turn
  /// it activated on, so the flag clears itself when this player advances the turn — nothing here
  /// needs to reset it.
  Future<api.EntryState> updateCounters(
    int gameId,
    int listEntryId, {
    bool? stunned,
    bool? hidden,
    bool? guarding,
    bool? carryingObjective,
    int? underwaterCounters,
    bool? activated,
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
          ..counters.underwaterCounters = underwaterCounters
          ..counters.activated = activated,
      ),
    );
    return res.data!;
  });

  /// Sets current HP/WP/CP on one of the current player's own models — only the stats passed
  /// change (absolute values, not deltas), the rest keep their current value. Returns the
  /// model's full updated state; the server also broadcasts a game_state event to both players.
  Future<api.EntryState> updateStats(
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
    return res.data!;
  });

  /// Marks (or unmarks) one known/granted spell as cast, on one of the current player's own
  /// models. `key` comes verbatim from the PoolSpell/GrantedSpell being toggled (see
  /// KnownSpell.key) — `cast` is the desired state rather than a blind toggle. Returns the
  /// model's full updated state (HP/WP/CP/counters); the spell's own new `cast` flag isn't in
  /// that payload (it lives on ListEntry.pools/grantedSpells, not EntryState), so the caller
  /// applies the flip to its own local copy instead of waiting for a re-fetch.
  Future<api.EntryState> updateSpellCast(
    int gameId,
    int listEntryId, {
    required String key,
    required bool cast,
  }) => _guard(() async {
    final res = await _client.games.updateSpellCast(
      id: gameId,
      listEntryId: listEntryId,
      updateSpellCastInput: api.UpdateSpellCastInput(
        (b) => b
          ..spellCast.key = key
          ..spellCast.cast = cast,
      ),
    );
    return res.data!;
  });

  /// Fetches an initial snapshot and opens a live ActionCable subscription for
  /// [gameId], keeping [currentGame] in sync until [stopWatching] is called.
  ///
  /// Guarded by a generation token: if the screen is popped (stopWatching) or a different game is
  /// watched while this call is still awaiting, the superseded watch bails after each await instead
  /// of installing a leaked cable or overwriting currentGame with the wrong game's state (C-5).
  Future<api.Game> watch(int gameId) async {
    stopWatching();
    final myGeneration = _watchGeneration;

    final game = await getGame(gameId);
    if (myGeneration != _watchGeneration) return game; // superseded while fetching

    currentGame = game;
    _watchedGameId = gameId;
    notifyListeners();

    // The client mints a fresh single-use cable ticket for every connection attempt. On reconnect
    // the resubscribe transmits a fresh snapshot, so there's no separate REST resync to race it.
    final cable = ActionCableClient(
      _client.cableConnectionUrl,
      channelFactory: debugChannelFactory,
    )..onAuthFailure = _onCableAuthFailure;
    cable.subscribe({
      'channel': 'GameChannel',
      'game_id': gameId,
    }, _onChannelMessage);
    if (myGeneration != _watchGeneration) {
      cable.dispose(); // superseded while wiring the cable — don't install a leak
      return game;
    }
    _cable = cable;
    await cable.connect();
    return game;
  }

  /// Forces the live socket to reconnect immediately — called when the app returns to the
  /// foreground, where a socket that died while suspended may not have surfaced an error yet (C-4).
  void resumeConnection() {
    _cable?.reconnectNow();
  }

  void _onCableAuthFailure() {
    stopWatching();
    onSessionExpired?.call();
  }

  void stopWatching() {
    // Invalidate any in-flight watch() so it bails instead of installing its cable / snapshot.
    _watchGeneration++;
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
    notifyListeners();
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
      // Ignore a broadcast for a game we're no longer watching (a stale cable that outlived its
      // watch, or a payload that arrived mid-switch), so it can't clobber the current game (C-5).
      if (_watchedGameId != null && decoded.id != _watchedGameId) return;
      currentGame = decoded;
      notifyListeners();
    } catch (e, st) {
      debugPrint(
        'GameService: ignoring malformed game_state broadcast: $e\n$st',
      );
    }
  }

  /// Converts a generated enum constant back to its wire value (e.g.
  /// `GameStatusEnum.gangSelection` -> `'gang_selection'`) via the same
  /// serializer used for the wire format, rather than hand-maintaining a
  /// separate camelCase-to-snake_case mapping.
  @visibleForTesting
  String wireEnum(Object enumValue, FullType type) =>
      api.standardSerializers.serialize(enumValue, specifiedType: type)
          as String;
}
