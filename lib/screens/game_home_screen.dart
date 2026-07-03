import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../models/game.dart' as models;
import '../services/game_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/glass_panel.dart';
import 'account_screen.dart';
import 'game_session_screen.dart';

const _kBackground = Color(0xFFF0EDE6);
const _kGold = Color(0xFFC4A050);

class GameHomeScreen extends StatefulWidget {
  const GameHomeScreen({super.key, this.initialJoinCode});

  /// Pre-fills and opens the join sheet, e.g. when arriving from a `/join` deep link.
  final String? initialJoinCode;

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _service = GameService();
  List<models.Game> _games = [];
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
      WidgetsBinding.instance.addPostFrameCallback((_) => _showJoinSheet(prefill: widget.initialJoinCode));
    }
  }

  @override
  void dispose() {
    authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (authService.isLoggedIn) {
      _load();
    } else if (mounted) {
      setState(() {
        _games = [];
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
      final games = await _service.loadMyGames();
      setState(() {
        _games = games;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('GameHomeScreen error: $e\n$st');
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _openGame(int gameId) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => GameSessionScreen(gameId: gameId)));
    await _load();
  }

  Future<void> _showCreateSheet() async {
    final game = await showModalBottomSheet<models.Game>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateGameSheet(),
    );
    if (game != null && mounted) _openGame(game.id);
  }

  Future<void> _showJoinSheet({String? prefill}) async {
    if (!mounted) return;
    final game = await showModalBottomSheet<models.Game>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JoinGameSheet(initialCode: prefill),
    );
    if (game != null && mounted) _openGame(game.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBackground,
      drawer: const AppDrawer(current: AppDrawerRoute.game),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Theme.of(context).brightness == Brightness.dark ? 'assets/images/bg_dark.png' : 'assets/images/bg_light.png',
              ),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(color: Colors.black.withOpacity(0.05)),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(context),
                    if (authService.isLoggedIn) ...[
                      const SizedBox(height: 8),
                      _buildActions(),
                    ],
                    const SizedBox(height: 8),
                    Expanded(child: _buildBody()),
                  ],
                ),
              ),
            ],
          ),
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
            icon: Icon(Icons.menu, color: context.textColor),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          const SizedBox(width: 4),
          Text(
            'Game',
            style: GoogleFonts.cinzel(fontSize: 24, fontWeight: FontWeight.w700, color: context.textColor, letterSpacing: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showCreateSheet,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _showJoinSheet,
              icon: const Icon(Icons.meeting_room_outlined, size: 18),
              label: const Text('Join Game'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _kGold,
                side: const BorderSide(color: _kGold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedOut() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 40, color: context.subtleTextColor),
            const SizedBox(height: 12),
            Text(
              'Log in to create or join a game',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.subtleTextColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: _kGold, foregroundColor: Colors.white),
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (!authService.isLoggedIn) return _buildLoggedOut();
    if (_loading) return const Center(child: CircularProgressIndicator(color: _kGold));
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 40, color: context.subtleTextColor),
            const SizedBox(height: 12),
            Text('Could not reach server', style: TextStyle(color: context.subtleTextColor)),
            const SizedBox(height: 8),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_games.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_esports_outlined, size: 56, color: context.subtleTextColor.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text('No games yet', style: GoogleFonts.cinzel(fontSize: 16, color: context.subtleTextColor)),
            const SizedBox(height: 8),
            Text(
              'Create a game or join one with a code',
              style: TextStyle(fontSize: 13, color: context.subtleTextColor.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: _games.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _GameTile(game: _games[i], onTap: () => _openGame(_games[i].id)),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({required this.game, required this.onTap});
  final models.Game game;
  final VoidCallback onTap;

  String get _statusLabel => game.status.replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassPanel(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.scenario.name,
                      style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.w600, color: context.textColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_statusLabel[0].toUpperCase()}${_statusLabel.substring(1)} · Code ${game.joinCode}',
                      style: TextStyle(fontSize: 12, color: context.subtleTextColor),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: isDark ? _kGold : const Color(0xFF8B1A1A), size: 20),
            ],
          ),
        ),
      ),
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
  final _ducatController = TextEditingController();
  final _boardSizeController = TextEditingController();
  List<models.Scenario> _scenarios = [];
  models.Scenario? _selected;
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
    _ducatController.dispose();
    _boardSizeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final scenarios = await _service.loadScenarios();
      setState(() {
        _scenarios = scenarios;
        _selected = scenarios.firstOrNull;
        _ducatController.text = '${_selected?.ducats ?? ''}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load scenarios';
        _loading = false;
      });
    }
  }

  void _selectScenario(models.Scenario s) {
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
      final ducatLimit = int.tryParse(_ducatController.text.trim());
      final boardSize = _boardSizeController.text.trim();
      final game = await _service.createGame(
        scenarioId: scenario.id,
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: context.cardBgColor.withOpacity(0.92),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.5),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: context.subtleTextColor.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'New Game',
                    style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w700, color: context.textColor, letterSpacing: 2),
                  ),
                  const SizedBox(height: 20),
                  if (_loading)
                    const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: _kGold)))
                  else if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red))
                  else ...[
                    Text('Scenario', style: TextStyle(fontSize: 12, color: context.subtleTextColor, letterSpacing: 1)),
                    const SizedBox(height: 10),
                    ..._scenarios.map((s) => _ScenarioTile(
                          scenario: s,
                          selected: _selected?.id == s.id,
                          onTap: () => _selectScenario(s),
                        )),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ducatController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
                      decoration: InputDecoration(
                        labelText: 'Ducat limit',
                        labelStyle: TextStyle(color: context.subtleTextColor, fontSize: 13),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _kGold.withOpacity(0.5))),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _kGold, width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _boardSizeController,
                      style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
                      decoration: InputDecoration(
                        labelText: 'Board size (optional override)',
                        labelStyle: TextStyle(color: context.subtleTextColor, fontSize: 13),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _kGold.withOpacity(0.5))),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _kGold, width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selected == null || _saving ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGold,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _saving
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text('Create Game', style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScenarioTile extends StatelessWidget {
  const _ScenarioTile({required this.scenario, required this.selected, required this.onTap});
  final models.Scenario scenario;
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
            color: selected ? _kGold.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? _kGold : context.subtleTextColor.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scenario.name, style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w600, color: context.textColor)),
                    Text(
                      '${scenario.ducats} ducats · ${scenario.duration}${scenario.asymmetric ? ' · Attacker/Defender' : ''}',
                      style: TextStyle(fontSize: 11, color: context.subtleTextColor),
                    ),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: _kGold, size: 20),
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: context.cardBgColor.withOpacity(0.92),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.5),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: context.subtleTextColor.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Join Game',
                  style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w700, color: context.textColor, letterSpacing: 2),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _codeController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.cinzel(color: context.textColor, fontSize: 20, letterSpacing: 4),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Join code',
                    labelStyle: TextStyle(color: context.subtleTextColor, fontSize: 13),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _kGold.withOpacity(0.5))),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _kGold, width: 1.5)),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kGold,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _saving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text('Join', style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
