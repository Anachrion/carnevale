part of 'gang_builder_screen.dart';

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.factionColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color factionColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? factionColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : context.subtleTextColor,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _EntryTile extends StatefulWidget {
  const _EntryTile({
    required this.entry,
    required this.name,
    required this.factionColor,
    required this.busy,
    required this.onRemove,
    this.role,
    this.onTap,
    this.onEditSpells,
  });

  final api.ListEntry entry;
  // Display name for the tile: the card-reference letter dropped, with a per-copy number when the
  // profile is hired more than once. Not necessarily entry.name (which is the card-reference name).
  final String name;
  final Color factionColor;
  final String? role;
  final bool busy;
  // Returns whether the removal actually happened, so the exit animation can be reversed when the
  // server rejects it (offline / race) instead of leaving an invisible entry behind (A-7).
  final Future<bool> Function() onRemove;
  final VoidCallback? onTap;
  // Non-null only for Mage models; opens the spell picker for this model (rulebook p24).
  final VoidCallback? onEditSpells;

  @override
  State<_EntryTile> createState() => _EntryTileState();
}

class _EntryTileState extends State<_EntryTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  late final Animation<double> _size;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slide = Tween(begin: Offset.zero, end: const Offset(1.2, 0)).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );
    _fade = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );
    _size = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleRemove() async {
    // Don't animate a removal that can't proceed (another mutation is in flight).
    if (widget.busy) return;
    await _ctrl.forward();
    final removed = await widget.onRemove();
    // On success the parent drops this entry from the gang and the tile is gone; on failure the
    // entry is still there, so slide it back in and let the toast (raised by the parent) explain.
    if (!removed && mounted) _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _size,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: GestureDetector(
            onTap: widget.onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppPalette.entryTileGradient(widget.factionColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.name,
                                    style: GoogleFonts.cinzel(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (widget.role != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.role!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white.withValues(
                                        alpha: 0.65,
                                      ),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.entry.cost}',
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: widget.busy ? null : _handleRemove,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.15),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.onEditSpells != null) _buildSpellRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpellRow() {
    final entry = widget.entry;
    final chips = spellChipsFor(entry);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _spellsButton(),
          if (chips.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'No spells',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...chips,
        ],
      ),
    );
  }

  Widget _spellsButton() {
    return GestureDetector(
      onTap: widget.busy ? null : widget.onEditSpells,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.35),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_fix_high,
              size: 12,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 5),
            Text(
              'Spells',
              style: GoogleFonts.cinzel(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HireCardTile extends StatelessWidget {
  const _HireCardTile({
    super.key,
    required this.profile,
    required this.count,
    required this.isUnique,
    required this.factionColor,
    required this.canAdd,
    required this.busy,
    required this.onOpen,
    required this.onAdd,
    required this.onRemove,
  });

  final api.Profile profile;
  final int count;
  final bool isUnique;
  final Color factionColor;
  final bool canAdd;
  final bool busy;

  /// Opens the card viewer. Owned by the screen rather than the tile so it can await the
  /// viewer's dismissal and scroll the hire list to whichever card the user ended on.
  final VoidCallback onOpen;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final inList = count > 0;
    final base = AppPalette.factionColors[profile.faction] ?? factionColor;
    final bgColor = inList ? Color.lerp(base, Colors.black, 0.45)! : base;
    return GestureDetector(
      onTap: onOpen,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 14, 12),
            child: Row(
              children: [
                _HireToggleButton(canAdd: canAdd, busy: busy, onAdd: onAdd),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: Text(
                                profile.name,
                                style: GoogleFonts.cinzel(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (profile.keywords.contains('Leader') ||
                                profile.keywords.contains('Hero')) ...[
                              const SizedBox(width: 6),
                              Text(
                                profile.keywords.contains('Leader')
                                    ? 'leader'
                                    : 'hero',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (inList)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isUnique ? 'Hired' : '×$count',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        '${profile.ducats}',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (inList)
                        GestureDetector(
                          onTap: busy ? null : onRemove,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 28),
                    ],
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

class _HireToggleButton extends StatelessWidget {
  const _HireToggleButton({
    required this.canAdd,
    required this.busy,
    required this.onAdd,
  });

  final bool canAdd;
  final bool busy;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }
    if (!canAdd)
      return SizedBox(
        width: 32,
        height: 32,
        child: Icon(
          Icons.block,
          size: 28,
          color: Colors.white.withValues(alpha: 0.30),
        ),
      );
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.2),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: const Icon(Icons.add, size: 16, color: Colors.white),
      ),
    );
  }
}

class _HireEquipmentTile extends StatelessWidget {
  const _HireEquipmentTile({
    required this.equipment,
    required this.count,
    required this.canAdd,
    required this.busy,
    required this.onAdd,
    required this.onTap,
  });

  final api.Equipment equipment;
  final int count;
  final bool canAdd;
  final bool busy;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inList = count > 0;
    final bgColor = inList
        ? Color.lerp(AppPalette.equipment, Colors.black, 0.35)!
        : canAdd
        ? AppPalette.equipment
        : Color.lerp(AppPalette.equipment, Colors.white, 0.28)!;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 14, 12),
            child: Row(
              children: [
                _HireToggleButton(canAdd: canAdd, busy: busy, onAdd: onAdd),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    equipment.name,
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (inList) ...[
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '×$count',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                Text(
                  '${equipment.cost}',
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
