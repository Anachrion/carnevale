// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of 'gang_viewer_screen.dart';

class _ReadOnlyGangBody extends StatelessWidget {
  const _ReadOnlyGangBody({
    required this.gang,
    required this.profiles,
    required this.equipment,
    this.showHeader = true,
    this.onEditModel,
    this.onEditStats,
    this.onToggleActivated,
    this.onToggleToken,
    this.onToggleSpellCast,
    this.onSummon,
    this.onDismissSummon,
  });

  final api.ModelList gang;
  final List<api.Profile> profiles;
  final List<api.Equipment> equipment;

  /// Whether to show the gang name/faction header and ducats bar above the models.
  final bool showHeader;

  /// When set, model tiles get an Edit (pencil) button that opens the counter + token modal.
  final void Function(api.ListEntry entry)? onEditModel;

  /// When set, tapping a model's HP/WP/CP pill opens the stat stepper popup.
  final void Function(api.ListEntry entry)? onEditStats;

  /// When set, model tiles get a spelled-out Activate control that marks the model activated this
  /// turn. Own models only — an opponent's activated models still darken, they just can't be toggled.
  final void Function(api.ListEntry entry)? onToggleActivated;

  /// When set, tapping a toggleable token on a model's tile flips its active state. Own models only.
  final void Function(api.ListEntry entry, api.Token token)? onToggleToken;

  /// When set, a Mage's known/granted spells render as pure-toggle chips (mark cast) plus one
  /// detail button, instead of the read-only tappable-for-detail chips. Own models only — the
  /// opponent's spells stay read-only, same reasoning as onToggleActivated above.
  final void Function(api.ListEntry entry, KnownSpell spell)? onToggleSpellCast;

  /// When set, a Summon button is offered above the gang — for the rare models whose special rules
  /// conjure new models mid-battle. Own gang only.
  final VoidCallback? onSummon;

  /// Removes a summoned model. Offered only on summoned ones: the hired roster is frozen.
  final void Function(api.ListEntry entry)? onDismissSummon;

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
        return _ReadOnlyEntryTile(
          entry: entry,
          color: entryColor,
          onTap: onTap,
          onEditModel: onEditModel != null && entry.state != null
              ? () => onEditModel!(entry)
              : null,
          onEditStats: onEditStats != null && entry.state != null
              ? () => onEditStats!(entry)
              : null,
          onToggleActivated: onToggleActivated != null && entry.state != null
              ? () => onToggleActivated!(entry)
              : null,
          onToggleToken: onToggleToken != null && entry.state != null
              ? (token) => onToggleToken!(entry, token)
              : null,
          onToggleSpellCast: onToggleSpellCast != null && entry.state != null
              ? (spell) => onToggleSpellCast!(entry, spell)
              : null,
          // Only summoned models can be removed mid-game; the hired roster is frozen.
          onDismiss: onDismissSummon != null && entry.summoned
              ? () => onDismissSummon!(entry)
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
    this.onEditModel,
    this.onEditStats,
    this.onToggleActivated,
    this.onToggleToken,
    this.onToggleSpellCast,
    this.onDismiss,
  });

  final api.ListEntry entry;
  final Color color;
  final VoidCallback? onTap;

  /// Opens the counter/token modal (own models only). Replaces the old counter "+".
  final VoidCallback? onEditModel;
  final VoidCallback? onEditStats;
  final VoidCallback? onToggleActivated;

  /// Flips a toggleable token's active state straight from the tile (own models only).
  final void Function(api.Token token)? onToggleToken;
  final void Function(KnownSpell spell)? onToggleSpellCast;

  /// Removes this model from the gang. Only ever set on a summoned model of your own.
  final VoidCallback? onDismiss;

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
                // Stats keep their own row — the markers below never compress them into a column.
                Wrap(
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
                // Marker shelf: neutral counters then coloured player tokens, wrapping across as
                // many lines as they need instead of thinning into a single strip.
                if (_hasMarkers(state)) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ..._counterIcons(context, state),
                      for (final token in state.tokens)
                        TokenChip(
                          token: token,
                          // Tap toggles a toggleable token's active state right on the card (the
                          // frequent per-turn flip); everything else is handled in the Edit modal.
                          onTap: token.toggleable && onToggleToken != null
                              ? () => onToggleToken!(token)
                              : null,
                        ),
                    ],
                  ),
                ],
                // Bottom controls: Edit opens the counter/token modal; Activate is the fast
                // per-turn tap. Opponents show a read-only Activated marker only.
                if (onEditModel != null ||
                    onToggleActivated != null ||
                    onDismiss != null ||
                    activated) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (onDismiss != null) ...[
                        _DismissButton(onTap: onDismiss!),
                        const SizedBox(width: 8),
                      ],
                      const Spacer(),
                      if (onEditModel != null) ...[
                        _EditButton(onTap: onEditModel!),
                        const SizedBox(width: 8),
                      ],
                      if (onToggleActivated != null)
                        _ActivateButton(activated: activated, onTap: onToggleActivated!)
                      else if (activated)
                        const _ActivateButton(activated: true),
                    ],
                  ),
                ],
              ],
              if (_knownSpells.isNotEmpty) ...[
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

  // Whether the marker shelf has anything to show: an active counter or any player token.
  bool _hasMarkers(api.EntryState s) =>
      s.stunned ||
      s.hidden ||
      s.guarding ||
      s.carryingObjective ||
      s.underwaterCounters > 0 ||
      s.tokens.isNotEmpty;

  // Only the active counters appear — a counter set to false (or 0 underwater) is omitted
  // entirely, so a clean model shows no counter icons at all. Editing happens through the +
  // button next to them (own models only), not by tapping the icons themselves.
  List<Widget> _counterIcons(BuildContext context, api.EntryState state) {
    final l10n = AppLocalizations.of(context);
    return [
      if (state.stunned)
        _CounterIcon(
          asset: 'assets/images/counters/stunned.png',
          label: l10n.counterStunned,
          active: true,
        ),
      if (state.hidden)
        _CounterIcon(
          asset: 'assets/images/counters/hidden.png',
          label: l10n.counterHidden,
          active: true,
        ),
      if (state.guarding)
        _CounterIcon(
          asset: 'assets/images/counters/guard.png',
          label: l10n.counterGuarding,
          active: true,
        ),
      if (state.carryingObjective)
        _CounterIcon(
          asset: 'assets/images/counters/carry_objective.png',
          label: l10n.counterCarryingObjective,
          active: true,
        ),
      if (state.underwaterCounters > 0)
        _CounterIcon(
          asset: 'assets/images/counters/underwater_counter.png',
          label: l10n.counterUnderwater,
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

/// The "has this model gone yet?" control, spelled out. Solid-filled once activated. Activate and
/// Activated occupy the same fixed width with the bolt pinned left and the word centred, so flipping
/// it never nudges the layout. Rendered without an [onTap] for an opponent's models (read-only).
class _ActivateButton extends StatelessWidget {
  const _ActivateButton({required this.activated, this.onTap});

  final bool activated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fg = activated ? Colors.black87 : Colors.white;
    final button = Container(
      height: 34,
      width: 132,
      padding: const EdgeInsets.only(left: 12, right: 6),
      decoration: BoxDecoration(
        color: activated ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: activated ? 1 : 0.5),
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, size: 16, color: fg),
          Expanded(
            child: Text(
              activated ? l10n.actionActivated : l10n.actionActivate,
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return button;
    return GestureDetector(onTap: onTap, child: button);
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
