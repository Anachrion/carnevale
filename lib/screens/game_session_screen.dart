import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../main.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/game.dart';
import '../services/game_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_toast.dart';
import '../widgets/glass_panel.dart';
import '../widgets/status_views.dart';
import 'gang_viewer_screen.dart';

const _kGangsVisibleStatuses = {
  api.GameStatusEnum.agendaDraw,
  api.GameStatusEnum.deploying,
};
const _kScrollablePhaseStatuses = {
  api.GameStatusEnum.pending,
  api.GameStatusEnum.gangSelection,
  api.GameStatusEnum.agendaDraw,
  api.GameStatusEnum.deploying,
};

/// One status-driven screen for the whole two-player setup flow, rather than a
/// stack of pushed screens: on load (or reconnect) it fetches a snapshot and
/// subscribes for live updates, then renders whichever phase the server's
/// `status` says — see GAME_SETUP_FLOW.md for the state machine.
class GameSessionScreen extends StatefulWidget {
  const GameSessionScreen({super.key, required this.gameId});

  final int gameId;

  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen> {
  final _service = GameService();
  bool _loading = true;
  bool _busy = false;
  String? _error;
  Future<List<AvailableGang>>? _availableGangsFuture;

  api.Game? get _game => _service.currentGame;
  api.GamePlayer? get _me => _game?.playerFor(authService.currentUser!.id);
  api.GamePlayer? get _opponent => _game?.players
      .where((p) => p.userId != authService.currentUser!.id)
      .firstOrNull;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onUpdate);
    _init();
  }

  @override
  void dispose() {
    _service.removeListener(_onUpdate);
    _service.stopWatching();
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _init() async {
    try {
      await _service.watch(widget.gameId);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Could not load this game.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted)
        showAppToast(context, 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final game = _game;
    final me = _me;
    final opponent = _opponent;
    final showGangsButton =
        game != null &&
        me != null &&
        opponent != null &&
        _kGangsVisibleStatuses.contains(game.status);
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
              _game?.name ?? 'Game',
              style: GoogleFonts.cinzel(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: context.textColor,
                letterSpacing: 2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showGangsButton)
            IconButton(
              icon: Icon(Icons.groups_outlined, color: context.textColor),
              tooltip: 'View gangs',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameGangsScreen(
                    gameId: game.id,
                    myPlayerId: me.id,
                    myLabel: 'My Gang',
                    opponentPlayerId: opponent.id,
                    opponentLabel: opponent.username,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) return const LoadingView();
    if (_error != null) {
      return ErrorRetryView(
        message: _error!,
        onRetry: () => setState(() {
          _loading = true;
          _error = null;
          _init();
        }),
      );
    }
    final game = _game;
    final me = _me;
    if (game == null || me == null)
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.gold),
      );

    // in_progress/completed (and any future status) render full-bleed below the header instead
    // of inside a SingleChildScrollView, since the models tab view manages its own scrolling
    // per-tab and needs a bounded height to lay out its TabBarView.
    if (!_kScrollablePhaseStatuses.contains(game.status)) {
      return _buildInProgressPhase(context, game, me);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: switch (game.status) {
        api.GameStatusEnum.pending => _buildLobbyPhase(context, game, me),
        api.GameStatusEnum.gangSelection
            when game.scenario.asymmetric && _roleRolloffPending(game, me) =>
          _buildRoleRolloffPhase(context, game, me),
        api.GameStatusEnum.gangSelection => _buildGangSelectionPhase(
          context,
          game,
          me,
        ),
        api.GameStatusEnum.agendaDraw => _buildAgendaDrawPhase(
          context,
          game,
          me,
        ),
        _ => _buildDeployingPhase(context, game, me),
      },
    );
  }

  bool _roleRolloffPending(api.Game game, api.GamePlayer me) =>
      me.role == null || (_opponent?.role == null);

  // ── Lobby ────────────────────────────────────────────────────────────────

  Widget _buildLobbyPhase(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
  ) {
    return _PhaseCard(
      title: 'Waiting for an opponent',
      children: [
        Text(
          'Share this code with the other player:',
          style: TextStyle(color: context.subtleTextColor, fontSize: 13),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: game.joinCode));
            showAppToast(context, 'Join code copied');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppPalette.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppPalette.gold),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  game.joinCode,
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 6,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.copy, color: AppPalette.gold, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const CircularProgressIndicator(color: AppPalette.gold),
      ],
    );
  }

  // ── Role roll-off (asymmetric scenarios only) ───────────────────────────

  Widget _buildRoleRolloffPhase(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
  ) {
    final opponentWon = _opponent?.wonRoleRoll ?? false;
    if (me.wonRoleRoll && me.role == null) {
      return _PhaseCard(
        title: 'You won the roll-off!',
        children: [
          Text(
            'Choose your role:',
            style: TextStyle(color: context.subtleTextColor),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Attacker',
                  onTap: () =>
                      _run(() => _service.pickRole(game.id, 'attacker')),
                  busy: _busy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'Defender',
                  onTap: () =>
                      _run(() => _service.pickRole(game.id, 'defender')),
                  busy: _busy,
                ),
              ),
            ],
          ),
        ],
      );
    }
    if (me.wonRoleRoll || opponentWon) {
      final winnerName = opponentWon
          ? (_opponent?.username ?? 'Opponent')
          : 'you';
      return _PhaseCard(
        title: 'Role roll-off',
        children: [
          Text(
            'Waiting for $winnerName to choose a role...',
            style: TextStyle(color: context.subtleTextColor),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(color: AppPalette.gold),
        ],
      );
    }
    return _PhaseCard(
      title: 'Role roll-off',
      children: [
        Text(
          'Determining who picks a role...',
          style: TextStyle(color: context.subtleTextColor),
        ),
        const SizedBox(height: 16),
        const CircularProgressIndicator(color: AppPalette.gold),
      ],
    );
  }

  // ── Gang selection ───────────────────────────────────────────────────────

  Widget _buildGangSelectionPhase(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
  ) {
    if (me.list != null) {
      return _PhaseCard(
        title: 'Gang selected',
        children: [
          Text(
            'You are playing "${me.list!.name ?? me.list!.faction}".',
            style: TextStyle(color: context.subtleTextColor),
          ),
          const SizedBox(height: 16),
          Text(
            _opponent?.list == null
                ? 'Waiting for the opponent to pick a gang...'
                : 'Both gangs are in!',
            style: TextStyle(color: context.subtleTextColor),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(color: AppPalette.gold),
        ],
      );
    }

    _availableGangsFuture ??= _service.availableGangs(game.id);
    return _PhaseCard(
      title: 'Pick your gang',
      subtitle: 'Ducat limit: ${game.ducatLimit}',
      children: [
        FutureBuilder<List<AvailableGang>>(
          future: _availableGangsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: AppPalette.gold),
              );
            final gangs = snapshot.data!;
            if (gangs.isEmpty) {
              return Text(
                'You have no gangs yet — create one from the Gangs tab first.',
                style: TextStyle(color: context.subtleTextColor),
              );
            }
            return Column(
              children: gangs
                  .map(
                    (g) => _GangOptionTile(
                      gang: g.gang,
                      selectable: g.selectable,
                      busy: _busy,
                      onTap: () =>
                          _run(() => _service.selectGang(game.id, g.gang.id)),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  // ── Agenda draw ──────────────────────────────────────────────────────────

  Widget _buildAgendaDrawPhase(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
  ) {
    if (me.agendas.isEmpty) {
      return _PhaseCard(
        title: 'Draw your Agendas',
        subtitle: 'These are private — the opponent never sees them.',
        children: [
          _ActionButton(
            label: 'Draw Agendas',
            onTap: () => _run(() => _service.drawAgendas(game.id)),
            busy: _busy,
          ),
        ],
      );
    }
    return _PhaseCard(
      title: 'Your Agendas',
      children: [
        ...me.agendas.map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.name,
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.w700,
                      color: context.textColor,
                    ),
                  ),
                  Text(
                    a.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.subtleTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Waiting for the opponent to draw...',
          style: TextStyle(color: context.subtleTextColor),
        ),
        const SizedBox(height: 16),
        const CircularProgressIndicator(color: AppPalette.gold),
      ],
    );
  }

  // ── Deploying ────────────────────────────────────────────────────────────

  Widget _buildDeployingPhase(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
  ) {
    final opponent = _opponent;
    final winnerName = me.wonDeploymentRoll
        ? 'You'
        : (opponent?.wonDeploymentRoll ?? false)
        ? (opponent?.username ?? 'Opponent')
        : null;
    return _PhaseCard(
      title: 'Deploy your gangs',
      subtitle:
          'Agree on deployment zones at the table, place your miniatures, then confirm below.',
      children: [
        if (winnerName != null) ...[
          Text(
            '$winnerName won the deployment roll-off.',
            style: TextStyle(color: context.textColor),
          ),
          const SizedBox(height: 16),
        ],
        if (!me.ready)
          _ActionButton(
            label: "I'm Ready",
            onTap: () => _run(() => _service.markReady(game.id)),
            busy: _busy,
          )
        else ...[
          Text(
            'Waiting for the opponent to be ready...',
            style: TextStyle(color: context.subtleTextColor),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(color: AppPalette.gold),
        ],
      ],
    );
  }

  // ── In progress ──────────────────────────────────────────────────────────

  // Setup is complete the moment the game reaches in_progress (or beyond, e.g. completed): both
  // players' models are shown side by side, each tagged with its remaining/starting HP, WP, and
  // CP and its status counters. Counters on your own models are editable via the + button on
  // each tile; HP/WP/CP editing isn't supported yet.
  Widget _buildInProgressPhase(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
  ) {
    final opponent = _opponent;
    if (opponent == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.gold),
      );
    }
    return GangsTabView(
      gameId: game.id,
      myPlayerId: me.id,
      myLabel: 'My Models',
      opponentPlayerId: opponent.id,
      opponentLabel: opponent.username,
      // Mid-game the list is fixed; drop the per-gang name/faction/ducats summary as noise.
      showListHeader: false,
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.title,
    this.subtitle,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cinzel(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: TextStyle(fontSize: 13, color: context.subtleTextColor),
            ),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.busy,
  });

  final String label;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: busy ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.gold,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: busy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(label, style: GoogleFonts.cinzel(fontWeight: FontWeight.w700)),
    );
  }
}

class _GangOptionTile extends StatelessWidget {
  const _GangOptionTile({
    required this.gang,
    required this.selectable,
    required this.busy,
    required this.onTap,
  });

  final api.GangSummary gang;
  final bool selectable;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: selectable && !busy ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selectable
                ? Colors.transparent
                : context.subtleTextColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.subtleTextColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gang.name ?? gang.faction,
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selectable
                            ? context.textColor
                            : context.subtleTextColor,
                      ),
                    ),
                    Text(
                      '${gang.totalCost} / ${gang.points} ducats',
                      style: TextStyle(
                        fontSize: 11,
                        color: context.subtleTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (!selectable)
                Text(
                  'Over limit',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right,
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
