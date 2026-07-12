import 'dart:async';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/profile.dart';
import '../services/equipment_service.dart';
import '../services/game_service.dart';
import '../services/profile_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_toast.dart';
import '../widgets/equipment_detail.dart';
import '../widgets/faction_badge.dart';
import '../widgets/points_bar.dart';
import '../widgets/spell_chips.dart';
import '../widgets/themed_dialog_card.dart';
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
              'Gangs',
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
    this.showListHeader = true,
  });

  final int gameId;
  final int playerId;
  final bool editable;
  final bool showListHeader;

  @override
  State<_GangTab> createState() => _GangTabState();
}

class _GangTabState extends State<_GangTab> with AutomaticKeepAliveClientMixin {
  final _gameService = GameService();
  _GangTabData? _data;
  bool _failed = false;

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

  void _editCounters(api.ListEntry entry) {
    showDialog(
      context: context,
      builder: (_) => _CounterEditDialog(
        gameId: widget.gameId,
        entry: entry,
        onStateChanged: _applyEntryState,
      ),
    );
  }

  void _editStats(api.ListEntry entry) {
    showDialog(
      context: context,
      builder: (_) => _StatEditDialog(
        gameId: widget.gameId,
        entry: entry,
        onStateChanged: _applyEntryState,
      ),
    );
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
          'Could not update the activation. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_failed) {
      return Center(
        child: Text(
          'Could not load this gang.',
          style: TextStyle(color: context.subtleTextColor),
        ),
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
      onEditCounters: widget.editable ? _editCounters : null,
      onEditStats: widget.editable ? _editStats : null,
      onToggleActivated: widget.editable ? _toggleActivated : null,
    );
  }
}
