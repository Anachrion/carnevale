import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;

import '../app_colors.dart';
import '../widgets/glass_panel.dart';

/// The in-progress game's Score tab: the scenario and its agenda rules, the turn counter, the
/// running score, and each player's agendas (hand / scored / discarded) with the draw, score,
/// discard, and advance-turn actions. Stateless — the host screen rebuilds it with a fresh
/// snapshot on every live update, and routes every action back through its callbacks.
class ScoreTab extends StatelessWidget {
  const ScoreTab({
    super.key,
    required this.game,
    required this.me,
    required this.opponent,
    required this.busy,
    required this.onAdvanceTurn,
    required this.onRewindTurn,
    required this.onFinish,
    required this.onUnfinish,
    required this.onDraw,
    required this.onScore,
    required this.onDiscard,
  });

  final api.Game game;
  final api.GamePlayer me;
  final api.GamePlayer opponent;
  final bool busy;

  final VoidCallback onAdvanceTurn;
  final VoidCallback onRewindTurn;
  final VoidCallback onFinish;
  final VoidCallback onUnfinish;
  final void Function(String origin) onDraw;
  final void Function(int agendaId) onScore;
  final void Function(int agendaId, String origin) onDiscard;

  bool get _inProgress => game.status == api.GameStatusEnum.inProgress;
  // A finished player is soft-locked out of scoring/turn moves until they undo.
  bool get _canAct => _inProgress && !me.finished;
  bool get _onLastTurn => me.currentTurn >= game.scenario.turns;
  bool get _secret =>
      game.scenario.agendaRules.contains(api.ScenarioAgendaRulesEnum.secret);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _scenarioPanel(context),
          const SizedBox(height: 12),
          _scorePanel(context),
          const SizedBox(height: 12),
          _myAgendasPanel(context),
          const SizedBox(height: 12),
          _opponentAgendasPanel(context),
        ],
      ),
    );
  }

  // ── Scenario + agenda rules ────────────────────────────────────────────────

  Widget _scenarioPanel(BuildContext context) {
    final rules = game.scenario.agendaRules;
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            game.scenario.name,
            style: GoogleFonts.cinzel(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            game.scenario.primaryObjective,
            style: TextStyle(fontSize: 13, color: context.subtleTextColor),
          ),
          if (rules.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: rules.map((r) => _AgendaRuleChip(rule: r)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ── Turn + score ───────────────────────────────────────────────────────────

  Widget _scorePanel(BuildContext context) {
    return GlassPanel(
      child: Column(
        children: [
          // Per-player turn stepper: this only moves your own cursor, never the opponent's.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (_canAct && me.currentTurn > 1 && !busy)
                    ? onRewindTurn
                    : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Rewind a turn',
                color: AppPalette.gold,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Turn ${me.currentTurn} of ${game.scenario.turns}',
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: (_canAct && !_onLastTurn && !busy)
                    ? onAdvanceTurn
                    : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Advance a turn',
                color: AppPalette.gold,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _scoreColumn(context, me.username, me.score, isMe: true),
              Container(
                width: 1,
                height: 40,
                color: context.subtleTextColor.withValues(alpha: 0.3),
              ),
              _scoreColumn(context, opponent.username, opponent.score,
                  isMe: false),
            ],
          ),
          _finishArea(context),
        ],
      ),
    );
  }

  // End-game controls, per player. The button only appears on the last turn; a finished player
  // sees an Undo that reopens the game (and un-archives it) so they can keep scoring.
  Widget _finishArea(BuildContext context) {
    if (me.finished) {
      return Column(
        children: [
          const SizedBox(height: 12),
          Text(
            "You've ended the game.",
            style: TextStyle(
              color: context.subtleTextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: busy ? null : onUnfinish,
            icon: const Icon(Icons.undo, size: 18),
            label: const Text('Undo — keep scoring'),
            style: OutlinedButton.styleFrom(foregroundColor: AppPalette.gold),
          ),
        ],
      );
    }
    if (_inProgress && _onLastTurn) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ElevatedButton.icon(
          onPressed: busy ? null : onFinish,
          icon: const Icon(Icons.flag, size: 18),
          label: const Text('End game'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _scoreColumn(BuildContext context, String name, int score,
      {required bool isMe}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            isMe ? 'You' : name,
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: GoogleFonts.cinzel(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: isMe ? AppPalette.gold : context.textColor,
            ),
          ),
          Text(
            score == 1 ? 'VP' : 'VP',
            style: TextStyle(fontSize: 11, color: context.subtleTextColor),
          ),
        ],
      ),
    );
  }

  // ── My agendas ──────────────────────────────────────────────────────────────

  Widget _myAgendasPanel(BuildContext context) {
    final scored = _historyNames(me.agendaHistory,
        api.AgendaHistoryEntryActionEnum.scored);
    final discarded = _historyEntries(me.agendaHistory,
        api.AgendaHistoryEntryActionEnum.discarded);

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Agendas',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _logButton(context, me, isMe: true),
                  if (_canAct)
                    TextButton.icon(
                      onPressed: busy ? null : () => _draw(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Draw'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppPalette.gold,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (me.agendas.isEmpty)
            _emptyNote(context, 'No agendas in hand.')
          else
            ...me.agendas.asMap().entries.map(
                  (e) => _handTile(context, e.value, e.key + 1),
                ),
          if (scored.isNotEmpty) ...[
            const SizedBox(height: 12),
            _sectionLabel(context, 'Scored'),
            ...scored.map((n) => _resolvedRow(context, n, Icons.check_circle,
                AppPalette.gold)),
          ],
          if (discarded.isNotEmpty) ...[
            const SizedBox(height: 12),
            _sectionLabel(context, 'Discarded'),
            ...discarded.map((e) => _resolvedRow(
                  context,
                  e.agenda.name,
                  Icons.cancel,
                  context.subtleTextColor,
                  tag: _originLabel(e.origin),
                )),
          ],
        ],
      ),
    );
  }

  Widget _handTile(BuildContext context, api.Agenda a, int index) {
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
          if (_canAct) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                _smallButton(
                  label: 'Score',
                  color: AppPalette.gold,
                  onTap: busy ? null : () => onScore(a.id),
                ),
                const SizedBox(width: 8),
                _smallButton(
                  label: 'Discard',
                  color: context.subtleTextColor,
                  outlined: true,
                  onTap: busy ? null : () => _discard(context, a.id),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Opponent agendas ─────────────────────────────────────────────────────────

  Widget _opponentAgendasPanel(BuildContext context) {
    final scored = _historyNames(opponent.agendaHistory,
        api.AgendaHistoryEntryActionEnum.scored);
    final discarded = _historyEntries(opponent.agendaHistory,
        api.AgendaHistoryEntryActionEnum.discarded);

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "${opponent.username}'s Agendas",
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _logButton(context, opponent, isMe: false),
            ],
          ),
          const SizedBox(height: 8),
          _sectionLabel(context, 'In hand'),
          if (_secret)
            _emptyNote(context, 'Hidden — this scenario has the Secret rule.')
          else if (opponent.agendas.isEmpty)
            _emptyNote(context, 'No agendas in hand.')
          else
            ...opponent.agendas.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    a.name,
                    style: TextStyle(color: context.textColor),
                  ),
                )),
          if (scored.isNotEmpty) ...[
            const SizedBox(height: 12),
            _sectionLabel(context, 'Scored'),
            ...scored.map((n) => _resolvedRow(context, n, Icons.check_circle,
                AppPalette.gold)),
          ],
          if (discarded.isNotEmpty) ...[
            const SizedBox(height: 12),
            _sectionLabel(context, 'Discarded'),
            ...discarded.map((e) => _resolvedRow(
                  context,
                  e.agenda.name,
                  Icons.cancel,
                  context.subtleTextColor,
                  tag: _originLabel(e.origin),
                )),
          ],
        ],
      ),
    );
  }

  // ── Shared bits ────────────────────────────────────────────────────────────

  Widget _sectionLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: context.subtleTextColor,
          ),
        ),
      );

  Widget _emptyNote(BuildContext context, String text) => Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontStyle: FontStyle.italic,
          color: context.subtleTextColor,
        ),
      );

  Widget _resolvedRow(
    BuildContext context,
    String name,
    IconData icon,
    Color iconColor, {
    String? tag,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              name,
              style: TextStyle(color: context.textColor, fontSize: 13),
            ),
          ),
          if (tag != null)
            Text(
              tag,
              style: TextStyle(fontSize: 11, color: context.subtleTextColor),
            ),
        ],
      ),
    );
  }

  Widget _smallButton({
    required String label,
    required Color color,
    required VoidCallback? onTap,
    bool outlined = false,
  }) {
    final child = Text(
      label,
      style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w700),
    );
    return outlined
        ? OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
            child: child,
          );
  }

  // ── Log ────────────────────────────────────────────────────────────────────

  Widget _logButton(BuildContext context, api.GamePlayer player,
      {required bool isMe}) {
    return TextButton.icon(
      onPressed: () => _showLog(context, player, isMe: isMe),
      icon: const Icon(Icons.history, size: 18),
      label: const Text('Log'),
      style: TextButton.styleFrom(foregroundColor: context.subtleTextColor),
    );
  }

  void _showLog(BuildContext context, api.GamePlayer player,
      {required bool isMe}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _AgendaLogSheet(
        player: player,
        isMe: isMe,
        totalTurns: game.scenario.turns,
        secret: _secret,
      ),
    );
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  Future<void> _draw(BuildContext context) async {
    final origin = await _pickOrigin(context, 'Draw an agenda via…');
    if (origin != null) onDraw(origin);
  }

  Future<void> _discard(BuildContext context, int agendaId) async {
    // Unlike a draw, a discard can also be an "unachievable" swap — tossing an impossible agenda
    // for a fresh one (the server always redraws in that case).
    final origin = await _pickOrigin(
      context,
      'Discard this agenda via…',
      includeUnachievable: true,
    );
    if (origin != null) onDiscard(agendaId, origin);
  }

  /// Picks the origin a mid-game agenda draw/discard is attributed to — an agenda is never freely
  /// drawn or discarded. Draws and rule/command-point discards use `special_rule`/`command_point`;
  /// discards additionally offer `unachievable` (an impossible agenda swapped for a fresh one) when
  /// [includeUnachievable] is set.
  Future<String?> _pickOrigin(
    BuildContext context,
    String title, {
    bool includeUnachievable = false,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ctx.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                if (includeUnachievable)
                  ListTile(
                    title: Text('Unachievable',
                        style: TextStyle(color: ctx.textColor)),
                    subtitle: Text('Impossible now — swap for a fresh agenda',
                        style: TextStyle(color: ctx.subtleTextColor)),
                    onTap: () => Navigator.pop(ctx, 'unachievable'),
                  ),
                ListTile(
                  title: Text('Special Rule',
                      style: TextStyle(color: ctx.textColor)),
                  onTap: () => Navigator.pop(ctx, 'special_rule'),
                ),
                ListTile(
                  title: Text('Command Point',
                      style: TextStyle(color: ctx.textColor)),
                  onTap: () => Navigator.pop(ctx, 'command_point'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── History helpers ──────────────────────────────────────────────────────

  Iterable<api.AgendaHistoryEntry> _historyEntries(
    Iterable<api.AgendaHistoryEntry> history,
    api.AgendaHistoryEntryActionEnum action,
  ) =>
      history.where((e) => e.action == action);

  Iterable<String> _historyNames(
    Iterable<api.AgendaHistoryEntry> history,
    api.AgendaHistoryEntryActionEnum action,
  ) =>
      _historyEntries(history, action).map((e) => e.agenda.name);

  String? _originLabel(api.AgendaHistoryEntryOriginEnum? origin) =>
      switch (origin) {
        api.AgendaHistoryEntryOriginEnum.unachievable => 'unachievable',
        api.AgendaHistoryEntryOriginEnum.specialRule => 'special rule',
        api.AgendaHistoryEntryOriginEnum.commandPoint => 'command point',
        _ => null,
      };
}

/// A labelled chip for one agenda special rule, with the rulebook description as a tooltip.
class _AgendaRuleChip extends StatelessWidget {
  const _AgendaRuleChip({required this.rule});

  final api.ScenarioAgendaRulesEnum rule;

  (String, String) _describe(api.ScenarioAgendaRulesEnum rule) =>
      switch (rule) {
        api.ScenarioAgendaRulesEnum.cycle => (
            'Cycle',
            'Scoring an agenda immediately draws a replacement.'
          ),
        api.ScenarioAgendaRulesEnum.secondary => (
            'Secondary',
            'You must achieve at least one agenda to score any Victory Points from any source.'
          ),
        api.ScenarioAgendaRulesEnum.double_ => (
            'Double',
            'On achieving an agenda you may keep it in play; achieving it again scores double, otherwise nothing.'
          ),
        api.ScenarioAgendaRulesEnum.secret => (
            'Secret',
            "Keep your agendas secret from your opponent until achieved. Without this rule, all players can see each other's agendas."
          ),
        api.ScenarioAgendaRulesEnum.total => (
            'Total',
            'You must achieve all of your agendas to score their Victory Points.'
          ),
        _ => (rule.name, ''),
      };

  @override
  Widget build(BuildContext context) {
    final entry = _describe(rule);
    return Tooltip(
      message: entry.$2,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppPalette.gold.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppPalette.gold.withValues(alpha: 0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.$1,
              style: GoogleFonts.cinzel(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.info_outline,
                size: 13, color: context.subtleTextColor),
          ],
        ),
      ),
    );
  }
}

/// A per-player event log: that player's agenda draw/score/discard history grouped by turn.
/// Under the Secret rule an opponent's log only carries resolved events (the backend already
/// trims it), which the header notes.
class _AgendaLogSheet extends StatelessWidget {
  const _AgendaLogSheet({
    required this.player,
    required this.isMe,
    required this.totalTurns,
    required this.secret,
  });

  final api.GamePlayer player;
  final bool isMe;
  final int totalTurns;
  final bool secret;

  @override
  Widget build(BuildContext context) {
    final byTurn = <int, List<api.AgendaHistoryEntry>>{};
    for (final e in player.agendaHistory) {
      byTurn.putIfAbsent(e.turn, () => []).add(e);
    }
    final turns = byTurn.keys.toList()..sort();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMe ? 'Your log' : "${player.username}'s log",
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              if (!isMe && secret) ...[
                const SizedBox(height: 4),
                Text(
                  'Only resolved agendas are shown (Secret scenario).',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: context.subtleTextColor,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (turns.isEmpty)
                Text(
                  'No events yet.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: context.subtleTextColor,
                  ),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: turns
                          .map((t) => _turnBlock(context, t, byTurn[t]!))
                          .toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _turnBlock(
      BuildContext context, int turn, List<api.AgendaHistoryEntry> events) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TURN $turn',
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: AppPalette.gold,
            ),
          ),
          const SizedBox(height: 4),
          ...events.map((e) => _eventRow(context, e)),
        ],
      ),
    );
  }

  Widget _eventRow(BuildContext context, api.AgendaHistoryEntry e) {
    final (IconData icon, Color color, String verb) = switch (e.action) {
      api.AgendaHistoryEntryActionEnum.scored => (
          Icons.check_circle,
          AppPalette.gold,
          'Scored'
        ),
      api.AgendaHistoryEntryActionEnum.discarded => (
          Icons.cancel,
          context.subtleTextColor,
          'Discarded'
        ),
      _ => (Icons.add_circle_outline, context.subtleTextColor, 'Drew'),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: context.textColor),
                children: [
                  TextSpan(
                    text: '$verb ',
                    style: TextStyle(color: context.subtleTextColor),
                  ),
                  TextSpan(text: e.agenda.name),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
