// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

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

/// One model's state as an `entry_state` broadcast delivers it — the payload the five entry
/// endpoints push instead of a whole `game_state` (CARNEVALEB-37).
///
/// [spellCasts] maps each of the model's spell keys (see `KnownSpell.key`) to its current `cast`
/// flag. It travels beside [state] rather than inside it because deriving `cast` needs each spell's
/// `resetsEachRound`, which lives on the pool/grant, not on the entry state.
class EntryStateUpdate {
  final int playerId;
  final int listEntryId;
  final api.EntryState state;
  final Map<String, bool> spellCasts;

  const EntryStateUpdate({
    required this.playerId,
    required this.listEntryId,
    required this.state,
    required this.spellCasts,
  });
}

/// Owns both REST calls for the game-setup flow and the live ActionCable
/// subscription for whichever game is currently open. [currentGame] is always
/// the latest full snapshot from the server — every update, REST or
/// broadcast, fully replaces it rather than patching fields locally.
///
/// "Latest" means highest `stateVersion`, not last to arrive: neither Action Cable delivery nor
/// HTTP responses guarantee ordering, so every write goes through [_applySnapshot] (A-3).
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

  // Kept apart from ChangeNotifier's listeners: an entry_state broadcast carries a payload rather
  // than just signalling "currentGame changed", and only the gang tabs care about it.
  final _entryStateListeners = <void Function(EntryStateUpdate)>[];

  /// Subscribes to `entry_state` broadcasts — one model's counters/stats/tokens/spell casts
  /// changing, on either player's gang. Pair with [removeEntryStateListener] in `dispose`.
  void addEntryStateListener(void Function(EntryStateUpdate) listener) =>
      _entryStateListeners.add(listener);

  void removeEntryStateListener(void Function(EntryStateUpdate) listener) =>
      _entryStateListeners.remove(listener);

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
  //
  // The response still has to pass the freshness check: it was serialized when the request reached
  // the server, so a broadcast carrying the opponent's later change can easily arrive first, and
  // applying this on top would drop their change off the screen until something else refreshed it.
  api.Game _applyGame(int gameId, api.Game game) {
    if (_watchedGameId == gameId) _applySnapshot(game);
    return game;
  }

  /// Installs [game] as the live snapshot, unless a newer one is already displayed.
  ///
  /// Every write to [currentGame] goes through here. Snapshots are ordered by the server's
  /// `stateVersion` rather than by arrival, because nothing about the transport orders them: two
  /// broadcasts from different Puma workers race each other, and a mutation response races the
  /// broadcasts that overtake it. Applying a stale one silently reverts the screen — the opponent's
  /// score disappears, a turn counter walks backwards — and it stays wrong until the next
  /// broadcast (A-3).
  ///
  /// Returns whether the snapshot was applied.
  bool _applySnapshot(api.Game game) {
    final current = currentGame;
    // Versions are per game and start over for each one, so they only order snapshots of the same
    // game. Callers guard on the id; this re-checks rather than trusting it, since comparing across
    // games would drop perfectly good state.
    if (current != null &&
        current.id == game.id &&
        game.stateVersion <= current.stateVersion) {
      return false;
    }
    currentGame = game;
    notifyListeners();
    return true;
  }

  Future<List<api.Scenario>> loadScenarios() => _guard(() async {
    final res = await _client.scenarios.getScenarios();
    return res.data?.toList() ?? [];
  });

  // The last-loaded games per visibility, so the games index can show them instantly on every visit
  // instead of refetching each time. Per-user (like the gangs cache), so cleared on logout
  // (AuthService#_clear). The index background-refreshes over these, so brief staleness self-heals.
  List<api.Game>? _activeGamesCache;
  List<api.Game>? _archivedGamesCache;

  /// The cached games for a visibility, or null if none loaded yet this session (defensive copy).
  List<api.Game>? cachedGames({String visibility = 'active'}) {
    final cache = visibility == 'archived'
        ? _archivedGamesCache
        : _activeGamesCache;
    return cache == null ? null : List.of(cache);
  }

  Future<List<api.Game>> loadMyGames({String visibility = 'active'}) =>
      _guard(() async {
        final res = await _client.games.getGames(visibility: visibility);
        final games = res.data?.toList() ?? [];
        if (visibility == 'archived') {
          _archivedGamesCache = games;
        } else {
          _activeGamesCache = games;
        }
        return games;
      });

  /// Clears the cached games — the index is per-user, so this runs on logout / session end.
  void resetGamesCache() {
    _activeGamesCache = null;
    _archivedGamesCache = null;
  }

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
  /// state; the server also broadcasts an entry_state event to both players.
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
  /// model's full updated state; the server also broadcasts an entry_state event to both players.
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

  /// Adds or updates a player token on one of the current player's own models (CARNEVALEB-16).
  /// Keyed by [tokenId] (client-generated): re-sending the same id updates that token — an edit, or
  /// a flip of its `active` state — rather than adding a duplicate, so a retry is safe. Returns the
  /// model's full updated state; the server also broadcasts an entry_state event to both players.
  Future<api.EntryState> upsertToken(
    int gameId,
    int listEntryId, {
    required String tokenId,
    required api.TokenColorEnum color,
    String? text,
    required bool toggleable,
    required bool active,
    int? count,
  }) => _guard(() async {
    final res = await _client.games.updateToken(
      id: gameId,
      listEntryId: listEntryId,
      updateTokenInput: api.UpdateTokenInput(
        (b) => b
          ..token.id = tokenId
          ..token.color = color
          ..token.text = text
          ..token.toggleable = toggleable
          ..token.active = active
          ..token.count = count,
      ),
    );
    return res.data!;
  });

  /// Removes the token with [tokenId] from one of the current player's own models. Returns the
  /// model's full updated state; broadcast to both players as an entry_state event.
  Future<api.EntryState> removeToken(int gameId, int listEntryId, String tokenId) =>
      _guard(() async {
        final res = await _client.games.removeToken(
          id: gameId,
          listEntryId: listEntryId,
          tokenId: tokenId,
        );
        return res.data!;
      });

  /// Marks (or unmarks) one known/granted spell as cast, on one of the current player's own
  /// models. `key` comes verbatim from the PoolSpell/GrantedSpell being toggled (see
  /// KnownSpell.key) — `cast` is the desired state rather than a blind toggle. Returns the
  /// model's full updated state (HP/WP/CP/counters); the spell's own new `cast` flag isn't in
  /// that payload (it lives on ListEntry.pools/grantedSpells, not EntryState), so the caller
  /// applies the flip to its own local copy. Both players also get an entry_state event, whose
  /// `spellCasts` map does carry the new flag — that's how the change reaches the opponent.
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

    // Id first, so a listener woken by the snapshot already sees isWatching() as true. stopWatching()
    // above cleared currentGame, so this snapshot always installs — there is nothing newer to keep.
    _watchedGameId = gameId;
    _applySnapshot(game);

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
    if (message['event'] == 'entry_state') {
      _onEntryStateMessage(message);
      return;
    }
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
      // Two broadcasts can be produced by different Puma workers and reach us in the opposite
      // order; _applySnapshot drops the older one rather than letting it revert the screen (A-3).
      _applySnapshot(decoded);
    } catch (e, st) {
      debugPrint(
        'GameService: ignoring malformed game_state broadcast: $e\n$st',
      );
    }
  }

  // One model changed (counters/stats/tokens/spell casts). Nothing in currentGame is derived from a
  // model's state, so this doesn't touch the snapshot — it hands the change to the gang tabs, which
  // patch that one entry instead of re-fetching both player lists (CARNEVALEB-37).
  void _onEntryStateMessage(Map<String, dynamic> message) {
    try {
      // Same reasoning as the game_state path: a malformed payload must not escape the listen
      // callback and kill live updates. Losing one entry_state is survivable — the next player-list
      // fetch (a turn change, a refresh) resyncs that model.
      final state = api.standardSerializers.deserializeWith(
        api.EntryState.serializer,
        message['state'],
      );
      if (state == null) return;
      final spellCasts = <String, bool>{
        for (final entry in (message['spell_casts'] as Map).entries)
          entry.key as String: entry.value as bool,
      };
      final update = EntryStateUpdate(
        playerId: message['player_id'] as int,
        listEntryId: message['list_entry_id'] as int,
        state: state,
        spellCasts: spellCasts,
      );
      // Iterate a copy: a listener that unsubscribes on delivery (a tab disposing) would otherwise
      // mutate the list mid-iteration.
      for (final listener in List.of(_entryStateListeners)) {
        listener(update);
      }
    } catch (e, st) {
      debugPrint(
        'GameService: ignoring malformed entry_state broadcast: $e\n$st',
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
