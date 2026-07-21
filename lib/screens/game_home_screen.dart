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

import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../services/game_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_input.dart';
import '../widgets/app_toast.dart';
import '../widgets/bottom_sheet_surface.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import '../widgets/status_views.dart';
import 'account_screen.dart';
import 'game_session_screen.dart';

class GameHomeScreen extends StatefulWidget {
  const GameHomeScreen({super.key, this.initialJoinCode});

  /// Pre-fills and opens the join sheet, e.g. when arriving from a `/join` deep link.
  final String? initialJoinCode;

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _service = GameService();
  late final _tabController = TabController(length: 2, vsync: this);
  List<api.Game> _activeGames = [];
  List<api.Game> _archivedGames = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    authService.addListener(_onAuthChanged);
    if (!authService.isLoggedIn) {
      _loading = false;
    } else {
      // Show the last-known games instantly if we have them, then refresh in the background — same
      // as the gangs index, so switching section and back doesn't blank to a spinner. First visit
      // this session (no cache yet) falls back to a blocking load.
      final active = _service.cachedGames(visibility: 'active');
      final archived = _service.cachedGames(visibility: 'archived');
      if (active != null && archived != null) {
        _activeGames = active;
        _archivedGames = archived;
        _loading = false;
        _refresh();
      } else {
        _load();
      }
    }
    if (widget.initialJoinCode != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showJoinSheet(prefill: widget.initialJoinCode),
      );
    }
  }

  @override
  void dispose() {
    authService.removeListener(_onAuthChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    if (authService.isLoggedIn) {
      _load();
    } else if (mounted) {
      setState(() {
        _activeGames = [];
        _archivedGames = [];
        _error = null;
        _loading = false;
      });
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _service.loadMyGames(visibility: 'active'),
        _service.loadMyGames(visibility: 'archived'),
      ]);
      if (!mounted) return;
      setState(() {
        _activeGames = results[0];
        _archivedGames = results[1];
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('GameHomeScreen error: $e\n$st');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// Refreshes both game lists in the background while the cached games stay on screen — no spinner,
  /// and a failure is silent since we already have something to show.
  Future<void> _refresh() async {
    try {
      final results = await Future.wait([
        _service.loadMyGames(visibility: 'active'),
        _service.loadMyGames(visibility: 'archived'),
      ]);
      if (!mounted) return;
      setState(() {
        _activeGames = results[0];
        _archivedGames = results[1];
        _error = null;
      });
    } catch (e) {
      debugPrint('GameHomeScreen background refresh failed: $e');
    }
  }

  void _openGame(int gameId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameSessionScreen(gameId: gameId)),
    );
    await _refresh();
  }

  Future<void> _archiveGame(int gameId) async {
    try {
      await _service.archiveGame(gameId);
      if (mounted) showAppToast(context, AppLocalizations.of(context).toastGameArchived);
      await _refresh();
    } catch (e) {
      if (mounted) showAppToast(context, AppLocalizations.of(context).toastGameArchiveFailed);
    }
  }

  Future<void> _unarchiveGame(int gameId) async {
    try {
      await _service.unarchiveGame(gameId);
      if (mounted) showAppToast(context, AppLocalizations.of(context).toastGameRestored);
      await _refresh();
    } catch (e) {
      if (mounted) showAppToast(context, AppLocalizations.of(context).toastGameRestoreFailed);
    }
  }

  Future<void> _deleteGame(int gameId) async {
    try {
      await _service.deleteGame(gameId);
      if (mounted) showAppToast(context, AppLocalizations.of(context).toastGameDeleted);
      await _refresh();
    } catch (e) {
      if (mounted) showAppToast(context, AppLocalizations.of(context).toastGameDeleteFailed);
    }
  }

  Future<void> _showCreateSheet() async {
    final game = await showModalBottomSheet<api.Game>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateGameSheet(),
    );
    if (game != null && mounted) _openGame(game.id);
  }

  Future<void> _showJoinSheet({String? prefill}) async {
    if (!mounted) return;
    final game = await showModalBottomSheet<api.Game>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JoinGameSheet(initialCode: prefill),
    );
    if (game != null && mounted) _openGame(game.id);
  }

  Future<void> _showActionSheet() async {
    final action = await showModalBottomSheet<_GameAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _GameActionSheet(),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case _GameAction.create:
        _showCreateSheet();
        break;
      case _GameAction.join:
        _showJoinSheet();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.game),
      floatingActionButton: authService.isLoggedIn
          ? FloatingActionButton(
              onPressed: _showActionSheet,
              backgroundColor: context.accentColor,
              foregroundColor: Colors.white,
              mini: true,
              child: const Icon(Icons.add),
            )
          : null,
      body: AppBackground(
        child: Column(
          children: [
            _buildHeader(context),
            if (authService.isLoggedIn) ...[
              const SizedBox(height: 8),
              _buildTabBar(context),
            ],
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ScreenHeader(
      title: AppLocalizations.of(context).navGames,
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: context.accentColor,
        unselectedLabelColor: context.subtleTextColor,
        indicatorColor: context.accentColor,
        dividerColor: context.subtleTextColor.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.cinzel(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: GoogleFonts.cinzel(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 1,
        ),
        tabs: [
          Tab(text: AppLocalizations.of(context).gamesTabActive),
          Tab(text: AppLocalizations.of(context).gamesTabArchived),
        ],
      ),
    );
  }

  Widget _buildLoggedOut() {
    return LoggedOutView(
      message: AppLocalizations.of(context).gamesLoginPrompt,
      onLogin: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountScreen()),
      ),
    );
  }

  Widget _buildBody() {
    if (!authService.isLoggedIn) return _buildLoggedOut();
    if (_loading) return const LoadingView();
    if (_error != null) {
      return ErrorRetryView(onRetry: _load);
    }
    final l10n = AppLocalizations.of(context);
    return TabBarView(
      controller: _tabController,
      children: [
        _buildGameList(
          games: _activeGames,
          isArchivedTab: false,
          emptyIcon: Icons.sports_esports_outlined,
          emptyTitle: l10n.gamesEmptyActiveTitle,
          emptySubtitle: l10n.gamesEmptyActiveSubtitle,
        ),
        _buildGameList(
          games: _archivedGames,
          isArchivedTab: true,
          emptyIcon: Icons.archive_outlined,
          emptyTitle: l10n.gamesEmptyArchivedTitle,
          emptySubtitle: l10n.gamesEmptyArchivedSubtitle,
        ),
      ],
    );
  }

  Widget _buildGameList({
    required List<api.Game> games,
    required bool isArchivedTab,
    required IconData emptyIcon,
    required String emptyTitle,
    required String emptySubtitle,
  }) {
    if (games.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              emptyIcon,
              size: 56,
              color: context.subtleTextColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              emptyTitle,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                color: context.subtleTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: TextStyle(
                fontSize: 13,
                color: context.subtleTextColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: games.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _GameTile(
        game: games[i],
        isArchived: isArchivedTab,
        onPlay: () => _openGame(games[i].id),
        onDelete: () => _deleteGame(games[i].id),
        onArchiveToggle: () => isArchivedTab
            ? _unarchiveGame(games[i].id)
            : _archiveGame(games[i].id),
      ),
    );
  }
}

class _GameTile extends StatefulWidget {
  const _GameTile({
    required this.game,
    required this.isArchived,
    required this.onPlay,
    required this.onDelete,
    required this.onArchiveToggle,
  });
  final api.Game game;
  final bool isArchived;
  final VoidCallback onPlay;
  final VoidCallback onDelete;
  final VoidCallback onArchiveToggle;

  @override
  State<_GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<_GameTile> {
  bool _expanded = false;

  api.Game get _game => widget.game;
  String get _statusLabel =>
      (api.standardSerializers.serializeWith(
                api.GameStatusEnum.serializer,
                _game.status,
              )
              as String)
          .replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _game.name,
                          style: GoogleFonts.cinzel(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: context.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context).gameStatusCodeLine(
                            '${_statusLabel[0].toUpperCase()}${_statusLabel.substring(1)}',
                            _game.joinCode,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: context.subtleTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: context.accentColor,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildDetails(context),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final players = _game.players;
    final p1 = players.firstOrNull;
    final p2 = players.length > 1 ? players[1] : null;

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: context.subtleTextColor.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 12),
          Text(
            _game.scenario.name,
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          if (_game.scenario.agendaRules.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _game.scenario.agendaRules
                  .map((r) => _agendaRuleChip(context, r))
                  .toList(),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            l10n.gameVersus(
              p1?.username ?? '—',
              p2?.username ?? l10n.gameWaitingForOpponentInline,
            ),
            style: GoogleFonts.cinzel(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 6),
          if (p1 != null) _buildPlayerListLine(context, p1),
          if (p2 != null) _buildPlayerListLine(context, p2),
          const SizedBox(height: 8),
          Text(
            l10n.ducatsAmount(_game.ducatLimit),
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline),
                color: context.dangerColor,
                tooltip: l10n.tooltipDeleteGame,
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: widget.onArchiveToggle,
                icon: Icon(
                  widget.isArchived
                      ? Icons.unarchive_outlined
                      : Icons.archive_outlined,
                ),
                color: context.subtleTextColor,
                tooltip: widget.isArchived ? l10n.tooltipRestoreGame : l10n.tooltipArchiveGame,
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: widget.onPlay,
                icon: const Icon(Icons.play_circle_fill),
                color: context.accentColor,
                iconSize: 28,
                tooltip: l10n.tooltipOpenGame,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // A compact pill for one scenario agenda special rule (rulebook p.36), mirroring the labels the
  // in-game Score tab uses. Shown on the expanded game card so the rules are visible before opening.
  Widget _agendaRuleChip(
    BuildContext context,
    api.ScenarioAgendaRulesEnum rule,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.accentColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        _agendaRuleLabel(AppLocalizations.of(context), rule),
        style: GoogleFonts.cinzel(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: context.textColor,
        ),
      ),
    );
  }

  static String _agendaRuleLabel(AppLocalizations l10n, api.ScenarioAgendaRulesEnum rule) =>
      switch (rule) {
        api.ScenarioAgendaRulesEnum.cycle => l10n.agendaRuleCycle,
        api.ScenarioAgendaRulesEnum.secondary => l10n.agendaRuleSecondary,
        api.ScenarioAgendaRulesEnum.double_ => l10n.agendaRuleDouble,
        api.ScenarioAgendaRulesEnum.secret => l10n.agendaRuleSecret,
        api.ScenarioAgendaRulesEnum.total => l10n.agendaRuleTotal,
        _ => rule.name,
      };

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          l10n.gameDeleteTitle,
          style: GoogleFonts.cinzel(color: context.textColor),
        ),
        content: Text(l10n.gameDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            child: Text(l10n.actionDelete, style: TextStyle(color: context.dangerColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerListLine(BuildContext context, api.GamePlayer p) {
    final l10n = AppLocalizations.of(context);
    final listName = p.list?.name ?? p.list?.faction;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        l10n.gamePlayerListLine(p.username, listName ?? l10n.gameNoGangSelected),
        style: TextStyle(fontSize: 12, color: context.subtleTextColor),
      ),
    );
  }
}

enum _GameAction { create, join }

class _GameActionSheet extends StatelessWidget {
  const _GameActionSheet();

  @override
  Widget build(BuildContext context) {
    return BottomSheetSurface(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(_GameAction.create),
            icon: const Icon(Icons.add, size: 18),
            label: Text(AppLocalizations.of(context).actionCreateGame),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(_GameAction.join),
            icon: const Icon(Icons.meeting_room_outlined, size: 18),
            label: Text(AppLocalizations.of(context).actionJoinGame),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.accentColor,
              side: BorderSide(color: context.accentColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CreateGameSheet extends StatefulWidget {
  const _CreateGameSheet();

  @override
  State<_CreateGameSheet> createState() => _CreateGameSheetState();
}

class _CreateGameSheetState extends State<_CreateGameSheet> {
  final _service = GameService();
  final _nameController = TextEditingController();
  final _ducatController = TextEditingController();
  final _boardSizeController = TextEditingController();
  List<api.Scenario> _scenarios = [];
  api.Scenario? _selected;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ducatController.dispose();
    _boardSizeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final scenarios = await _service.loadScenarios();
      if (!mounted) return;
      setState(() {
        _scenarios = scenarios;
        _selected = scenarios.firstOrNull;
        _ducatController.text = '${_selected?.ducats ?? ''}';
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context).gameLoadScenariosFailed;
        _loading = false;
      });
    }
  }

  void _selectScenario(api.Scenario s) {
    setState(() {
      _selected = s;
      _ducatController.text = '${s.ducats}';
    });
  }

  Future<void> _submit() async {
    final scenario = _selected;
    if (scenario == null || _saving) return;
    setState(() => _saving = true);
    try {
      final name = _nameController.text.trim();
      final ducatLimit = int.tryParse(_ducatController.text.trim());
      final boardSize = _boardSizeController.text.trim();
      final game = await _service.createGame(
        scenarioId: scenario.id,
        name: name.isEmpty ? null : name,
        ducatLimit: ducatLimit,
        boardSize: boardSize.isEmpty ? null : boardSize,
      );
      if (mounted) Navigator.of(context).pop(game);
    } catch (e) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomSheetSurface(
      scrollable: true,
      title: l10n.gameNewTitle,
      children: [
        if (_loading)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: CircularProgressIndicator(color: context.accentColor),
            ),
          )
        else if (_error != null)
          Text(_error!, style: TextStyle(color: context.dangerColor))
        else ...[
          Text(
            l10n.gameScenarioLabel,
            style: TextStyle(
              fontSize: 12,
              color: context.subtleTextColor,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          ..._scenarios.map(
            (s) => _ScenarioTile(
              scenario: s,
              selected: _selected?.id == s.id,
              onTap: () => _selectScenario(s),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
            decoration: goldInputDecoration(
              context,
              label: l10n.gameNameOptional,
              hint: _selected?.name,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ducatController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
            decoration: goldInputDecoration(context, label: l10n.gameDucatLimit),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _boardSizeController,
            style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
            decoration: goldInputDecoration(
              context,
              label: l10n.gameBoardSizeOverride,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selected == null || _saving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      l10n.actionCreateGame,
                      style: GoogleFonts.cinzel(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ScenarioTile extends StatelessWidget {
  const _ScenarioTile({
    required this.scenario,
    required this.selected,
    required this.onTap,
  });
  final api.Scenario scenario;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? context.accentColor.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? context.accentColor
                  : context.subtleTextColor.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scenario.name,
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textColor,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).gameScenarioMeta(
                            scenario.ducats,
                            scenario.duration,
                          ) +
                          (scenario.asymmetric
                              ? ' · ${AppLocalizations.of(context).attackerDefender}'
                              : ''),
                      style: TextStyle(
                        fontSize: 11,
                        color: context.subtleTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: context.accentColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _JoinGameSheet extends StatefulWidget {
  const _JoinGameSheet({this.initialCode});

  final String? initialCode;

  @override
  State<_JoinGameSheet> createState() => _JoinGameSheetState();
}

class _JoinGameSheetState extends State<_JoinGameSheet> {
  final _service = GameService();
  late final _codeController = TextEditingController(text: widget.initialCode);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    if (code.isEmpty || _saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final game = await _service.joinGame(code);
      if (mounted) Navigator.of(context).pop(game);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = AppLocalizations.of(context).gameJoinFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomSheetSurface(
      title: l10n.actionJoinGame,
      children: [
        TextField(
          controller: _codeController,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          style: GoogleFonts.cinzel(
            color: context.textColor,
            fontSize: 20,
            letterSpacing: 4,
          ),
          textAlign: TextAlign.center,
          decoration: goldInputDecoration(context, label: l10n.gameJoinCode),
          onSubmitted: (_) => _submit(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: TextStyle(color: context.dangerColor, fontSize: 13),
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    l10n.actionJoin,
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
