import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (authService.isLoggedIn) {
      _load();
    } else {
      _loading = false;
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

  void _openGame(int gameId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameSessionScreen(gameId: gameId)),
    );
    await _load();
  }

  Future<void> _archiveGame(int gameId) async {
    try {
      await _service.archiveGame(gameId);
      if (mounted) showAppToast(context, 'Game archived');
      await _load();
    } catch (e) {
      if (mounted) showAppToast(context, 'Could not archive this game');
    }
  }

  Future<void> _unarchiveGame(int gameId) async {
    try {
      await _service.unarchiveGame(gameId);
      if (mounted) showAppToast(context, 'Game restored');
      await _load();
    } catch (e) {
      if (mounted) showAppToast(context, 'Could not restore this game');
    }
  }

  Future<void> _deleteGame(int gameId) async {
    try {
      await _service.deleteGame(gameId);
      if (mounted) showAppToast(context, 'Game deleted');
      await _load();
    } catch (e) {
      if (mounted) showAppToast(context, 'Could not delete this game');
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
      title: 'Games',
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: AppPalette.gold,
        unselectedLabelColor: context.subtleTextColor,
        indicatorColor: AppPalette.gold,
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
        tabs: const [
          Tab(text: 'Active'),
          Tab(text: 'Archived'),
        ],
      ),
    );
  }

  Widget _buildLoggedOut() {
    return LoggedOutView(
      message: 'Log in to create or join a game',
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
    return TabBarView(
      controller: _tabController,
      children: [
        _buildGameList(
          games: _activeGames,
          isArchivedTab: false,
          emptyIcon: Icons.sports_esports_outlined,
          emptyTitle: 'No games yet',
          emptySubtitle: 'Create a game or join one with a code',
        ),
        _buildGameList(
          games: _archivedGames,
          isArchivedTab: true,
          emptyIcon: Icons.archive_outlined,
          emptyTitle: 'No archived games',
          emptySubtitle: 'Games you archive will show up here',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                          '${_statusLabel[0].toUpperCase()}${_statusLabel.substring(1)} · Code ${_game.joinCode}',
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
                      color: isDark ? AppPalette.gold : AppPalette.red,
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
    final players = _game.players;
    final p1 = players.firstOrNull;
    final p2 = players.length > 1 ? players[1] : null;

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: context.subtleTextColor.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 12),
          Text(
            _game.scenario.name,
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 6),
          Text(
            '${p1?.username ?? '—'} vs ${p2?.username ?? 'waiting for an opponent'}',
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
            '${_game.ducatLimit} ducats',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline),
                color: Colors.red.shade400,
                tooltip: 'Delete game',
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
                tooltip: widget.isArchived ? 'Restore game' : 'Archive game',
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: widget.onPlay,
                icon: const Icon(Icons.play_circle_fill),
                color: AppPalette.gold,
                iconSize: 28,
                tooltip: 'Open game',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete Game',
          style: GoogleFonts.cinzel(color: context.textColor),
        ),
        content: const Text(
          'Delete this game? You won\'t be able to see it again, even if your opponent still can.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerListLine(BuildContext context, api.GamePlayer p) {
    final listName = p.list?.name ?? p.list?.faction;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        '${p.username}: ${listName ?? 'No gang selected yet'}',
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
            label: const Text('Create Game'),
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
            label: const Text('Join Game'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppPalette.gold,
              side: const BorderSide(color: AppPalette.gold),
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
        _error = 'Could not load scenarios';
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
    return BottomSheetSurface(
      scrollable: true,
      title: 'New Game',
      children: [
        if (_loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppPalette.gold),
            ),
          )
        else if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red))
        else ...[
          Text(
            'Scenario',
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
              label: 'Game name (optional)',
              hint: _selected?.name,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ducatController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
            decoration: goldInputDecoration(context, label: 'Ducat limit'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _boardSizeController,
            style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
            decoration: goldInputDecoration(
              context,
              label: 'Board size (optional override)',
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
                      'Create Game',
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
                ? AppPalette.gold.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? AppPalette.gold
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
                      '${scenario.ducats} ducats · ${scenario.duration}${scenario.asymmetric ? ' · Attacker/Defender' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: context.subtleTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: AppPalette.gold,
                  size: 20,
                ),
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
          _error = 'Could not join — check the code and try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetSurface(
      title: 'Join Game',
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
          decoration: goldInputDecoration(context, label: 'Join code'),
          onSubmitted: (_) => _submit(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: const TextStyle(color: Colors.red, fontSize: 13),
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
                    'Join',
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
