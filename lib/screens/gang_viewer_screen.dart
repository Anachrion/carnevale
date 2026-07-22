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

import 'dart:async';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/api_exception.dart';
import '../services/equipment_service.dart';
import '../services/game_service.dart';
import '../services/idempotency.dart';
import '../services/profile_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_toast.dart';
import '../widgets/equipment_detail.dart';
import '../widgets/faction_badge.dart';
import '../widgets/faction_rule.dart';
import '../widgets/points_bar.dart';
import '../widgets/profile_search.dart';
import '../widgets/spell_chips.dart';
import '../widgets/status_views.dart';
import '../widgets/themed_dialog_card.dart';
import '../widgets/token_chip.dart';
import '../widgets/token_preset.dart';
import 'card_viewer_screen.dart';

part 'gang_viewer_body.dart';
part 'gang_viewer_dialogs.dart';

/// Read-only view of both players' gangs for a game once each has picked one — reuses the
/// gang builder's visual language (faction colors, entry tiles, tap-to-view-card) but with no
/// hire/reorder/remove actions, since gang lists are frozen for the game the moment selected.
class GameGangsScreen extends StatelessWidget {
  const GameGangsScreen({
    super.key,
    required this.gameId,
    required this.myPlayerId,
    required this.myLabel,
    required this.opponentPlayerId,
    required this.opponentLabel,
  });

  final int gameId;
  final int myPlayerId;
  final String myLabel;
  final int opponentPlayerId;
  final String opponentLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            Expanded(
              child: GangsTabView(
                gameId: gameId,
                myPlayerId: myPlayerId,
                myLabel: myLabel,
                opponentPlayerId: opponentPlayerId,
                opponentLabel: opponentLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: context.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              AppLocalizations.of(context).navGangs,
              style: GoogleFonts.cinzel(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: context.textColor,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The my-gang/opponent-gang tab pair, split out of [GameGangsScreen] so it can also be embedded
/// directly as a game phase's body (e.g. once a game goes in_progress) without a second Scaffold
/// or app bar on top of the one the host screen already provides.
class GangsTabView extends StatelessWidget {
  const GangsTabView({
    super.key,
    required this.gameId,
    required this.myPlayerId,
    required this.myLabel,
    required this.opponentPlayerId,
    required this.opponentLabel,
    this.showListHeader = true,
    this.leadingTabs = const [],
  });

  final int gameId;
  final int myPlayerId;
  final String myLabel;
  final int opponentPlayerId;
  final String opponentLabel;

  /// Whether each tab shows the gang's name/faction header and ducats bar. Hidden once a game is
  /// in progress, where the list is fixed and that summary is just noise above the models.
  final bool showListHeader;

  /// Extra tabs shown before the two gang tabs — e.g. the in-progress Score tab. Each carries its
  /// own label and prebuilt view so this widget stays agnostic of what they contain.
  final List<({String label, Widget view})> leadingTabs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2 + leadingTabs.length,
      child: Column(
        children: [
          _buildTabBar(context),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                ...leadingTabs.map((t) => t.view),
                // Keyed by player so element reconciliation matches each tab to its own state even
                // when the tab set's composition changes (e.g. a leading Score tab is added) —
                // otherwise Flutter reuses state by position and a gang tab can show the wrong
                // player's models. Players only ever edit their own models' counters; the
                // opponent's tab stays read-only (changes still stream in via game_state broadcasts).
                _GangTab(
                  key: ValueKey('gang-$myPlayerId'),
                  gameId: gameId,
                  playerId: myPlayerId,
                  editable: true,
                  opponentPlayerId: opponentPlayerId,
                  showListHeader: showListHeader,
                ),
                _GangTab(
                  key: ValueKey('gang-$opponentPlayerId'),
                  gameId: gameId,
                  playerId: opponentPlayerId,
                  editable: false,
                  showListHeader: showListHeader,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        isScrollable: leadingTabs.isNotEmpty,
        tabAlignment: leadingTabs.isNotEmpty ? TabAlignment.center : null,
        labelColor: context.accentColor,
        unselectedLabelColor: context.subtleTextColor,
        indicatorColor: context.accentColor,
        labelStyle: GoogleFonts.cinzel(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        tabs: [
          ...leadingTabs.map((t) => Tab(text: t.label)),
          Tab(text: myLabel),
          Tab(text: opponentLabel),
        ],
      ),
    );
  }
}

class _GangTabData {
  const _GangTabData({
    required this.gang,
    required this.profiles,
    required this.equipment,
  });
  final api.ModelList gang;
  final List<api.Profile> profiles;
  final List<api.Equipment> equipment;
}

class _GangTab extends StatefulWidget {
  const _GangTab({
    super.key,
    required this.gameId,
    required this.playerId,
    required this.editable,
    this.opponentPlayerId,
    this.showListHeader = true,
  });

  final int gameId;
  final int playerId;
  final bool editable;

  /// Set only on the editable tab: the other gang, whose spells source the *debuff* presets a mage
  /// there can cast onto this player's models (see [predefinedPresetsFor]).
  final int? opponentPlayerId;
  final bool showListHeader;

  @override
  State<_GangTab> createState() => _GangTabState();
}

class _GangTabState extends State<_GangTab> with AutomaticKeepAliveClientMixin {
  final _gameService = GameService();
  _GangTabData? _data;
  bool _failed = false;

  // The opposing gang's entries, loaded once on the editable tab, used only to source debuff presets
  // (their spell composition is static mid-game). Null until loaded / on the read-only tab.
  List<api.ListEntry>? _opponentEntries;

  // game_state broadcasts don't carry entry states, so each one triggers a player-list refetch.
  // This timer coalesces a burst of broadcasts into a single fetch instead of one per frame.
  Timer? _refetchTimer;

  // Bumped on every local optimistic update. A refetch captures it at the start and refuses to
  // apply its (now staler) result if a newer optimistic update landed while it was in flight, so
  // the just-tapped counter never flickers back to a stale server value.
  int _mutationSeq = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _gameService.addListener(_onGameUpdate);
    _load();
  }

  @override
  void dispose() {
    _refetchTimer?.cancel();
    _gameService.removeListener(_onGameUpdate);
    super.dispose();
  }

  Future<void> _load() async {
    final seq = _mutationSeq;
    try {
      final gang = await _gameService.playerList(
        widget.gameId,
        widget.playerId,
      );
      // The catalog halves never change mid-game — only re-fetch the gang on refresh.
      var profiles = _data?.profiles;
      var equipment = _data?.equipment;
      if (profiles == null || equipment == null) {
        final results = await Future.wait([
          ProfileService().search('', factions: {gang.faction, 'gifted'}),
          EquipmentService().getAll(),
        ]);
        profiles = results[0] as List<api.Profile>;
        equipment = results[1] as List<api.Equipment>;
      }
      // Load the opposing gang once (for debuff presets). A failure just means no debuffs show.
      if (widget.opponentPlayerId != null && _opponentEntries == null) {
        try {
          final opp = await _gameService.playerList(
            widget.gameId,
            widget.opponentPlayerId!,
          );
          _opponentEntries = opp.entries.toList();
        } catch (_) {
          // Debuffs simply won't be offered until a later refresh succeeds.
        }
      }
      if (!mounted) return;
      // A local optimistic update landed while this fetch was in flight — keep the fresher local
      // state and let a later broadcast reconcile, rather than clobbering it with a stale snapshot.
      if (seq != _mutationSeq) return;
      setState(() {
        _data = _GangTabData(
          gang: gang,
          profiles: profiles!,
          equipment: equipment!,
        );
        _failed = false;
      });
    } catch (e) {
      // On a failed refresh keep showing the last good snapshot instead of an error.
      if (mounted && _data == null) setState(() => _failed = true);
    }
  }

  // game_state broadcasts don't carry entry states (those live in the player-list payload), so any
  // broadcast — e.g. the opponent toggling a counter — needs a refetch. Debounce it so a chatty
  // game doesn't trigger a continuous stream of full player-list fetches.
  void _onGameUpdate() {
    _refetchTimer?.cancel();
    _refetchTimer = Timer(const Duration(milliseconds: 300), _load);
  }

  // Applies a PATCH response locally right away rather than waiting for the echo broadcast's
  // re-fetch, so the tapped counter never lags behind the dialog.
  void _applyEntryState(int listEntryId, api.EntryState state) {
    final data = _data;
    if (data == null) return;
    _mutationSeq++;
    final gang = data.gang;
    setState(() {
      _data = _GangTabData(
        gang: gang.rebuild(
          (b) => b.entries.replace(
            gang.entries.map(
              (e) => e.id == listEntryId
                  ? e.rebuild((eb) => eb..state.replace(state))
                  : e,
            ),
          ),
        ),
        profiles: data.profiles,
        equipment: data.equipment,
      );
    });
  }

  void _editModel(api.ListEntry entry) {
    final data = _data;
    // Buffs come from this gang (self-cast on allies); debuffs from the opposing gang (cast on us).
    final presets = data == null
        ? const <TokenPreset>[]
        : predefinedPresetsFor(
            ownEntries: data.gang.entries,
            ownProfiles: data.profiles,
            opponentEntries: _opponentEntries ?? const [],
          );
    showDialog(
      context: context,
      builder: (_) => _ModelEditDialog(
        gameId: widget.gameId,
        entry: entry,
        presets: presets,
        onStateChanged: _applyEntryState,
      ),
    );
  }

  // Flips a toggleable token's active state straight from the tile — the frequent per-turn flip.
  // Upserts by the token's own id, so the server updates it in place.
  // Flipping a token is a frequent per-turn tap, so it applies optimistically — the chip's LED flips
  // the instant you tap, before the round-trip. The upsert is idempotent, so the persist can't
  // meaningfully fail; on the off chance it does, we revert and say so.
  Future<void> _toggleToken(api.ListEntry entry, api.Token token) async {
    final current = entry.state;
    if (current == null) return;
    final flipped = token.rebuild((b) => b.active = !token.active);
    final optimistic = current.rebuild(
      (b) => b.tokens.replace(
        current.tokens.map((t) => t.id == token.id ? flipped : t),
      ),
    );
    _applyEntryState(entry.id, optimistic);
    try {
      final confirmed = await GameService().upsertToken(
        widget.gameId,
        entry.id,
        tokenId: token.id,
        color: token.color,
        text: token.text,
        toggleable: token.toggleable,
        active: flipped.active,
      );
      // Adopt the server's state only if nothing newer has moved this model since (== is the guard).
      if (mounted && _entryStateFor(entry.id) == optimistic) {
        _applyEntryState(entry.id, confirmed);
      }
    } catch (_) {
      if (mounted) {
        if (_entryStateFor(entry.id) == optimistic) {
          _applyEntryState(entry.id, current);
        }
        showAppToast(context, AppLocalizations.of(context).tokenUpdateFailed);
      }
    }
  }

  void _editStats(api.ListEntry entry) {
    showDialog(
      context: context,
      builder: (_) => _StatEditDialog(
        gameId: widget.gameId,
        entry: entry,
        onStateChanged: _applyEntryState,
        onCommit: _commitStats,
      ),
    );
  }

  api.EntryState? _entryStateFor(int entryId) {
    for (final e in _data?.gang.entries ?? const <api.ListEntry>[]) {
      if (e.id == entryId) return e.state;
    }
    return null;
  }

  /// Persists a model's debounced stat change (owned here, not in the dialog, so it survives the
  /// dialog closing). Sends only the stats that actually moved. On success the tile adopts the
  /// server's state — unless the value changed again while the write was in flight, so a newer
  /// optimistic edit isn't clobbered. On failure it rolls back to the last synced value and tells
  /// the player, so a silent desync can't leave the two players looking at different numbers.
  Future<api.EntryState> _commitStats(
    int entryId,
    api.EntryState target,
    api.EntryState confirmed,
  ) async {
    final lp = target.lifePoints.current != confirmed.lifePoints.current
        ? target.lifePoints.current
        : null;
    final wp = target.willPoints.current != confirmed.willPoints.current
        ? target.willPoints.current
        : null;
    final cp = target.commandPoints.current != confirmed.commandPoints.current
        ? target.commandPoints.current
        : null;
    if (lp == null && wp == null && cp == null) return confirmed;
    try {
      final newState = await GameService().updateStats(
        widget.gameId,
        entryId,
        lifePoints: lp,
        willPoints: wp,
        commandPoints: cp,
      );
      if (mounted && _entryStateFor(entryId) == target) {
        _applyEntryState(entryId, newState);
      }
      return newState;
    } catch (_) {
      if (mounted) {
        _applyEntryState(entryId, confirmed);
        showAppToast(
          context,
          AppLocalizations.of(context).statUpdateReverted,
        );
      }
      return confirmed;
    }
  }

  // Activation is a turn-sequencing marker rather than a status counter, so it toggles straight
  // from the tile instead of through the counter popup — mid-turn you flip it once per model and
  // want it in one tap. No reset logic here: the server records which turn the model activated on,
  // so advancing the turn clears the whole gang on its own.
  Future<void> _toggleActivated(api.ListEntry entry) async {
    final state = entry.state;
    if (state == null) return;
    try {
      final newState = await GameService().updateCounters(
        widget.gameId,
        entry.id,
        activated: !state.activated,
      );
      if (!mounted) return;
      _applyEntryState(entry.id, newState);
    } catch (_) {
      if (mounted) {
        showAppToast(
          context,
          AppLocalizations.of(context).toastActivationFailed,
        );
      }
    }
  }

  // Marks (or unmarks) one known/granted spell as cast. Applied locally right away from the
  // *request's own* desired value rather than the server's response — unlike counters/stats, the
  // PATCH's response is just the model's HP/WP/CP/counters (EntryState), not the spell's own new
  // `cast` flag (that lives on ListEntry.pools/grantedSpells) — so there's nothing to reconcile
  // against; the client already knows exactly what it just asked for.
  Future<void> _toggleSpellCast(api.ListEntry entry, KnownSpell spell) async {
    final key = spell.key;
    if (key == null) return;
    final newCast = !spell.cast;
    try {
      await GameService().updateSpellCast(
        widget.gameId,
        entry.id,
        key: key,
        cast: newCast,
      );
      if (!mounted) return;
      _applySpellCast(entry.id, key, newCast);
    } catch (_) {
      if (mounted) {
        showAppToast(context, AppLocalizations.of(context).toastSpellUpdateFailed);
      }
    }
  }

  void _applySpellCast(int listEntryId, String key, bool cast) {
    final data = _data;
    if (data == null) return;
    _mutationSeq++;
    final gang = data.gang;
    setState(() {
      _data = _GangTabData(
        gang: gang.rebuild(
          (b) => b.entries.replace(
            gang.entries.map(
              (e) => e.id == listEntryId ? _withSpellCast(e, key, cast) : e,
            ),
          ),
        ),
        profiles: data.profiles,
        equipment: data.equipment,
      );
    });
  }

  api.ListEntry _withSpellCast(api.ListEntry entry, String key, bool cast) {
    return entry.rebuild(
      (b) => b
        ..pools.replace(
          entry.pools.map(
            (pool) => pool.rebuild(
              (pb) => pb
                ..cantrips.replace(
                  pool.cantrips.map(
                    (s) => s.key == key ? s.rebuild((sb) => sb.cast = cast) : s,
                  ),
                )
                ..spells.replace(
                  pool.spells.map(
                    (s) => s.key == key ? s.rebuild((sb) => sb.cast = cast) : s,
                  ),
                ),
            ),
          ),
        )
        ..grantedSpells.replace(
          entry.grantedSpells.map(
            (g) => g.key == key ? g.rebuild((gb) => gb.cast = cast) : g,
          ),
        ),
    );
  }

  /// Replaces the whole gang after a summon or dismissal — unlike a counter/stat edit, the roster
  /// itself changed, so there is no single entry to patch in.
  void _applyGang(api.ModelList gang) {
    final data = _data;
    if (data == null) return;
    _mutationSeq++;
    setState(() {
      _data = _GangTabData(
        gang: gang,
        profiles: data.profiles,
        equipment: data.equipment,
      );
    });
  }

  void _summon() {
    showDialog(
      context: context,
      builder: (_) =>
          _SummonPickerDialog(gameId: widget.gameId, onSummoned: _applyGang),
    );
  }

  /// Removes a summoned model. Only offered on summoned models — the hired roster is frozen for the
  /// game, and the server refuses anything else.
  Future<void> _dismissSummon(api.ListEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDismissDialog(name: entry.name),
    );
    if (confirmed != true || !mounted) return;
    try {
      _applyGang(await GameService().dismissSummon(widget.gameId, entry.id));
    } catch (_) {
      if (mounted) {
        showAppToast(context, AppLocalizations.of(context).toastRemoveModelFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_failed) {
      return ErrorRetryView(
        message: AppLocalizations.of(context).gangViewerLoadFailed,
        onRetry: () {
          setState(() => _failed = false);
          _load();
        },
      );
    }
    final data = _data;
    if (data == null) {
      return Center(
        child: CircularProgressIndicator(color: context.accentColor),
      );
    }
    return _ReadOnlyGangBody(
      gang: data.gang,
      profiles: data.profiles,
      equipment: data.equipment,
      showHeader: widget.showListHeader,
      onEditModel: widget.editable ? _editModel : null,
      onEditStats: widget.editable ? _editStats : null,
      onToggleActivated: widget.editable ? _toggleActivated : null,
      onToggleToken: widget.editable ? _toggleToken : null,
      onToggleSpellCast: widget.editable ? _toggleSpellCast : null,
      onSummon: widget.editable ? _summon : null,
      onDismissSummon: widget.editable ? _dismissSummon : null,
    );
  }
}
