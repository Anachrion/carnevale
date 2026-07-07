import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../main.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/game.dart';
import '../services/game_service.dart';
import '../services/gang_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_toast.dart';
import '../widgets/create_gang_sheet.dart';
import '../widgets/gang_tile.dart';
import '../widgets/glass_panel.dart';
import '../widgets/status_views.dart';
import 'gang_builder_screen.dart';
import 'gang_viewer_screen.dart';
import 'score_tab.dart';

const _kGangsVisibleStatuses = {
  api.GameStatusEnum.agendaDraw,
};
const _kScrollablePhaseStatuses = {
  api.GameStatusEnum.pending,
  api.GameStatusEnum.gangSelection,
  api.GameStatusEnum.agendaDraw,
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
  final _gangService = GangService();
  bool _loading = true;
  bool _busy = false;
  bool _discardedExpanded = false;
  String? _error;
  Future<List<AvailableGang>>? _availableGangsFuture;
  // Last status we saw, so we can fire the one-off deployment popup exactly on the agenda_draw ->
  // in_progress transition (both players confirmed) rather than every time an already-live game
  // loads. Client-local only — a reload won't replay it, which is fine for an at-the-table prompt.
  api.GameStatusEnum? _lastStatus;

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
    if (!mounted) return;
    final status = _game?.status;
    if (_lastStatus == api.GameStatusEnum.agendaDraw &&
        status == api.GameStatusEnum.inProgress) {
      _showDeploymentDialog();
    }
    _lastStatus = status;
    setState(() {});
  }

  // Deployment is done around the table, not in the app: the moment both players confirm their
  // hand and the game goes live, surface a one-off prompt naming the deployment-roll winner.
  void _showDeploymentDialog() {
    final winnerName = (_me?.wonDeploymentRoll ?? false)
        ? 'You'
        : (_opponent?.wonDeploymentRoll ?? false)
        ? (_opponent?.username ?? 'Opponent')
        : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Deploy your gangs'),
          content: Text(
            winnerName != null
                ? '$winnerName won the deployment roll-off. Agree on deployment zones and '
                      'place your miniatures at the table.'
                : 'Agree on deployment zones and place your miniatures at the table.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Got it'),
            ),
          ],
        ),
      );
    });
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
      return Center(
        child: CircularProgressIndicator(color: context.accentColor),
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
        // in_progress/completed are intercepted above; anything else is a transient state with
        // nothing to show yet.
        _ => const SizedBox.shrink(),
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
              color: context.accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.accentColor),
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
                Icon(Icons.copy, color: context.accentColor, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        CircularProgressIndicator(color: context.accentColor),
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
          CircularProgressIndicator(color: context.accentColor),
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
        CircularProgressIndicator(color: context.accentColor),
      ],
    );
  }

  // ── Gang selection ───────────────────────────────────────────────────────

  Widget _buildGangSelectionPhase(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
  ) {
    _availableGangsFuture ??= _service.availableGangs(game.id);
    return _PhaseCard(
      title: 'Pick your gang',
      subtitle: 'Ducat limit: ${game.ducatLimit}',
      children: [
        FutureBuilder<List<AvailableGang>>(
          future: _availableGangsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Padding(
                padding: const EdgeInsets.all(24),
                child: CircularProgressIndicator(color: context.accentColor),
              );
            final gangs = snapshot.data!;
            if (gangs.isEmpty) {
              return Text(
                'You have no gangs yet — build one now.',
                style: TextStyle(color: context.subtleTextColor),
              );
            }
            return Column(
              children: [
                for (final g in gangs) ...[
                  _gangOptionTile(context, game, me, g),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
        // Building a new gang is only offered while this player has none selected. Once a gang is
        // locked in, the picker stays live for switching/deselecting, but a fresh build would sit
        // unselected beside the current pick — deselect first to build a different one.
        if (me.list == null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _busy ? null : () => _createGangInline(game),
              icon: const Icon(Icons.add, size: 18),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.accentColor,
                side: BorderSide(color: context.accentColor),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              label: Text(
                'Build a new gang',
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
        // Once this player has locked in a gang, keep the picker live (they can still switch or
        // deselect) but surface that we're now waiting on the opponent below it.
        if (me.list != null) ...[
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Waiting for the opponent to pick a gang...',
                  style: TextStyle(color: context.subtleTextColor),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// One selectable gang row in the picker. The player's currently-selected gang (matched via the
  /// snapshot's source list id) shows a Deselect button; the rest show Select, or "Over limit" when
  /// the gang exceeds the ducat cap. Re-selecting or deselecting is allowed until both players lock in.
  Widget _gangOptionTile(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
    AvailableGang g,
  ) {
    final isSelected = me.list?.sourceListId == g.gang.id;
    final Widget trailing;
    if (isSelected) {
      trailing = OutlinedButton.icon(
        onPressed: _busy ? null : () => _run(() => _service.deselectGang(game.id)),
        icon: const Icon(Icons.check, size: 16),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.accentColor,
          side: BorderSide(color: context.accentColor),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        label: Text(
          'Deselect',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      );
    } else if (g.selectable) {
      trailing = ElevatedButton(
        onPressed: _busy
            ? null
            : () => _run(() => _service.selectGang(game.id, g.gang.id)),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Select',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      );
    } else {
      trailing = Text(
        'Over limit',
        style: TextStyle(
          fontSize: 11,
          color: context.dangerColor,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return GangTile(
      name: g.gang.name,
      faction: g.gang.faction,
      totalCost: g.gang.totalCost,
      points: g.gang.points,
      dimmed: !g.selectable && !isSelected,
      onTap: _busy ? null : () => _editGangInline(g.gang.id, game),
      trailing: trailing,
    );
  }

  /// Opens the same gang builder used on the Gangs tab, seeded with this game's
  /// ducat limit, then refreshes the pickable-gang list so the freshly built
  /// gang appears without leaving the setup flow.
  Future<void> _createGangInline(api.Game game) async {
    final gang = await showModalBottomSheet<api.ModelList>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateGangSheet(
        initialPoints: game.ducatLimit,
        onCreate: (name, faction, points) =>
            _gangService.create(name, faction, points),
      ),
    );
    if (gang == null || !mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GangBuilderScreen(gang: gang)),
    );
    if (!mounted) return;
    setState(() => _availableGangsFuture = _service.availableGangs(game.id));
  }

  /// Opens an existing gang in the same builder used on the Gangs tab. The tile
  /// only carries a [api.GangSummary], so fetch the full list first, then refresh
  /// the pickable-gang list on return (its cost/limit may have changed).
  Future<void> _editGangInline(int listId, api.Game game) async {
    if (_busy) return;
    setState(() => _busy = true);
    api.ModelList gang;
    try {
      gang = await _gangService.loadOne(listId);
    } catch (_) {
      if (mounted) showAppToast(context, 'Could not open that gang.');
      return;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GangBuilderScreen(gang: gang)),
    );
    if (!mounted) return;
    setState(() => _availableGangsFuture = _service.availableGangs(game.id));
  }

  // ── Agenda draw ──────────────────────────────────────────────────────────

  Widget _buildAgendaDrawPhase(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
  ) {
    final secret = game.scenario.agendaRules.contains(
      api.ScenarioAgendaRulesEnum.secret,
    );
    // The opening hand is dealt server-side the instant the game enters agenda_draw, arriving in
    // the same state broadcast that flips the status — so agendas are normally already present.
    // This empty state only shows in the brief window before that broadcast lands.
    if (me.agendas.isEmpty) {
      return _PhaseCard(
        title: 'Dealing your Agendas',
        subtitle: secret
            ? 'Kept secret from your opponent until achieved (Secret scenario).'
            : 'Your opponent can see these — this scenario is not Secret.',
        children: [
          Center(child: CircularProgressIndicator(color: context.accentColor)),
        ],
      );
    }
    // Agendas mulliganed away stay on screen (crossed out, title only) so both players keep a
    // record of what was agreed unachievable.
    final discarded = me.agendaHistory
        .where((e) => e.action == api.AgendaHistoryEntryActionEnum.discarded)
        .toList();
    return _PhaseCard(
      title: 'Your Agendas',
      subtitle:
          'Any agenda that is impossible or duplicated can be discarded and redrawn — agree with your opponent that it is unachievable.',
      children: [
        ...me.agendas.asMap().entries.map(
          (e) => _agendaDrawCard(context, game, me, e.value, e.key + 1),
        ),
        if (discarded.isNotEmpty) _discardedSection(context, discarded),
        const SizedBox(height: 8),
        // The hand is dealt automatically; the player reads (and optionally mulligans) it, then
        // confirms. Once both players confirm, the game goes straight live.
        if (!me.agendasConfirmed)
          Align(
            alignment: Alignment.centerRight,
            child: _ActionButton(
              label: "Ready",
              onTap: () => _run(() => _service.confirmAgendas(game.id)),
              busy: _busy,
            ),
          )
        else ...[
          Text(
            'Waiting for the opponent to be ready...',
            style: TextStyle(color: context.subtleTextColor),
          ),
          const SizedBox(height: 16),
          CircularProgressIndicator(color: context.accentColor),
        ],
      ],
    );
  }

  // One agenda in the initial-draw list, rendered as a small card: title, description, and (until
  // the hand is confirmed) the "unachievable — redraw" mulligan affordance.
  Widget _agendaDrawCard(
    BuildContext context,
    api.Game game,
    api.GamePlayer me,
    api.Agenda a,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.cardBgColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.accentColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index - ${a.name}',
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w700,
              color: context.accentColor,
            ),
          ),
          Divider(height: 16, thickness: 1, color: context.secondaryAccentColor),
          Text(
            a.description,
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          if (!me.agendasConfirmed) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _busy ? null : () => _mulligan(game.id, a),
                icon: const Icon(Icons.autorenew, size: 16),
                label: const Text('Unachievable — redraw'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.secondaryAccentColor,
                  side: BorderSide(color: context.secondaryAccentColor),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Collapsible "Discarded (N)" section holding the mulliganed agendas. Collapsed by default so it
  // doesn't crowd the active hand; tapping the header toggles it.
  Widget _discardedSection(
    BuildContext context,
    List<api.AgendaHistoryEntry> discarded,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () =>
              setState(() => _discardedExpanded = !_discardedExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: _discardedExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: context.subtleTextColor,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Discarded (${discarded.length})',
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    color: context.subtleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.topCenter,
          child: _discardedExpanded
              ? Column(
                  children: [
                    const SizedBox(height: 8),
                    ...discarded.map(
                      (e) => _discardedAgendaTile(context, e.agenda.name),
                    ),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  // A mulliganed agenda: a compact tile showing only the struck-through title, kept on screen as
  // a record that it was agreed unachievable.
  Widget _discardedAgendaTile(BuildContext context, String name) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.panelBorderColor),
      ),
      child: Text(
        name,
        style: GoogleFonts.cinzel(
          fontWeight: FontWeight.w700,
          color: context.subtleTextColor,
          decoration: TextDecoration.lineThrough,
          decorationColor: context.subtleTextColor,
        ),
      ),
    );
  }

  // Pre-game mulligan: confirm, then discard the impossible/duplicated agenda and redraw a
  // replacement. Visible to the opponent so they can agree it was unachievable.
  Future<void> _mulligan(int gameId, api.Agenda agenda) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard & redraw?'),
        content: Text(
          'Discard "${agenda.name}" as unachievable and draw a replacement? '
          'Your opponent will see this.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard & redraw'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(() => _service.discardUnachievable(gameId, agenda.id));
    }
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
      return Center(
        child: CircularProgressIndicator(color: context.accentColor),
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
      leadingTabs: [
        (
          label: 'Score',
          view: ScoreTab(
            key: const ValueKey('score-tab'),
            game: game,
            me: me,
            opponent: opponent,
            busy: _busy,
            onAdvanceTurn: () => _run(() => _service.advanceTurn(game.id)),
            onRewindTurn: () => _run(() => _service.rewindTurn(game.id)),
            onFinish: () => _run(() => _service.finishGame(game.id)),
            onUnfinish: () => _run(() => _service.unfinishGame(game.id)),
            onDraw: (origin) =>
                _run(() => _service.drawAgendas(game.id, origin: origin)),
            onScore: (agendaId) =>
                _run(() => _service.scoreAgenda(game.id, agendaId)),
            onDiscard: (agendaId, origin) => _run(
              () => _service.discardAgenda(game.id, agendaId, origin: origin),
            ),
          ),
        ),
      ],
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
        backgroundColor: context.accentColor,
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
