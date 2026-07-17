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

/// Popup opened by [_AddCounterButton]: lists all five counters with their current state;
/// tapping a row toggles it (underwater cycles 0 → 1 → 2 → 0) and saves immediately — no
/// confirm step, matching how quickly counters flip at the table. Every change lands on the
/// server before the row updates, so the popup never shows a state the opponent won't get.
class _CounterEditDialog extends StatefulWidget {
  const _CounterEditDialog({
    required this.gameId,
    required this.entry,
    required this.onStateChanged,
  });

  final int gameId;
  final api.ListEntry entry;
  final void Function(int listEntryId, api.EntryState state) onStateChanged;

  @override
  State<_CounterEditDialog> createState() => _CounterEditDialogState();
}

class _CounterEditDialogState extends State<_CounterEditDialog> {
  late api.EntryState _state = widget.entry.state!;
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
      if (mounted)
        showAppToast(
          context,
          'Could not update the counter. Please try again.',
        );
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
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a counter to toggle it.',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 12),
          Divider(
            color: context.subtleTextColor.withValues(alpha: 0.3),
            thickness: 0.5,
          ),
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
            badge: _state.underwaterCounters > 0
                ? _state.underwaterCounters
                : null,
            trailing: Text(
              '${_state.underwaterCounters} / 2',
              style: GoogleFonts.cinzel(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _state.underwaterCounters > 0
                    ? context.accentColor
                    : context.subtleTextColor,
              ),
            ),
            onTap: () => _update(
              underwaterCounters: (_state.underwaterCounters + 1) % 3,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Done',
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w700,
                  color: context.accentColor,
                ),
              ),
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
            _CounterIcon(
              asset: asset,
              label: label,
              active: active,
              badge: badge,
              foreground: context.textColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.cinzel(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textColor,
                ),
              ),
            ),
            trailing ??
                Icon(
                  active ? Icons.check_circle : Icons.circle_outlined,
                  size: 20,
                  color: active ? context.accentColor : context.subtleTextColor,
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
  const _StatEditDialog({
    required this.gameId,
    required this.entry,
    required this.onStateChanged,
  });

  final int gameId;
  final api.ListEntry entry;
  final void Function(int listEntryId, api.EntryState state) onStateChanged;

  @override
  State<_StatEditDialog> createState() => _StatEditDialogState();
}

class _StatEditDialogState extends State<_StatEditDialog> {
  late api.EntryState _state = widget.entry.state!;
  bool _busy = false;

  Future<void> _update({
    int? lifePoints,
    int? willPoints,
    int? commandPoints,
  }) async {
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
      if (mounted)
        showAppToast(context, 'Could not update the stat. Please try again.');
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
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Divider(
            color: context.subtleTextColor.withValues(alpha: 0.3),
            thickness: 0.5,
          ),
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
              child: Text(
                'Done',
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w700,
                  color: context.accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statStepperRow(
    BuildContext context, {
    required String label,
    required api.EntryStatValue value,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.cinzel(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.textColor,
              ),
            ),
          ),
          _stepperButton(
            context,
            icon: Icons.remove,
            // Can't drop below 0 (the server rejects it too); disabled at the floor.
            onTap: _busy || value.current <= 0
                ? null
                : () => onChanged(value.current - 1),
          ),
          Container(
            width: 56,
            alignment: Alignment.center,
            child: Text(
              '${value.current} / ${value.starting}',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
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

  Widget _stepperButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    final color = enabled
        ? context.textColor
        : context.subtleTextColor.withValues(alpha: 0.4);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? color.withValues(alpha: 0.5) : color,
            width: 1.2,
          ),
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
  const _CounterIcon({
    required this.asset,
    required this.label,
    required this.active,
    this.badge,
    this.foreground = Colors.white,
  });

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
          color: active
              ? context.accentColor.withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: active
              ? Border.all(color: context.accentColor, width: 1.4)
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: active ? 1.0 : 0.35,
              child: Image.asset(
                asset,
                width: 26,
                height: 26,
                color: foreground,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
            if (badge != null)
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: context.accentColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$badge',
                    style: GoogleFonts.cinzel(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The summon picker: search the whole catalog and conjure a model onto the board mid-game.
///
/// Deliberately unrestricted, unlike the gang builder's Hire tab (own faction + Gifted). A summoning
/// rule lives on the summoner's own card and routinely reaches outside the gang's faction — raising
/// the dead, calling up a spawn — so restricting the pool here would make legal summons impossible.
/// The app tracks the summon; the player adjudicates it.
class _SummonPickerDialog extends StatefulWidget {
  const _SummonPickerDialog({required this.gameId, required this.onSummoned});

  final int gameId;
  final void Function(api.ModelList gang) onSummoned;

  @override
  State<_SummonPickerDialog> createState() => _SummonPickerDialogState();
}

class _SummonPickerDialogState extends State<_SummonPickerDialog>
    with ProfileSearchMixin {
  final _service = ProfileService();
  List<api.Profile> _results = [];
  bool _loading = true;
  bool _busy = false;
  String? _error;

  /// Empty: the summon pool is the whole catalog, with no faction narrowing.
  @override
  Set<String> get searchFactions => const {};

  @override
  void onSearchChanged() => _results = _service.matching(searchQuery);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    disposeSearch();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _service.loadAll();
      if (!mounted) return;
      setState(() => _loading = false);
      applySearch();
    } catch (e) {
      // A cache-cold offline open used to hang on the spinner forever; show a retry instead (A-11).
      if (!mounted) return;
      setState(() {
        _error = e is ApiException ? e.message : 'Could not reach server';
        _loading = false;
      });
    }
  }

  Future<void> _summon(api.Profile profile) async {
    final refId = profile.cardReferenceId;
    // No printed card means nothing to put on the table.
    if (_busy || refId == null) return;
    setState(() => _busy = true);
    try {
      final gang = await GameService().summon(widget.gameId, refId);
      if (!mounted) return;
      widget.onSummoned(gang);
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        showAppToast(context, 'Could not summon that model. Please try again.');
      }
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
            'Summon a model',
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Any model may be summoned, from any faction. It costs no ducats.',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 12),
          buildSearchField(hintText: 'Search names, abilities, rules...'),
          if (pickedFacets.isNotEmpty) ...[
            const SizedBox(height: 8),
            buildFacetChips(),
          ],
          const SizedBox(height: 8),
          // Fixed height, not Expanded: the dialog's Column is mainAxisSize.min, so it has no bounded
          // height to divide up. The suggestions float over the results rather than pushing them
          // down, as they do everywhere else the catalog search appears.
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                _buildResults(context),
                if (hasSuggestions)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: buildSuggestions(),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w700,
                  color: context.accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: context.accentColor),
      );
    }
    if (_error != null) {
      return ErrorRetryView(message: _error!, onRetry: _load);
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No models found.',
          style: TextStyle(fontSize: 13, color: context.subtleTextColor),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemBuilder: (_, i) {
        final profile = _results[i];
        final color =
            AppPalette.factionColors[profile.faction] ?? context.accentColor;
        return Opacity(
          opacity: _busy ? 0.5 : 1,
          child: GestureDetector(
            onTap: () => _summon(profile),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppPalette.entryTileGradient(color),
                ),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        profile.name,
                        style: GoogleFonts.cinzel(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      profile.faction,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Confirms removing a summoned model. Worth a tap of friction: dismissing is destructive (the
/// model and everything tracked on it are gone), and the button sits right beside the counters you
/// tap constantly.
class _ConfirmDismissDialog extends StatelessWidget {
  const _ConfirmDismissDialog({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return ThemedDialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remove $name?',
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This summoned model leaves the board. Its wounds and counters go with it.',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    color: context.subtleTextColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Remove',
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    color: AppPalette.brightRed,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
