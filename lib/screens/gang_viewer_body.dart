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

part of 'gang_viewer_screen.dart';

class _ReadOnlyGangBody extends StatelessWidget {
  const _ReadOnlyGangBody({
    required this.gang,
    required this.profiles,
    required this.equipment,
    this.showHeader = true,
    this.presetLabels = const {},
    this.onEditModel,
    this.onOpenGrant,
    this.onEditStats,
    this.onToggleActivated,
    this.onToggleToken,
    this.onEditTokenCount,
    this.onToggleSpellCast,
    this.onSummon,
    this.onDismissSummon,
    this.onTransform,
  });

  final api.ModelList gang;
  final List<api.Profile> profiles;
  final List<api.Equipment> equipment;

  /// Whether to show the gang name/faction header and ducats bar above the models.
  final bool showHeader;

  /// Labels of the predefined presets, so a tapped token routes to the Predefined vs Custom tab.
  final Set<String> presetLabels;

  /// When set, model tiles get an Edit (pencil) button that opens the counter + token modal, and a
  /// tapped marker opens it on its own tab. The tab argument selects which.
  final void Function(api.ListEntry entry, ModelEditTab tab)? onEditModel;

  /// When set, a mask giver / choice model gets a tile button that opens the grant modal. Own models
  /// only — a grant is always cast by (and within) the acting player's own gang.
  final void Function(api.ListEntry entry)? onOpenGrant;

  /// When set, tapping a model's HP/WP/CP pill opens the stat stepper popup.
  final void Function(api.ListEntry entry)? onEditStats;

  /// When set, model tiles get a spelled-out Activate control that marks the model activated this
  /// turn. Own models only — an opponent's activated models still darken, they just can't be toggled.
  final void Function(api.ListEntry entry)? onToggleActivated;

  /// When set, tapping a toggleable token on a model's tile flips its active state. Own models only.
  final void Function(api.ListEntry entry, api.Token token)? onToggleToken;

  /// When set, tapping a counter token opens its −/+ stepper. Own models only.
  final void Function(api.ListEntry entry, api.Token token)? onEditTokenCount;

  /// When set, a Mage's known/granted spells render as pure-toggle chips (mark cast) plus one
  /// detail button, instead of the read-only tappable-for-detail chips. Own models only — the
  /// opponent's spells stay read-only, same reasoning as onToggleActivated above.
  final void Function(api.ListEntry entry, KnownSpell spell)? onToggleSpellCast;

  /// When set, a Summon button is offered above the gang — for the rare models whose special rules
  /// conjure new models mid-battle. Own gang only.
  final VoidCallback? onSummon;

  /// Removes a summoned model. Offered only on summoned ones: the hired roster is frozen.
  final void Function(api.ListEntry entry)? onDismissSummon;

  /// Violent Transformation: swaps a model between its two printed cards. Offered only on entries
  /// the server marked `transformable`, and only in your own gang — the opponent's models are
  /// read-only here, the same reasoning as onToggleActivated.
  final void Function(api.ListEntry entry)? onTransform;

  @override
  Widget build(BuildContext context) {
    final factionColor =
        AppPalette.factionColors[gang.faction] ?? context.accentColor;
    final entries = _buildEntries(context, factionColor);
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
        // The action row (faction rule + Summon) is pinned above the roster but tucks itself away
        // as you scroll down into the list, rather than floating over the models — see
        // _ScrollHidingActions.
        Expanded(
          child: _hasActionRow
              ? _ScrollHidingActions(
                  actions: _buildActionRow(context),
                  list: entries,
                )
              : entries,
        ),
      ],
    );
  }

  /// The faction rule is reference, shown for any gang (your own, the opponent's); Summon is only
  /// your own. The row appears if either belongs on it.
  bool get _hasActionRow =>
      onSummon != null || factionSpecialRules.containsKey(gang.faction);

  /// The strip above the roster: the faction's Command Ability on the left (reference, shown for
  /// every faction) and — on your own gang only — the Summon action on the right. Both are
  /// deliberately quiet text buttons rather than permanent chunks of the screen.
  Widget _buildActionRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(
        children: [
          if (factionSpecialRules.containsKey(gang.faction))
            _buildFactionRuleButton(context),
          const Spacer(),
          if (onSummon != null) _buildSummonButton(context),
        ],
      ),
    );
  }

  /// Opens the faction's signature Command Ability. Shown only when we have that faction's rule on
  /// file, so the button never leads to an empty dialog.
  Widget _buildFactionRuleButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => showFactionRuleDialog(context, gang.faction),
      icon: Icon(Icons.auto_stories, size: 16, color: context.accentColor),
      label: Text(
        AppLocalizations.of(context).labelFactionRule,
        style: GoogleFonts.cinzel(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: context.accentColor,
        ),
      ),
    );
  }

  /// Deliberately understated: summoning is rare (a handful of models in the game can do it at all),
  /// so it earns a quiet text button rather than a permanent chunk of the gang screen.
  Widget _buildSummonButton(BuildContext context) {
    return TextButton.icon(
      onPressed: onSummon,
      icon: Icon(Icons.auto_awesome, size: 16, color: context.accentColor),
      label: Text(
        AppLocalizations.of(context).labelSummon,
        style: GoogleFonts.cinzel(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: context.accentColor,
        ),
      ),
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

  /// True once the model has lost its last life point. Equipment (and any entry outside a live game)
  /// has no state, so it is never dead and stays with the living.
  static bool _isDead(api.ListEntry entry) => entry.state?.dead ?? false;

  Widget _buildEntries(BuildContext context, Color factionColor) {
    // Casualties sink to the bottom: mid-game you act on the models still standing, so the living
    // gang stays together at the top instead of being punctuated by corpses. Order is otherwise
    // preserved within each group, so the roster you built still reads the way you built it. The
    // card viewer pages through this same list, so it follows suit.
    final entries = [
      ...gang.entries.where((e) => !_isDead(e)),
      ...gang.entries.where(_isDead),
    ];
    if (entries.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).gangViewerNoModels,
          style: GoogleFonts.cinzel(
            fontSize: 14,
            color: context.subtleTextColor,
          ),
        ),
      );
    }
    // Keep each hired card-reference entry paired with its profile, in roster order, so a tapped
    // tile can be located by *entry* id. Matching on the profile alone sent every duplicate of a
    // model to the first copy's card (A-11).
    final hired = entries
        .where(
          (e) =>
              e.entryType ==
              api.ListEntryEntryTypeEnum.catalogColonColonCardReference,
        )
        .map(
          (e) => (
            entry: e,
            profile: profiles
                .where((p) => p.cardReferenceIds.contains(e.entryId))
                .firstOrNull,
          ),
        )
        .where((pair) => pair.profile != null)
        .toList();
    final hiredProfiles = hired.map((pair) => pair.profile!).toList();
    // Parallel to hiredProfiles: which illustration each entry was actually hired as, so the
    // viewer opens A/B-pair models on the art the player picked rather than the profile's first.
    final hiredReferenceIds = hired.map((pair) => pair.entry.entryId).toList();
    // Every giver whose grant is already on the board (its token id encodes the giver), so a mask
    // giver's button reads as consumed. Scanned once across the gang since a mask's token sits on its
    // target, not the giver.
    final placedGiverIds = <int>{};
    for (final e in gang.entries) {
      for (final t in e.state?.tokens ?? const <api.Token>[]) {
        final giverId = grantGiverId(t);
        if (giverId != null) placedGiverIds.add(giverId);
      }
    }
    // Ordering (and the death animation that reorders) lives in _GangEntryList, which is given the
    // roster as-is so it can tell a *fresh* casualty from one that was already down.
    return _GangEntryList(
      entries: gang.entries.toList(),
      buildTile: (entry) {
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
          final hiredIndex = hired.indexWhere((pair) => pair.entry.id == entry.id);
          onTap = () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CardViewerScreen(
                profiles: hiredProfiles,
                initialIndex: hiredIndex,
                selectedReferenceIds: hiredReferenceIds,
              ),
            ),
          );
        } else if (equipmentItem != null) {
          onTap = () => showEquipmentDetailDialog(context, equipmentItem);
        }
        // A mask giver / choice model offers the grant button; a mask giver whose mask is already on
        // the board shows it as consumed.
        final grant = profile != null ? grantSourceFor(profile) : null;
        return _ReadOnlyEntryTile(
          entry: entry,
          color: entryColor,
          onTap: onTap,
          presetLabels: presetLabels,
          onEditModel: onEditModel != null && entry.state != null
              ? (tab) => onEditModel!(entry, tab)
              : null,
          onGrant: onOpenGrant != null && grant != null && entry.state != null
              ? () => onOpenGrant!(entry)
              : null,
          grantIsMask: grant?.targetsOther ?? false,
          grantUsed: grant != null &&
              grant.oncePerGame &&
              placedGiverIds.contains(entry.id),
          onEditStats: onEditStats != null && entry.state != null
              ? () => onEditStats!(entry)
              : null,
          onToggleActivated: onToggleActivated != null && entry.state != null
              ? () => onToggleActivated!(entry)
              : null,
          onToggleToken: onToggleToken != null && entry.state != null
              ? (token) => onToggleToken!(entry, token)
              : null,
          onEditTokenCount: onEditTokenCount != null && entry.state != null
              ? (token) => onEditTokenCount!(entry, token)
              : null,
          onToggleSpellCast: onToggleSpellCast != null && entry.state != null
              ? (spell) => onToggleSpellCast!(entry, spell)
              : null,
          // Only summoned models can be removed mid-game; the hired roster is frozen.
          onDismiss: onDismissSummon != null && entry.summoned
              ? () => onDismissSummon!(entry)
              : null,
          // Only a model with a second printed card can change form, and only once the game is
          // live — a transformation happens on the table, not in the roster.
          onTransform: onTransform != null && entry.transformable && entry.state != null
              ? () => onTransform!(entry)
              : null,
        );
      },
    );
  }
}

/// Floats the action row (faction rule + Summon) above the roster, pinned to the top, and slides it
/// out of the way the moment you scroll down into the list — so it never sits on top of the models
/// you're reading. Scrolling back up toward the top brings it straight back. Losing it mid-scroll
/// costs nothing: these are deliberate acts you'd scroll up to reach anyway.
class _ScrollHidingActions extends StatefulWidget {
  const _ScrollHidingActions({required this.actions, required this.list});

  final Widget actions;
  final Widget list;

  @override
  State<_ScrollHidingActions> createState() => _ScrollHidingActionsState();
}

class _ScrollHidingActionsState extends State<_ScrollHidingActions> {
  bool _visible = true;

  bool _onScroll(UserScrollNotification notification) {
    // Only the roster's own vertical drags should move the button; the idle settle after a fling
    // is left alone so the button doesn't flicker back the instant scrolling stops.
    if (notification.metrics.axis != Axis.vertical) return false;
    final visible = switch (notification.direction) {
      ScrollDirection.reverse => false, // dragging content up — reading down the list
      ScrollDirection.forward => true, // dragging back down toward the top
      ScrollDirection.idle => _visible,
    };
    if (visible != _visible) setState(() => _visible = visible);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: _onScroll,
      child: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _visible
                ? widget.actions
                : const SizedBox(width: double.infinity),
          ),
          Expanded(child: widget.list),
        ],
      ),
    );
  }
}

/// The gang list, and the one place that knows where a model *sits*: the living in roster order,
/// then the dead.
///
/// A death plays in two beats rather than snapping. First the tile is left exactly where it stands
/// while its contents refresh, so it turns to slate and grows a skull *where you can see it happen*
/// (that transition belongs to [_ReadOnlyEntryTile] itself). Only then is the body carried off: its
/// slot collapses shut, the living close ranks, and it re-expands at the bottom.
///
/// The alternative — literally sliding the card down the viewport — was rejected: a gang usually
/// runs longer than a phone screen, so the graveyard is below the fold and the card would sail off
/// the edge to nowhere. Collapsing out and expanding in reads as a journey either way.
class _GangEntryList extends StatefulWidget {
  const _GangEntryList({required this.entries, required this.buildTile});

  /// The roster, in roster order — deliberately *not* pre-sorted, so the list can compare against
  /// what it is already showing and tell a new casualty from one that was already down.
  final List<api.ListEntry> entries;
  final Widget Function(api.ListEntry entry) buildTile;

  @override
  State<_GangEntryList> createState() => _GangEntryListState();
}

class _GangEntryListState extends State<_GangEntryList> {
  /// Replaced (not just re-keyed) whenever the roster itself changes, which forces Flutter to build
  /// a *new* AnimatedList element that honours the new `initialItemCount`. Re-keying the subtree
  /// above it is not enough: a GlobalKey outranks an ancestor's ValueKey, so the old element — and
  /// with it AnimatedListState's stale item count — would simply be moved across, and a summoned
  /// model would never appear.
  GlobalKey<AnimatedListState> _listKey = GlobalKey();

  /// How long the corpse is left in place before it's carried off — long enough for the tile's own
  /// colour/skull transition to land, so the death is read where it happened.
  static const _deathBeat = Duration(milliseconds: 500);
  static const _collapse = Duration(milliseconds: 260);
  static const _expand = Duration(milliseconds: 340);

  late List<api.ListEntry> _items = _ordered(widget.entries);

  static bool _isDead(api.ListEntry entry) => entry.state?.dead ?? false;

  static List<api.ListEntry> _ordered(List<api.ListEntry> entries) => [
    ...entries.where((e) => !_isDead(e)),
    ...entries.where(_isDead),
  ];

  @override
  void didUpdateWidget(_GangEntryList old) {
    super.didUpdateWidget(old);

    final byId = {for (final e in widget.entries) e.id: e};
    final sameRoster =
        _items.length == widget.entries.length &&
        _items.every((e) => byId.containsKey(e.id));

    final wasDead = {for (final e in old.entries) e.id: _isDead(e)};
    final freshlyDead = widget.entries
        .where((e) => _isDead(e) && !(wasDead[e.id] ?? false))
        .toList();
    final revived = widget.entries.any(
      (e) => !_isDead(e) && (wasDead[e.id] ?? false),
    );

    // A roster change (a summon, a dismissal, the first load) or a revival re-sorts outright, on a
    // fresh list. Reviving is an undo — usually of a mis-tapped kill — so it wants to look like a
    // correction, not a ceremony; and a summon/dismissal changes the item count, which AnimatedList
    // can only pick up from a newly-built element.
    if (!sameRoster || revived) {
      setState(() {
        _items = _ordered(widget.entries);
        _listKey = GlobalKey();
      });
      return;
    }

    // Same models, new state. Refresh each tile's contents *in place*, leaving the order alone, so a
    // model that just died turns to slate where it stands instead of teleporting mid-transition.
    setState(() => _items = [for (final e in _items) byId[e.id]!]);

    for (final entry in freshlyDead) {
      Future.delayed(_deathBeat, () {
        if (mounted) _carryOff(entry.id);
      });
    }
  }

  /// Collapses the model's slot where it fell and re-expands it at the foot of the list.
  void _carryOff(int id) {
    final from = _items.indexWhere((e) => e.id == id);
    // Already moved, or the roster was rebuilt under us while the beat played out.
    if (from < 0 || !_isDead(_items[from])) return;

    final entry = _items.removeAt(from);
    _listKey.currentState?.removeItem(
      from,
      (context, animation) => _slot(animation, widget.buildTile(entry)),
      duration: _collapse,
    );
    _items.add(entry);
    _listKey.currentState?.insertItem(_items.length - 1, duration: _expand);
    setState(() {});
  }

  /// One row: the tile plus the gap below it. The gap lives *inside* the row rather than in a
  /// separator, so it collapses along with the tile — a separator would be left behind as a stray
  /// 8px of dead space where the model used to be.
  Widget _slot(Animation<double> animation, Widget child) => SizeTransition(
    sizeFactor: animation.drive(CurveTween(curve: Curves.easeInOut)),
    // Pinned to the top, so the slot closes downward from where the tile sat rather than
    // squeezing shut from both edges.
    alignment: Alignment.topCenter,
    child: Padding(padding: const EdgeInsets.only(bottom: 8), child: child),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      initialItemCount: _items.length,
      itemBuilder: (context, i, animation) =>
          _slot(animation, widget.buildTile(_items[i])),
    );
  }
}

class _ReadOnlyEntryTile extends StatelessWidget {
  const _ReadOnlyEntryTile({
    required this.entry,
    required this.color,
    this.onTap,
    this.presetLabels = const {},
    this.onEditModel,
    this.onGrant,
    this.grantIsMask = false,
    this.grantUsed = false,
    this.onEditStats,
    this.onToggleActivated,
    this.onToggleToken,
    this.onEditTokenCount,
    this.onToggleSpellCast,
    this.onDismiss,
    this.onTransform,
  });

  final api.ListEntry entry;
  final Color color;
  final VoidCallback? onTap;

  /// Labels of the predefined presets, so a tapped token opens the Predefined vs Custom tab.
  final Set<String> presetLabels;

  /// Opens the counter/token modal on a given tab (own models only). The Edit button and a tapped
  /// marker both go through here. Replaces the old counter "+".
  final void Function(ModelEditTab tab)? onEditModel;

  /// Opens the grant modal (mask giver / choice model, own models only).
  final VoidCallback? onGrant;

  /// Whether the grant is a mask (given to another model) vs a self choice — only affects the button
  /// tooltip.
  final bool grantIsMask;

  /// A once-per-game mask giver whose mask is already on the board — the button reads as consumed.
  final bool grantUsed;

  final VoidCallback? onEditStats;
  final VoidCallback? onToggleActivated;

  /// Flips a toggleable token's active state straight from the tile (own models only).
  final void Function(api.Token token)? onToggleToken;

  /// Opens the −/+ stepper for a counter token (own models only).
  final void Function(api.Token token)? onEditTokenCount;
  final void Function(KnownSpell spell)? onToggleSpellCast;

  /// Removes this model from the gang. Only ever set on a summoned model of your own.
  final VoidCallback? onDismiss;

  /// Violent Transformation: swaps this model to its other printed card. Only ever set on your own
  /// models that have one.
  final VoidCallback? onTransform;

  /// The tile's own death transition — colour draining to slate, skull growing in. Deliberately
  /// shorter than the beat _GangEntryList waits before carrying the body off, so the death has
  /// fully landed before the tile starts to move.
  static const _deathTransition = Duration(milliseconds: 420);

  @override
  Widget build(BuildContext context) {
    final state = entry.state;
    // A model that has already gone this turn sits on a darkened tile, so a glance down the gang
    // answers the only question that matters mid-turn: who's left? Only the background darkens —
    // the name, stats and counters stay at full strength, and nothing is disabled: you can still
    // open the card, edit stats, and (on your own models) tap the bolt again to undo it.
    final activated = state?.activated ?? false;
    // A dead model drops its faction color entirely for a cold slate, which reads as "out of the
    // game" rather than merely quiet. It stays fully editable — healing it back above 0 HP revives
    // it — so nothing here is disabled; `dead` is simply derived from its HP.
    final dead = state?.dead ?? false;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // Animated, so a model that dies visibly bleeds out from its faction colour to slate where
        // it stands — before _GangEntryList carries it off to the bottom. Also smooths the (much
        // smaller) darkening when a model is activated.
        child: AnimatedContainer(
          duration: _deathTransition,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: AppPalette.entryTileGradient(
              dead ? AppPalette.deadEntry : color,
              // Death already darkens the tile; dimming a corpse on top of that just muddies it.
              dimmed: activated && !dead,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Grows in alongside the tile's colour change rather than popping into existence,
                  // so the two read as one event. Collapses to nothing when the model is alive.
                  AnimatedSize(
                    duration: _deathTransition,
                    curve: Curves.easeOut,
                    child: dead
                        ? const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Text('💀', style: TextStyle(fontSize: 13)),
                          )
                        : const SizedBox.shrink(),
                  ),
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
                  // Conjured onto the board, not hired — so it's marked, and its cost is shown as a
                  // dash rather than a number it never actually cost the gang.
                  if (entry.summoned) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ],
                  const SizedBox(width: 8),
                  Text(
                    entry.summoned ? '—' : '${entry.cost}',
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
                // Stats and the tile controls share one line, so a model with no markers doesn't grow
                // an extra row just to carry Edit/Activate. Stats still keep their own row — the
                // markers below never compress them into a column.
                Row(
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
                          // Hidden (not omitted) when the model was never given this stat at all
                          // (starting 0) — keeps the pill in the layout, just invisible, rather than
                          // shifting everything after it over. An invisible pill isn't tappable.
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
                    if (onTransform != null) ...[
                      const SizedBox(width: 8),
                      _TransformButton(
                        otherFormName: entry.alternateName ?? '',
                        onTap: onTransform!,
                      ),
                    ],
                    if (onDismiss != null) ...[
                      const SizedBox(width: 8),
                      _DismissButton(onTap: onDismiss!),
                    ],
                    if (onGrant != null) ...[
                      const SizedBox(width: 8),
                      _GrantButton(
                        used: grantUsed,
                        isMask: grantIsMask,
                        onTap: onGrant!,
                      ),
                    ],
                    if (onEditModel != null) ...[
                      const SizedBox(width: 8),
                      _EditButton(
                        onTap: () => onEditModel!(ModelEditTab.generic),
                      ),
                    ],
                    if (onToggleActivated != null) ...[
                      const SizedBox(width: 8),
                      _ActivateButton(activated: activated, onTap: onToggleActivated!),
                    ] else if (activated) ...[
                      const SizedBox(width: 8),
                      const _ActivateButton(activated: true),
                    ],
                  ],
                ),
                // Markers (counters + tokens) and, for a Mage, the Spells pill — each taking a line
                // only when there's something to show, so a plain model ends at the stats row.
                _MarkerShelf(
                  markers: [
                    ..._counterIcons(context, state),
                    for (final token in state.tokens)
                      TokenChip(
                        token: token,
                        // A grant token (a mask/choice) is non-editable — managed only from its
                        // giver's grant modal — so its tap is swallowed. Otherwise: a counter token
                        // opens its −/+ stepper; a toggleable one flips on tap (the frequent per-turn
                        // flip); a plain one opens the Edit modal on its own tab — Predefined if it's a
                        // preset, else Custom. On a read-only tile the tap is just swallowed so it
                        // doesn't fall through and open the card viewer.
                        onTap: isGrantToken(token)
                            ? () {}
                            : token.count != null && onEditTokenCount != null
                            ? () => onEditTokenCount!(token)
                            : token.toggleable && onToggleToken != null
                            ? () => onToggleToken!(token)
                            : onEditModel != null
                            ? () => onEditModel!(
                                presetLabels.contains(token.text ?? '')
                                    ? ModelEditTab.predefined
                                    : ModelEditTab.custom,
                              )
                            : () {},
                      ),
                  ],
                  spells: _knownSpells,
                  onToggleSpellCast: onToggleSpellCast,
                ),
              ],
              // Standalone (no in-game state): no controls row, so a Mage's spells get their own line.
              if (state == null && _knownSpells.isNotEmpty) ...[
                const SizedBox(height: 10),
                SpellsButton(spells: _knownSpells, onToggle: onToggleSpellCast),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Known/granted spells for a Mage model. Empty for everything else.
  List<KnownSpell> get _knownSpells => entry.mage ? knownSpellsFor(entry) : const [];

  // Only the active counters appear — a counter set to false (or 0 underwater) is omitted entirely,
  // so a clean model shows no counter icons at all. Tapping one opens the Edit modal on the Generic
  // tab (own models); on a read-only tile it just swallows the tap.
  List<Widget> _counterIcons(BuildContext context, api.EntryState state) {
    final l10n = AppLocalizations.of(context);
    final onTap = onEditModel != null
        ? () => onEditModel!(ModelEditTab.generic)
        : null;
    return [
      if (state.stunned)
        _TileMarkerIcon(
          asset: 'assets/images/counters/stunned.png',
          label: l10n.counterStunned,
          onTap: onTap,
        ),
      if (state.hidden)
        _TileMarkerIcon(
          asset: 'assets/images/counters/hidden.png',
          label: l10n.counterHidden,
          onTap: onTap,
        ),
      if (state.guarding)
        _TileMarkerIcon(
          asset: 'assets/images/counters/guard.png',
          label: l10n.counterGuarding,
          onTap: onTap,
        ),
      if (state.carryingObjective)
        _TileMarkerIcon(
          asset: 'assets/images/counters/carry_objective.png',
          label: l10n.counterCarryingObjective,
          onTap: onTap,
        ),
      if (state.underwaterCounters > 0)
        _TileMarkerIcon(
          asset: 'assets/images/counters/underwater_counter.png',
          label: l10n.counterUnderwater,
          badge: state.underwaterCounters,
          onTap: onTap,
        ),
    ];
  }
}

/// The tile's marker shelf: the counter/token markers and, for a Mage, the Spells pill. Each only
/// takes a line when it has something to show, so a plain model ends at the stats row (Edit/Activate
/// now live up there). Renders nothing when there are no markers and no spells.
class _MarkerShelf extends StatelessWidget {
  const _MarkerShelf({
    required this.markers,
    required this.spells,
    this.onToggleSpellCast,
  });

  final List<Widget> markers;
  final List<KnownSpell> spells;
  final void Function(KnownSpell spell)? onToggleSpellCast;

  @override
  Widget build(BuildContext context) {
    final hasSpells = spells.isNotEmpty;
    if (markers.isEmpty && !hasSpells) return const SizedBox.shrink();

    return Padding(
      // Clear the stats row above: the pills float centred in a row sized by the taller controls, so
      // there's already some slack, but this keeps the rightmost markers from crowding the buttons.
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (markers.isNotEmpty)
            Wrap(spacing: 6, runSpacing: 6, children: markers),
          if (hasSpells) ...[
            if (markers.isNotEmpty) const SizedBox(height: 8),
            SpellsButton(spells: spells, onToggle: onToggleSpellCast),
          ],
        ],
      ),
    );
  }
}

/// An active counter on the model tile's marker shelf. Coherent with [TokenChip]: the same quiet
/// dark chip + hairline light border, so counters and tokens read as one family and both stay
/// legible on the lighter *and* darker parts of the faction-coloured row (the old accent-tinted
/// circle washed out on the lighter side).
class _TileMarkerIcon extends StatelessWidget {
  const _TileMarkerIcon({
    required this.asset,
    required this.label,
    this.badge,
    this.onTap,
  });

  final String asset;
  final String label;
  final int? badge;

  /// Opens the Edit modal on the Generic tab (own models). Null on a read-only tile — the tap is
  /// still swallowed so it doesn't fall through and open the card viewer.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap ?? () {},
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.32), width: 1),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Image.asset(
                asset,
                width: 29,
                height: 29,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
            if (badge != null)
              Positioned(
                right: -3,
                bottom: -3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: context.accentColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$badge',
                    style: GoogleFonts.cinzel(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
          ),
        ),
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
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

/// The "has this model gone yet?" bolt. Solid-filled once activated, so the tile's own darkening is
/// reinforced by an explicit marker. Rendered without an [onTap] for an opponent's models (read-only).
class _ActivateButton extends StatelessWidget {
  const _ActivateButton({required this.activated, this.onTap});

  final bool activated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final button = Tooltip(
      message: activated ? l10n.actionActivated : l10n.actionActivate,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: activated ? Colors.white : Colors.transparent,
          border: Border.all(
            color: Colors.white.withValues(alpha: activated ? 1 : 0.5),
            width: 1.4,
          ),
        ),
        child: Icon(
          Icons.bolt,
          size: 20,
          color: activated ? Colors.black87 : Colors.white,
        ),
      ),
    );
    if (onTap == null) return button;
    return GestureDetector(onTap: onTap, child: button);
  }
}

/// Violent Transformation: swaps a model between its two printed cards (Yune Lobravym ⇄ The Beast
/// Within). Only shown on your own models that actually have another form. The two forms share one
/// entry — and so one set of HP/WP/CP — so nothing about the tile's stats moves when it is tapped;
/// only the name, the cost line and the card behind it change.
class _TransformButton extends StatelessWidget {
  const _TransformButton({required this.otherFormName, required this.onTap});

  /// The form being transformed *into*, so the tooltip names the destination rather than the
  /// current state — the button reads as an action, not a status.
  final String otherFormName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context).tooltipTransformInto(otherFormName),
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
          child: const Icon(Icons.sync_alt, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

/// Removes a summoned model. Only ever shown on your own summoned models — a hired model can't be
/// removed mid-game, so this never appears on one, and the server refuses it regardless.
class _DismissButton extends StatelessWidget {
  const _DismissButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context).tooltipRemoveSummoned,
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
          child: const Icon(Icons.close, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

/// Opens the grant modal for a mask giver / choice model (own models only). A theatre-mask glyph ties
/// it to masks; once a once-per-game mask has been given the button dims to read as spent — it stays
/// tappable (to see who wears it and undo if needed) but no longer draws the eye like a live action.
class _GrantButton extends StatelessWidget {
  const _GrantButton({
    required this.used,
    required this.isMask,
    required this.onTap,
  });

  final bool used;
  final bool isMask;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: isMask ? l10n.grantTooltipMask : l10n.grantTooltipChoice,
      child: GestureDetector(
        onTap: onTap,
        // A spent once-per-game mask dims rather than filling in: it's done its job, so it recedes
        // instead of shouting for attention like the still-actionable controls beside it.
        child: Opacity(
          opacity: used ? 0.4 : 1,
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
            child: const Icon(
              Icons.theater_comedy,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens the model's counter + token modal (own models only). A pencil, so it reads as "edit"
/// rather than the old ambiguous "+" that both added and removed.
class _EditButton extends StatelessWidget {
  const _EditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context).tooltipEditModel,
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
          child: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
