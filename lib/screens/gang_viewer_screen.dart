import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/equipment.dart';
import '../models/gang.dart';
import '../models/profile.dart';
import '../services/equipment_service.dart';
import '../services/game_service.dart';
import '../services/profile_service.dart';
import '../widgets/app_toast.dart';
import '../widgets/spell_chips.dart';
import '../widgets/themed_dialog_card.dart';
import 'card_viewer_screen.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/bg_dark.png'
                    : 'assets/images/bg_light.png',
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
            icon: Icon(Icons.arrow_back, color: context.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Gangs',
              style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w700, color: context.textColor, letterSpacing: 2),
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
  });

  final int gameId;
  final int myPlayerId;
  final String myLabel;
  final int opponentPlayerId;
  final String opponentLabel;

  /// Whether each tab shows the gang's name/faction header and ducats bar. Hidden once a game is
  /// in progress, where the list is fixed and that summary is just noise above the models.
  final bool showListHeader;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildTabBar(context),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                // Players only ever edit their own models' counters; the opponent's tab stays
                // read-only (their changes still stream in live via game_state broadcasts).
                _GangTab(gameId: gameId, playerId: myPlayerId, editable: true, showListHeader: showListHeader),
                _GangTab(gameId: gameId, playerId: opponentPlayerId, editable: false, showListHeader: showListHeader),
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
        labelColor: AppPalette.gold,
        unselectedLabelColor: context.subtleTextColor,
        indicatorColor: AppPalette.gold,
        labelStyle: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1),
        tabs: [
          Tab(text: myLabel),
          Tab(text: opponentLabel),
        ],
      ),
    );
  }
}

class _GangTabData {
  const _GangTabData({required this.gang, required this.profiles, required this.equipment});
  final Gang gang;
  final List<Profile> profiles;
  final List<Equipment> equipment;
}

class _GangTab extends StatefulWidget {
  const _GangTab({required this.gameId, required this.playerId, required this.editable, this.showListHeader = true});

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
    _gameService.removeListener(_onGameUpdate);
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final gang = await _gameService.playerList(widget.gameId, widget.playerId);
      // The catalog halves never change mid-game — only re-fetch the gang on refresh.
      var profiles = _data?.profiles;
      var equipment = _data?.equipment;
      if (profiles == null || equipment == null) {
        final results = await Future.wait([
          ProfileService().search('', factions: {gang.faction, 'gifted'}),
          EquipmentService().getAll(),
        ]);
        profiles = results[0] as List<Profile>;
        equipment = results[1] as List<Equipment>;
      }
      if (!mounted) return;
      setState(() {
        _data = _GangTabData(gang: gang, profiles: profiles!, equipment: equipment!);
        _failed = false;
      });
    } catch (e) {
      // On a failed refresh keep showing the last good snapshot instead of an error.
      if (mounted && _data == null) setState(() => _failed = true);
    }
  }

  // game_state broadcasts don't carry entry states (those live in the player-list payload),
  // so any broadcast — e.g. the opponent toggling a counter — triggers a silent re-fetch.
  void _onGameUpdate() => _load();

  // Applies a PATCH response locally right away rather than waiting for the echo broadcast's
  // re-fetch, so the tapped counter never lags behind the dialog.
  void _applyEntryState(int listEntryId, EntryState state) {
    final data = _data;
    if (data == null) return;
    final gang = data.gang;
    setState(() {
      _data = _GangTabData(
        gang: Gang(
          id: gang.id,
          name: gang.name,
          faction: gang.faction,
          points: gang.points,
          totalCost: gang.totalCost,
          selectionValid: gang.selectionValid,
          selectionErrors: gang.selectionErrors,
          entries: gang.entries
              .map((e) => e.id == listEntryId ? e.copyWith(state: state) : e)
              .toList(),
        ),
        profiles: data.profiles,
        equipment: data.equipment,
      );
    });
  }

  void _editCounters(ListEntry entry) {
    showDialog(
      context: context,
      builder: (_) => _CounterEditDialog(
        gameId: widget.gameId,
        entry: entry,
        onStateChanged: _applyEntryState,
      ),
    );
  }

  void _editStats(ListEntry entry) {
    showDialog(
      context: context,
      builder: (_) => _StatEditDialog(
        gameId: widget.gameId,
        entry: entry,
        onStateChanged: _applyEntryState,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_failed) {
      return Center(
        child: Text('Could not load this gang.', style: TextStyle(color: context.subtleTextColor)),
      );
    }
    final data = _data;
    if (data == null) {
      return const Center(child: CircularProgressIndicator(color: AppPalette.gold));
    }
    return _ReadOnlyGangBody(
      gang: data.gang,
      profiles: data.profiles,
      equipment: data.equipment,
      showHeader: widget.showListHeader,
      onEditCounters: widget.editable ? _editCounters : null,
      onEditStats: widget.editable ? _editStats : null,
    );
  }
}

class _ReadOnlyGangBody extends StatelessWidget {
  const _ReadOnlyGangBody({
    required this.gang,
    required this.profiles,
    required this.equipment,
    this.showHeader = true,
    this.onEditCounters,
    this.onEditStats,
  });

  final Gang gang;
  final List<Profile> profiles;
  final List<Equipment> equipment;

  /// Whether to show the gang name/faction header and ducats bar above the models.
  final bool showHeader;

  /// When set, model tiles with an entry state get a + button that opens the counter popup.
  final void Function(ListEntry entry)? onEditCounters;

  /// When set, tapping a model's HP/WP/CP pill opens the stat stepper popup.
  final void Function(ListEntry entry)? onEditStats;

  @override
  Widget build(BuildContext context) {
    final factionColor = AppPalette.factionColors[gang.faction] ?? AppPalette.gold;
    return Column(
      children: [
        if (showHeader) ...[
          _buildGangHeader(context, factionColor),
          _buildPointsBar(context, factionColor),
          const SizedBox(height: 12),
        ],
        Expanded(child: _buildEntries(context, factionColor)),
      ],
    );
  }

  Widget _buildGangHeader(BuildContext context, Color factionColor) {
    final iconPath = AppPalette.factionIcons[gang.faction];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              gang.name,
              style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w700, color: context.textColor, letterSpacing: 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: factionColor, shape: BoxShape.circle),
            padding: const EdgeInsets.all(6),
            child: iconPath != null
                ? Image.asset(iconPath, fit: BoxFit.contain, color: Colors.white, colorBlendMode: BlendMode.srcIn)
                : const Icon(Icons.flag, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBar(BuildContext context, Color factionColor) {
    final used = gang.totalCost;
    final limit = gang.points;
    final ratio = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: context.panelGradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.panelBorderColor,
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$used', style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w700, color: context.textColor)),
                    Text(' / $limit ducats', style: GoogleFonts.cinzel(fontSize: 13, color: context.subtleTextColor)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: Colors.black.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation(factionColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntries(BuildContext context, Color factionColor) {
    final entries = gang.entries;
    if (entries.isEmpty) {
      return Center(
        child: Text('No models hired.', style: GoogleFonts.cinzel(fontSize: 14, color: context.subtleTextColor)),
      );
    }
    final hiredProfiles = entries
        .where((e) => e.entryType == 'CardReference')
        .map((e) => profiles.where((p) => p.cardReferenceIds.contains(e.entryId)).firstOrNull)
        .whereType<Profile>()
        .toList();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final entry = entries[i];
        final profile = entry.entryType == 'CardReference'
            ? profiles.where((p) => p.cardReferenceIds.contains(entry.entryId)).firstOrNull
            : null;
        final equipmentItem = entry.entryType == 'Equipment'
            ? equipment.where((e) => e.id == entry.entryId).firstOrNull
            : null;
        final entryColor = entry.entryType == 'Equipment'
            ? AppPalette.equipment
            : profile?.faction == 'gifted'
                ? (AppPalette.factionColors['gifted'] ?? factionColor)
                : factionColor;
        VoidCallback? onTap;
        if (profile != null) {
          final hiredIndex = hiredProfiles.indexWhere((p) => p.cardReferenceId == profile.cardReferenceId);
          onTap = () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CardViewerScreen(profiles: hiredProfiles, initialIndex: hiredIndex),
                ),
              );
        } else if (equipmentItem != null) {
          onTap = () => _showEquipmentDetail(context, equipmentItem);
        }
        return _ReadOnlyEntryTile(
          entry: entry,
          color: entryColor,
          onTap: onTap,
          onEditCounters: onEditCounters != null && entry.state != null ? () => onEditCounters!(entry) : null,
          onEditStats: onEditStats != null && entry.state != null ? () => onEditStats!(entry) : null,
        );
      },
    );
  }

  void _showEquipmentDetail(BuildContext context, Equipment e) {
    showDialog(
      context: context,
      builder: (context) => ThemedDialogCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    e.name,
                    style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: context.textColor),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${e.cost}',
                  style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: AppPalette.gold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: context.subtleTextColor.withOpacity(0.3), thickness: 0.5),
            const SizedBox(height: 12),
            Text(
              e.description,
              style: TextStyle(fontSize: 13, color: context.textColor, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyEntryTile extends StatelessWidget {
  const _ReadOnlyEntryTile({required this.entry, required this.color, this.onTap, this.onEditCounters, this.onEditStats});

  final ListEntry entry;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onEditCounters;
  final VoidCallback? onEditStats;

  @override
  Widget build(BuildContext context) {
    final state = entry.state;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, Color.lerp(color, Colors.black, 0.45)!],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.name,
                      style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.cost}',
                    style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              if (state != null) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _StatPill(label: 'HP', value: state.lifePoints, borderColors: AppPalette.hpBorder, onTap: onEditStats),
                          // Hidden (not omitted) when the model was never given this stat at
                          // all (starting 0) — keeps the pill in the tree/layout, just invisible,
                          // rather than skipping it and shifting everything after it over. An
                          // invisible pill isn't tappable (onTap null).
                          Opacity(
                            opacity: state.willPoints.starting == 0 ? 0 : 1,
                            child: _StatPill(
                              label: 'WP',
                              value: state.willPoints,
                              borderColors: AppPalette.wpBorder,
                              onTap: state.willPoints.starting == 0 ? null : onEditStats,
                            ),
                          ),
                          Opacity(
                            opacity: state.commandPoints.starting == 0 ? 0 : 1,
                            child: _StatPill(
                              label: 'CP',
                              value: state.commandPoints,
                              borderColors: AppPalette.cpBorder,
                              onTap: state.commandPoints.starting == 0 ? null : onEditStats,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        ..._counterIcons(state),
                        if (onEditCounters != null) _AddCounterButton(onTap: onEditCounters!),
                      ],
                    ),
                  ],
                ),
              ],
              if (_spellChips.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(spacing: 6, runSpacing: 6, children: _spellChips),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Known spells for a Mage model (Cantrip first), tappable for details. Empty for everything else.
  List<Widget> get _spellChips => entry.mage ? spellChipsFor(entry) : const [];

  // Only the active counters appear — a counter set to false (or 0 underwater) is omitted
  // entirely, so a clean model shows no counter icons at all. Editing happens through the +
  // button next to them (own models only), not by tapping the icons themselves.
  List<Widget> _counterIcons(EntryState state) {
    return [
      if (state.stunned)
        _CounterIcon(asset: 'assets/images/counters/stunned.png', label: 'Stunned', active: true),
      if (state.hidden)
        _CounterIcon(asset: 'assets/images/counters/hidden.png', label: 'Hidden', active: true),
      if (state.guarding)
        _CounterIcon(asset: 'assets/images/counters/guard.png', label: 'Guarding', active: true),
      if (state.carryingObjective)
        _CounterIcon(asset: 'assets/images/counters/carry_objective.png', label: 'Carrying objective', active: true),
      if (state.underwaterCounters > 0)
        _CounterIcon(
          asset: 'assets/images/counters/underwater_counter.png',
          label: 'Underwater',
          active: true,
          badge: state.underwaterCounters,
        ),
    ];
  }
}

/// Compact "HP 6/10"-style pill: current value first, starting value after the slash — matches
/// the "A/B" shorthand used at the table (A = remaining, B = starting).
class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value, required this.borderColors, this.onTap});

  final String label;
  final EntryStatValue value;
  final List<Color> borderColors;

  /// When set (own models only, and only for stats the model actually has), tapping the pill
  /// opens the stat stepper popup.
  final VoidCallback? onTap;

  static const _radius = 8.0;
  static const _strokeWidth = 1.4;
  // Fixed rather than shrink-to-fit, so HP (often 2 digits) and WP/CP (often 1 digit) read as
  // the same size instead of HP looking like a bigger/more important stat than the others.
  static const _width = 66.0;

  // BoxDecoration.border can't paint a gradient, so the stroke is drawn directly with a
  // CustomPaint foreground painter instead of Border.all — one widget, one shape, no need to
  // keep an inner/outer corner radius pair in sync (the nested-container approach used earlier).
  @override
  Widget build(BuildContext context) {
    final pill = CustomPaint(
      foregroundPainter: _GradientBorderPainter(colors: borderColors, radius: _radius, strokeWidth: _strokeWidth),
      child: Container(
        width: _width,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Text(
          '$label ${value.current}/${value.starting}',
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
    if (onTap == null) return pill;
    // A GestureDetector here (a descendant of the whole tile's GestureDetector) wins the tap on
    // the pill, so editing a stat doesn't also trigger the tile's tap-to-view-card.
    return GestureDetector(onTap: onTap, child: pill);
  }
}

class _GradientBorderPainter extends CustomPainter {
  _GradientBorderPainter({required this.colors, required this.radius, required this.strokeWidth});

  final List<Color> colors;
  final double radius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius - strokeWidth / 2));
    final paint = Paint()
      ..shader = LinearGradient(colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.radius != radius || oldDelegate.strokeWidth != strokeWidth;
}

/// The small + next to a model's counter icons (own models only): opens the popup for toggling
/// counters. Sized to read as an affordance on the counter row rather than a sixth counter.
class _AddCounterButton extends StatelessWidget {
  const _AddCounterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Edit counters',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.2),
          ),
          child: const Icon(Icons.add, size: 22, color: Colors.white),
        ),
      ),
    );
  }
}

/// Popup opened by [_AddCounterButton]: lists all five counters with their current state;
/// tapping a row toggles it (underwater cycles 0 → 1 → 2 → 0) and saves immediately — no
/// confirm step, matching how quickly counters flip at the table. Every change lands on the
/// server before the row updates, so the popup never shows a state the opponent won't get.
class _CounterEditDialog extends StatefulWidget {
  const _CounterEditDialog({required this.gameId, required this.entry, required this.onStateChanged});

  final int gameId;
  final ListEntry entry;
  final void Function(int listEntryId, EntryState state) onStateChanged;

  @override
  State<_CounterEditDialog> createState() => _CounterEditDialogState();
}

class _CounterEditDialogState extends State<_CounterEditDialog> {
  late EntryState _state = widget.entry.state!;
  bool _busy = false;

  Future<void> _update({
    bool? stunned,
    bool? hidden,
    bool? guarding,
    bool? carryingObjective,
    int? underwaterCounters,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final newState = await GameService().updateCounters(
        widget.gameId,
        widget.entry.id,
        stunned: stunned,
        hidden: hidden,
        guarding: guarding,
        carryingObjective: carryingObjective,
        underwaterCounters: underwaterCounters,
      );
      if (!mounted) return;
      setState(() => _state = newState);
      widget.onStateChanged(widget.entry.id, newState);
    } catch (_) {
      if (mounted) showAppToast(context, 'Could not update the counter. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedDialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.entry.name,
            style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: context.textColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a counter to toggle it.',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 12),
          Divider(color: context.subtleTextColor.withOpacity(0.3), thickness: 0.5),
          const SizedBox(height: 4),
          _counterRow(
            context,
            asset: 'assets/images/counters/stunned.png',
            label: 'Stunned',
            active: _state.stunned,
            onTap: () => _update(stunned: !_state.stunned),
          ),
          _counterRow(
            context,
            asset: 'assets/images/counters/hidden.png',
            label: 'Hidden',
            active: _state.hidden,
            onTap: () => _update(hidden: !_state.hidden),
          ),
          _counterRow(
            context,
            asset: 'assets/images/counters/guard.png',
            label: 'Guarding',
            active: _state.guarding,
            onTap: () => _update(guarding: !_state.guarding),
          ),
          _counterRow(
            context,
            asset: 'assets/images/counters/carry_objective.png',
            label: 'Carrying objective',
            active: _state.carryingObjective,
            onTap: () => _update(carryingObjective: !_state.carryingObjective),
          ),
          _counterRow(
            context,
            asset: 'assets/images/counters/underwater_counter.png',
            label: 'Underwater',
            active: _state.underwaterCounters > 0,
            badge: _state.underwaterCounters > 0 ? _state.underwaterCounters : null,
            trailing: Text(
              '${_state.underwaterCounters} / 2',
              style: GoogleFonts.cinzel(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _state.underwaterCounters > 0 ? AppPalette.gold : context.subtleTextColor,
              ),
            ),
            onTap: () => _update(underwaterCounters: (_state.underwaterCounters + 1) % 3),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Done', style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, color: AppPalette.gold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _counterRow(
    BuildContext context, {
    required String asset,
    required String label,
    required bool active,
    int? badge,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _busy ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            _CounterIcon(asset: asset, label: label, active: active, badge: badge, foreground: context.textColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.w600, color: context.textColor),
              ),
            ),
            trailing ??
                Icon(
                  active ? Icons.check_circle : Icons.circle_outlined,
                  size: 20,
                  color: active ? AppPalette.gold : context.subtleTextColor,
                ),
          ],
        ),
      ),
    );
  }
}

/// Popup opened by tapping an HP/WP/CP pill: a −/+ stepper per stat the model has (WP and CP are
/// omitted for models that never had them, i.e. starting 0). Each tap saves the new absolute
/// value to the server immediately and can't push a stat below 0; the change echoes to both
/// players. Only the model's own player can open it (the opponent's pills aren't tappable).
class _StatEditDialog extends StatefulWidget {
  const _StatEditDialog({required this.gameId, required this.entry, required this.onStateChanged});

  final int gameId;
  final ListEntry entry;
  final void Function(int listEntryId, EntryState state) onStateChanged;

  @override
  State<_StatEditDialog> createState() => _StatEditDialogState();
}

class _StatEditDialogState extends State<_StatEditDialog> {
  late EntryState _state = widget.entry.state!;
  bool _busy = false;

  Future<void> _update({int? lifePoints, int? willPoints, int? commandPoints}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final newState = await GameService().updateStats(
        widget.gameId,
        widget.entry.id,
        lifePoints: lifePoints,
        willPoints: willPoints,
        commandPoints: commandPoints,
      );
      if (!mounted) return;
      setState(() => _state = newState);
      widget.onStateChanged(widget.entry.id, newState);
    } catch (_) {
      if (mounted) showAppToast(context, 'Could not update the stat. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedDialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.entry.name,
            style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: context.textColor),
          ),
          const SizedBox(height: 12),
          Divider(color: context.subtleTextColor.withOpacity(0.3), thickness: 0.5),
          const SizedBox(height: 4),
          _statStepperRow(
            context,
            label: 'Life Points',
            value: _state.lifePoints,
            onChanged: (v) => _update(lifePoints: v),
          ),
          if (_state.willPoints.starting > 0)
            _statStepperRow(
              context,
              label: 'Will Points',
              value: _state.willPoints,
              onChanged: (v) => _update(willPoints: v),
            ),
          if (_state.commandPoints.starting > 0)
            _statStepperRow(
              context,
              label: 'Command Points',
              value: _state.commandPoints,
              onChanged: (v) => _update(commandPoints: v),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Done', style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, color: AppPalette.gold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statStepperRow(
    BuildContext context, {
    required String label,
    required EntryStatValue value,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.w600, color: context.textColor),
            ),
          ),
          _stepperButton(
            context,
            icon: Icons.remove,
            // Can't drop below 0 (the server rejects it too); disabled at the floor.
            onTap: _busy || value.current <= 0 ? null : () => onChanged(value.current - 1),
          ),
          Container(
            width: 56,
            alignment: Alignment.center,
            child: Text(
              '${value.current} / ${value.starting}',
              style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w700, color: context.textColor),
            ),
          ),
          _stepperButton(
            context,
            icon: Icons.add,
            onTap: _busy ? null : () => onChanged(value.current + 1),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton(BuildContext context, {required IconData icon, required VoidCallback? onTap}) {
    final enabled = onTap != null;
    final color = enabled ? context.textColor : context.subtleTextColor.withOpacity(0.4);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? color.withOpacity(0.5) : color, width: 1.2),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

/// A single status counter icon (stunned/hidden/guarding/carrying objective/underwater), always
/// rendered so tile layouts stay consistent — full opacity with a gold ring when the counter is
/// active, dimmed with no ring when it isn't. Underwater additionally carries a count badge (it
/// stacks up to 2, unlike the other four, which are simple on/off flags).
class _CounterIcon extends StatelessWidget {
  const _CounterIcon({required this.asset, required this.label, required this.active, this.badge, this.foreground = Colors.white});

  final String asset;
  final String label;
  final bool active;
  final int? badge;

  /// Tint for the icon glyph. Defaults to white, which reads on the tile's dark faction-colored
  /// gradient; the edit popup passes the theme's text color so it reads on a light surface too.
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: active ? AppPalette.gold.withOpacity(0.35) : Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
          border: active ? Border.all(color: AppPalette.gold, width: 1.4) : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: active ? 1.0 : 0.35,
              child: Image.asset(asset, width: 26, height: 26, color: foreground, colorBlendMode: BlendMode.srcIn),
            ),
            if (badge != null)
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(color: AppPalette.gold, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '$badge',
                    style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
