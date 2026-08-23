// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

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

// Keeps a PageView child mounted while swiped off-screen, so its ScrollPosition (and any other
// per-subtree state) survives switching to the other tab and back.
class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _EntryTile extends StatefulWidget {
  const _EntryTile({
    required this.entry,
    required this.name,
    required this.factionColor,
    required this.onRemove,
    this.role,
    this.onTap,
    this.onEditSpells,
    this.onEditApprenticeship,
    this.onPromote,
    this.isCompanion = false,
    this.onToggleUpgrade,
    this.onPreviewOtherForm,
  });

  final api.ListEntry entry;
  // Display name for the tile: the card-reference letter dropped, with a per-copy number when the
  // profile is hired more than once. Not necessarily entry.name (which is the card-reference name).
  final String name;
  final Color factionColor;
  final String? role;
  // Fire-and-forget: the removal applies optimistically in the parent (the entry leaves `_gang` at
  // once and the delete syncs in the background), so the tile just plays its exit animation and
  // calls this — a genuine rejection re-inserts the entry upstream rather than reversing here.
  final VoidCallback onRemove;
  // An auto-included companion (a Tentacle brought by the Emissary of Mother Hydra, CARNEVALEB-23):
  // read-only — no remove button, and the parent's list excludes it from the draggable reorder set.
  // It leaves only when the model that brought it does.
  final bool isCompanion;
  // Non-null only for a model that offers an optional paid upgrade (the Emissary): toggles it on/off,
  // switching between the base and upgraded companion sets. Reflects entry.upgradeSelected.
  final VoidCallback? onToggleUpgrade;
  final VoidCallback? onTap;
  // Non-null only for Mage models; opens the spell picker for this model (rulebook p24).
  final VoidCallback? onEditSpells;
  // Non-null only for a model with a mentor_derived pool (Apprentice Doctor); opens the mentor
  // picker. Her own "Spells" button only appears once a mentor has actually been chosen — there's
  // nothing to pick a spell from before that.
  final VoidCallback? onEditApprenticeship;
  // Non-null only for a demoted flex Leader the player may crown instead (ambiguous multi-flex case);
  // promotes it to the gang's Leader, demoting whoever holds the slot.
  final VoidCallback? onPromote;
  // Non-null only for a model with a second printed card (Violent Transformation: Yune Lobravym ⇄
  // The Beast Within); opens that card. Preview only — the gang always holds the model as hired,
  // because the rule transforms it in play, not at hiring. The real swap lives in the game screen.
  final VoidCallback? onPreviewOtherForm;

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
    // Play the exit animation, then drop the entry: the parent removes it from `_gang` immediately
    // and syncs the delete in the background, so there's nothing to wait on or reverse here.
    await _ctrl.forward();
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _size,
      alignment: const AlignmentDirectional(-1, -1),
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
                          // A companion can't be removed on its own — it leaves with the model that
                          // brought it — so it shows a read-only link badge instead of the remove button.
                          if (widget.isCompanion)
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              child: Icon(
                                Icons.link,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: _handleRemove,
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
                      if (widget.isCompanion) _buildCompanionLabel(),
                      if (widget.onToggleUpgrade != null) _buildUpgradeRow(),
                      if (widget.onEditSpells != null || widget.onEditApprenticeship != null)
                        _buildSpellRow(),
                      if (widget.onPreviewOtherForm != null) _buildOtherFormRow(),
                      if (widget.onPromote != null) _buildPromoteRow(),
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
    final isApprentice = widget.onEditApprenticeship != null;
    final hasMentor = entry.mentoredByEntryId != null;
    final chips = spellSummaryChipsFor(AppLocalizations.of(context), entry);
    // Every chip is a shortcut into the same dialog the Spells button opens — a chip only ever
    // renders once there's something picked/granted to show, which (Apprentice Doctor included)
    // is exactly when that dialog is reachable at all.
    final tappableChips = chips
        .map(
          (chip) => GestureDetector(
            onTap: widget.onEditSpells,
            child: chip,
          ),
        )
        .toList();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (isApprentice) _apprenticeshipButton(),
          // Nothing to pick spells from until a mentor is actually chosen — the button only
          // appears once Apprenticeship has something to hand her.
          if (widget.onEditSpells != null && (!isApprentice || hasMentor)) _spellsButton(),
          if (tappableChips.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                isApprentice && !hasMentor
                    ? AppLocalizations.of(context).gangNoMentorChosen
                    : AppLocalizations.of(context).gangNoSpells,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...tappableChips,
        ],
      ),
    );
  }

  // A quiet caption marking an auto-included companion, so it reads as brought-in rather than hired.
  Widget _buildCompanionLabel() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        'Auto-included',
        style: TextStyle(
          fontSize: 10,
          color: Colors.white.withValues(alpha: 0.6),
          fontStyle: FontStyle.italic,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // The optional paid upgrade toggle on a model that brings companions (the Emissary): buys or drops
  // the extra companions for its upgrade cost. Highlighted when active; the card's own rule text
  // explains what the upgrade does.
  Widget _buildUpgradeRow() {
    final selected = widget.entry.upgradeSelected;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: widget.onToggleUpgrade,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: selected ? 0.28 : 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: selected ? 0.6 : 0.3),
                width: selected ? 1 : 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.add_circle_outline,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 5),
                Text(
                  'Upgrade  +${widget.entry.upgradeDucats} Ducats',
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
        ),
      ),
    );
  }

  // Shown on a demoted flex Leader the player may crown instead (two+ flex Leaders, no forced one).
  Widget _buildPromoteRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: widget.onPromote,
          child: _pillButton(icon: Icons.military_tech, label: 'Promote leader'),
        ),
      ),
    );
  }

  // Violent Transformation, in the builder: a pill that opens the model's other card. It changes
  // nothing about the gang — the model is hired in its printed form and stays that way, and the
  // ducats never move — so this is a reading aid, labelled with the form it opens.
  Widget _buildOtherFormRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onPreviewOtherForm,
            child: _pillButton(
              icon: Icons.sync_alt,
              label: widget.entry.alternateName ??
                  AppLocalizations.of(context).labelOtherForm,
            ),
          ),
        ],
      ),
    );
  }

  Widget _spellsButton() {
    return GestureDetector(
      onTap: widget.onEditSpells,
      child: _pillButton(icon: Icons.auto_fix_high, label: AppLocalizations.of(context).labelSpells),
    );
  }

  Widget _apprenticeshipButton() {
    return GestureDetector(
      onTap: widget.onEditApprenticeship,
      child: _pillButton(icon: Icons.school_outlined, label: AppLocalizations.of(context).labelApprenticeship),
    );
  }

  Widget _pillButton({required IconData icon, required String label}) {
    return Container(
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
          Icon(icon, size: 12, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
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
    required this.owned,
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

  /// How many of this model the player owns (CARNEVALEB-76). Here the badge answers a different
  /// question from the one it answers on the Cards screen — not "what state is it in?" but "have I
  /// got enough?" — so a gang that hires more copies than the shelf holds shows the shortfall.
  final int owned;
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
                                    ? AppLocalizations.of(context).gangRoleLeader
                                    : AppLocalizations.of(context).gangRoleHero,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            if (owned > 0) ...[
                              const SizedBox(width: 6),
                              CollectionGlyph.mark(
                                color: CollectionGlyph.tileColorFor(
                                  CollectionState.painted,
                                ),
                                size: 15,
                              ),
                            ],
                            // Only when the gang asks for more than the player owns: the number
                            // that matters is the gap, and it should look like a problem.
                            if (count > owned && owned >= 0 && count > 0) ...[
                              const SizedBox(width: 3),
                              Text(
                                '$owned/$count',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: context.dangerColor,
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
                            isUnique ? AppLocalizations.of(context).gangHired : '×$count',
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
    if (!canAdd) {
      return SizedBox(
        width: 32,
        height: 32,
        child: Icon(
          Icons.block,
          size: 28,
          color: Colors.white.withValues(alpha: 0.30),
        ),
      );
    }
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
