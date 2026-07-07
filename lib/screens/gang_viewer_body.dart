part of 'gang_viewer_screen.dart';

class _ReadOnlyGangBody extends StatelessWidget {
  const _ReadOnlyGangBody({
    required this.gang,
    required this.profiles,
    required this.equipment,
    this.showHeader = true,
    this.onEditCounters,
    this.onEditStats,
  });

  final api.ModelList gang;
  final List<api.Profile> profiles;
  final List<api.Equipment> equipment;

  /// Whether to show the gang name/faction header and ducats bar above the models.
  final bool showHeader;

  /// When set, model tiles with an entry state get a + button that opens the counter popup.
  final void Function(api.ListEntry entry)? onEditCounters;

  /// When set, tapping a model's HP/WP/CP pill opens the stat stepper popup.
  final void Function(api.ListEntry entry)? onEditStats;

  @override
  Widget build(BuildContext context) {
    final factionColor =
        AppPalette.factionColors[gang.faction] ?? context.accentColor;
    return Column(
      children: [
        if (showHeader) ...[
          _buildGangHeader(context, factionColor),
          PointsBar(
            used: gang.totalCost,
            limit: gang.points,
            factionColor: factionColor,
          ),
          const SizedBox(height: 12),
        ],
        Expanded(child: _buildEntries(context, factionColor)),
      ],
    );
  }

  Widget _buildGangHeader(BuildContext context, Color factionColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              gang.name ?? '',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.textColor,
                letterSpacing: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          FactionBadge(faction: gang.faction, color: factionColor),
        ],
      ),
    );
  }

  Widget _buildEntries(BuildContext context, Color factionColor) {
    final entries = gang.entries;
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No models hired.',
          style: GoogleFonts.cinzel(
            fontSize: 14,
            color: context.subtleTextColor,
          ),
        ),
      );
    }
    final hiredProfiles = entries
        .where(
          (e) =>
              e.entryType ==
              api.ListEntryEntryTypeEnum.catalogColonColonCardReference,
        )
        .map(
          (e) => profiles
              .where((p) => p.cardReferenceIds.contains(e.entryId))
              .firstOrNull,
        )
        .whereType<api.Profile>()
        .toList();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final entry = entries[i];
        final profile =
            entry.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonCardReference
            ? profiles
                  .where((p) => p.cardReferenceIds.contains(entry.entryId))
                  .firstOrNull
            : null;
        final equipmentItem =
            entry.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonEquipment
            ? equipment.where((e) => e.id == entry.entryId).firstOrNull
            : null;
        final entryColor =
            entry.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonEquipment
            ? AppPalette.equipment
            : profile?.faction == 'gifted'
            ? (AppPalette.factionColors['gifted'] ?? factionColor)
            : factionColor;
        VoidCallback? onTap;
        if (profile != null) {
          final hiredIndex = hiredProfiles.indexWhere(
            (p) => p.cardReferenceId == profile.cardReferenceId,
          );
          onTap = () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CardViewerScreen(
                profiles: hiredProfiles,
                initialIndex: hiredIndex,
              ),
            ),
          );
        } else if (equipmentItem != null) {
          onTap = () => showEquipmentDetailDialog(context, equipmentItem);
        }
        return _ReadOnlyEntryTile(
          entry: entry,
          color: entryColor,
          onTap: onTap,
          onEditCounters: onEditCounters != null && entry.state != null
              ? () => onEditCounters!(entry)
              : null,
          onEditStats: onEditStats != null && entry.state != null
              ? () => onEditStats!(entry)
              : null,
        );
      },
    );
  }
}

class _ReadOnlyEntryTile extends StatelessWidget {
  const _ReadOnlyEntryTile({
    required this.entry,
    required this.color,
    this.onTap,
    this.onEditCounters,
    this.onEditStats,
  });

  final api.ListEntry entry;
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
            gradient: AppPalette.entryTileGradient(color),
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
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.cost}',
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
                          _StatPill(
                            label: 'HP',
                            value: state.lifePoints,
                            borderColors: AppPalette.hpBorder,
                            onTap: onEditStats,
                          ),
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
                              onTap: state.willPoints.starting == 0
                                  ? null
                                  : onEditStats,
                            ),
                          ),
                          Opacity(
                            opacity: state.commandPoints.starting == 0 ? 0 : 1,
                            child: _StatPill(
                              label: 'CP',
                              value: state.commandPoints,
                              borderColors: AppPalette.cpBorder,
                              onTap: state.commandPoints.starting == 0
                                  ? null
                                  : onEditStats,
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
                        if (onEditCounters != null)
                          _AddCounterButton(onTap: onEditCounters!),
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
  List<Widget> _counterIcons(api.EntryState state) {
    return [
      if (state.stunned)
        _CounterIcon(
          asset: 'assets/images/counters/stunned.png',
          label: 'Stunned',
          active: true,
        ),
      if (state.hidden)
        _CounterIcon(
          asset: 'assets/images/counters/hidden.png',
          label: 'Hidden',
          active: true,
        ),
      if (state.guarding)
        _CounterIcon(
          asset: 'assets/images/counters/guard.png',
          label: 'Guarding',
          active: true,
        ),
      if (state.carryingObjective)
        _CounterIcon(
          asset: 'assets/images/counters/carry_objective.png',
          label: 'Carrying objective',
          active: true,
        ),
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
  const _StatPill({
    required this.label,
    required this.value,
    required this.borderColors,
    this.onTap,
  });

  final String label;
  final api.EntryStatValue value;
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
      foregroundPainter: _GradientBorderPainter(
        colors: borderColors,
        radius: _radius,
        strokeWidth: _strokeWidth,
      ),
      child: Container(
        width: _width,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Text(
          '$label ${value.current}/${value.starting}',
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
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
  _GradientBorderPainter({
    required this.colors,
    required this.radius,
    required this.strokeWidth,
  });

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
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(radius - strokeWidth / 2),
    );
    final paint = Paint()
      ..shader = LinearGradient(colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth;
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
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
          child: const Icon(Icons.add, size: 22, color: Colors.white),
        ),
      ),
    );
  }
}
