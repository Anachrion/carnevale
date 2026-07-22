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

/// Opened by the tile's Edit (pencil) button: one modal covering everything a model carries in
/// game. Three swipeable tabs — Generic (the built-in status counters), Custom (free-form player
/// tokens), and Predefined (deferred). Every change lands on the server before the row updates, so
/// the modal never shows a state the opponent won't get.
class _ModelEditDialog extends StatefulWidget {
  const _ModelEditDialog({
    required this.gameId,
    required this.entry,
    required this.onStateChanged,
  });

  final int gameId;
  final api.ListEntry entry;
  final void Function(int listEntryId, api.EntryState state) onStateChanged;

  @override
  State<_ModelEditDialog> createState() => _ModelEditDialogState();
}

class _ModelEditDialogState extends State<_ModelEditDialog> {
  late api.EntryState _state = widget.entry.state!;
  bool _busy = false;

  // Custom-token builder state.
  api.TokenColorEnum _newColor = kTokenPalette.first;
  final TextEditingController _labelCtrl = TextEditingController();
  bool _newToggleable = false;

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

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
      if (mounted) {
        showAppToast(
          context,
          AppLocalizations.of(context).counterToggleFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // Adds or removes a token and echoes the new state to the tile — mirrors _update for counters.
  Future<void> _mutateTokens(
    Future<api.EntryState> Function() call,
  ) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final newState = await call();
      if (!mounted) return;
      setState(() => _state = newState);
      widget.onStateChanged(widget.entry.id, newState);
    } catch (_) {
      if (mounted) {
        showAppToast(context, AppLocalizations.of(context).tokenUpdateFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addToken() async {
    final text = _labelCtrl.text.trim();
    await _mutateTokens(
      () => GameService().upsertToken(
        widget.gameId,
        widget.entry.id,
        tokenId: newIdempotencyKey(),
        color: _newColor,
        text: text.isEmpty ? null : text,
        toggleable: _newToggleable,
        active: true,
      ),
    );
    if (mounted) {
      setState(() {
        _labelCtrl.clear();
        _newToggleable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final media = MediaQuery.of(context);
    // Shrink the tab body when the keyboard is open so the dialog card never overflows (each tab's
    // own list scrolls within it). ~300 covers the title, tab bar, Done, and card/dialog padding.
    final tabHeight = (media.size.height - media.viewInsets.bottom - 280)
        .clamp(160.0, 440.0);
    return DefaultTabController(
      length: 3,
      child: ThemedDialogCard(
        // Tapping any empty area of the modal drops the keyboard (the label field opens one).
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
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
            const SizedBox(height: 8),
            TabBar(
              labelColor: context.accentColor,
              unselectedLabelColor: context.subtleTextColor,
              indicatorColor: context.accentColor,
              labelStyle: GoogleFonts.cinzel(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 6),
              tabs: [
                Tab(text: l10n.tokenTabGeneric),
                Tab(text: l10n.tokenTabCustom),
                Tab(text: l10n.tokenTabPredefined),
              ],
            ),
            SizedBox(
              height: tabHeight,
              child: TabBarView(
                children: [
                  _genericTab(context, l10n),
                  _customTab(context, l10n),
                  _predefinedTab(context, l10n),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.actionDone,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    color: context.accentColor,
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

  // Generic tab: the built-in status counters (the old counter popup, folded in).
  Widget _genericTab(BuildContext context, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.only(top: 4),
      children: [
        _counterRow(
          context,
          asset: 'assets/images/counters/stunned.png',
          label: l10n.counterStunned,
          active: _state.stunned,
          onTap: () => _update(stunned: !_state.stunned),
        ),
        _counterRow(
          context,
          asset: 'assets/images/counters/hidden.png',
          label: l10n.counterHidden,
          active: _state.hidden,
          onTap: () => _update(hidden: !_state.hidden),
        ),
        _counterRow(
          context,
          asset: 'assets/images/counters/guard.png',
          label: l10n.counterGuarding,
          active: _state.guarding,
          onTap: () => _update(guarding: !_state.guarding),
        ),
        _counterRow(
          context,
          asset: 'assets/images/counters/carry_objective.png',
          label: l10n.counterCarryingObjective,
          active: _state.carryingObjective,
          onTap: () => _update(carryingObjective: !_state.carryingObjective),
        ),
        _counterRow(
          context,
          asset: 'assets/images/counters/underwater_counter.png',
          label: l10n.counterUnderwater,
          active: _state.underwaterCounters > 0,
          badge: _state.underwaterCounters > 0 ? _state.underwaterCounters : null,
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
      ],
    );
  }

  // Custom tab: the model's player tokens (manage) plus a builder (colour + optional label +
  // toggleable). No per-token switch here — a token is toggled on the card.
  Widget _customTab(BuildContext context, AppLocalizations l10n) {
    final tokens = _state.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The model's current tokens — the only scrollable part, so the builder below never
        // scrolls out of reach however many tokens the model carries.
        Expanded(
          child: tokens.isEmpty
              ? Center(
                  child: Text(
                    l10n.tokenNoneYet,
                    style: TextStyle(fontSize: 12, color: context.subtleTextColor),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.only(top: 4),
                  children: [
                    _sectionLabel(context, l10n.tokenSectionOnModel),
                    for (final t in tokens) _tokenRow(context, l10n, t),
                  ],
                ),
        ),
        Divider(
          color: context.subtleTextColor.withValues(alpha: 0.3),
          thickness: 0.5,
          height: 16,
        ),
        // New-token builder — pinned, always visible. Two compact lines: colour + label, then the
        // toggleable flag + Add, so the list above keeps most of the room.
        _sectionLabel(context, l10n.tokenSectionNew),
        Row(
          children: [
            // A single swatch of the chosen colour; tapping it opens the palette picker.
            _colorSpot(context, l10n),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _labelCtrl,
                textCapitalization: TextCapitalization.characters,
                style: GoogleFonts.cinzel(fontSize: 13, color: context.textColor),
                decoration: InputDecoration(
                  hintText: l10n.tokenLabelHint,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                  hintStyle: TextStyle(color: context.subtleTextColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                      color: context.subtleTextColor.withValues(alpha: 0.4),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: context.accentColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _newToggleable = !_newToggleable),
                child: Row(
                  children: [
                    Icon(
                      _newToggleable
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                      color: _newToggleable
                          ? context.accentColor
                          : context.subtleTextColor,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.tokenToggleable,
                        style: GoogleFonts.cinzel(
                          fontSize: 12,
                          color: context.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: _busy ? null : _addToken,
              style: TextButton.styleFrom(
                backgroundColor: context.accentColor,
                foregroundColor: context.cardBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              ),
              child: Text(
                l10n.tokenAdd,
                style: GoogleFonts.cinzel(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _predefinedTab(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          l10n.tokenPredefinedSoon,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: context.subtleTextColor),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.cinzel(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: context.subtleTextColor,
      ),
    ),
  );

  // The colour cell in the builder's first line — the chosen colour with a small caret hinting it's
  // tappable; opens the palette picker.
  Widget _colorSpot(BuildContext context, AppLocalizations l10n) => GestureDetector(
    onTap: _pickColor,
    child: Container(
      width: 46,
      height: 46,
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: tokenColor(_newColor),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: context.subtleTextColor.withValues(alpha: 0.4)),
      ),
      child: Icon(
        Icons.arrow_drop_down,
        size: 18,
        color: Colors.white.withValues(alpha: 0.9),
      ),
    ),
  );

  Future<void> _pickColor() async {
    FocusScope.of(context).unfocus();
    final picked = await showDialog<api.TokenColorEnum>(
      context: context,
      builder: (ctx) => ThemedDialogCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel(ctx, AppLocalizations.of(ctx).tokenColorLabel),
            const SizedBox(height: 4),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final c in kTokenPalette)
                  GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(c),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tokenColor(c),
                        border: Border.all(
                          color: c == _newColor
                              ? context.accentColor
                              : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _newColor = picked);
  }

  Widget _tokenRow(BuildContext context, AppLocalizations l10n, api.Token token) {
    final hasText = (token.text ?? '').isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tokenColor(token.color),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              hasText ? token.text! : l10n.tokenNoLabel,
              style: GoogleFonts.cinzel(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: hasText ? context.textColor : context.subtleTextColor,
              ),
            ),
          ),
          if (token.toggleable) ...[
            Text(
              l10n.tokenToggleable,
              style: GoogleFonts.cinzel(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: context.subtleTextColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _busy
                ? null
                : () => _mutateTokens(
                    () => GameService().removeToken(
                      widget.gameId,
                      widget.entry.id,
                      token.id,
                    ),
                  ),
            icon: Icon(Icons.close, size: 18, color: context.subtleTextColor),
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
/// omitted for models that never had them, i.e. starting 0). Taps update the value instantly and
/// can't push a stat below 0; the change echoes to both players. Only the model's own player can
/// open it (the opponent's pills aren't tappable). Edits apply optimistically and the new absolute
/// value is saved ~1s after the last tap (immediately at 0 HP, which starts the server's death
/// handling), so knocking a model down several HP is one request, not one per tap.
class _StatEditDialog extends StatefulWidget {
  const _StatEditDialog({
    required this.gameId,
    required this.entry,
    required this.onStateChanged,
    required this.onCommit,
  });

  final int gameId;
  final api.ListEntry entry;
  // Echoes each optimistic change to the tile behind the dialog, instantly.
  final void Function(int listEntryId, api.EntryState state) onStateChanged;
  // Persists the debounced final value. Owned by the parent (which outlives the dialog) so a change
  // still pending when the dialog closes can still be saved — and rolled back with a toast if it
  // fails. Returns the authoritative state: the server's on success, or `confirmed` after a revert.
  final Future<api.EntryState> Function(
    int entryId,
    api.EntryState target,
    api.EntryState confirmed,
  )
  onCommit;

  @override
  State<_StatEditDialog> createState() => _StatEditDialogState();
}

class _StatEditDialogState extends State<_StatEditDialog> {
  // `_state` is the optimistic value shown/edited right now; `_confirmed` is the last state the
  // server acknowledged and the value we roll back to if a save fails.
  late api.EntryState _state = widget.entry.state!;
  late api.EntryState _confirmed = widget.entry.state!;
  Timer? _debounce;
  bool _dirty = false; // an edit not yet sent to the server

  @override
  void dispose() {
    _debounce?.cancel();
    // A change still pending at close: hand it to the parent, which outlives the dialog and can roll
    // it back + toast if it fails. Fire-and-forget — there's no dialog left to await it.
    if (_dirty) widget.onCommit(widget.entry.id, _state, _confirmed);
    super.dispose();
  }

  void _onChanged({int? lifePoints, int? willPoints, int? commandPoints}) {
    setState(() {
      _state = _state.rebuild((b) {
        if (lifePoints != null) b.lifePoints.current = lifePoints;
        if (willPoints != null) b.willPoints.current = willPoints;
        if (commandPoints != null) b.commandPoints.current = commandPoints;
        // Death is derived from HP, so mirror it optimistically — a model revives (or drops) the
        // instant its HP crosses 0, without waiting on the round-trip. The server's own death
        // handling still lands on the commit.
        b.dead = b.lifePoints.current == 0;
      });
    });
    widget.onStateChanged(widget.entry.id, _state); // tile updates instantly
    _dirty = true;
    _debounce?.cancel();
    // A model dropping to 0 HP triggers the server's death handling, so don't sit on it — save now
    // rather than after the debounce. Otherwise collapse a burst of taps into a single write.
    if (_state.lifePoints.current == 0) {
      _commit();
    } else {
      _debounce = Timer(const Duration(milliseconds: 900), _commit);
    }
  }

  Future<void> _commit() async {
    if (!_dirty) return;
    _dirty = false;
    _debounce?.cancel();
    final target = _state;
    final result = await widget.onCommit(widget.entry.id, target, _confirmed);
    _confirmed = result;
    // Adopt the server's authoritative state (e.g. death-derived fields) only if nothing changed
    // while the write was in flight, so a newer optimistic edit isn't clobbered.
    if (mounted && !_dirty) setState(() => _state = result);
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
            label: AppLocalizations.of(context).statLifePoints,
            value: _state.lifePoints,
            onChanged: (v) => _onChanged(lifePoints: v),
          ),
          if (_state.willPoints.starting > 0)
            _statStepperRow(
              context,
              label: AppLocalizations.of(context).statWillPoints,
              value: _state.willPoints,
              onChanged: (v) => _onChanged(willPoints: v),
            ),
          if (_state.commandPoints.starting > 0)
            _statStepperRow(
              context,
              label: AppLocalizations.of(context).statCommandPoints,
              value: _state.commandPoints,
              onChanged: (v) => _onChanged(commandPoints: v),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).actionDone,
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
            onTap: value.current <= 0 ? null : () => onChanged(value.current - 1),
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
            onTap: () => onChanged(value.current + 1),
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

  // Non-recruitable models (the Emissary's Tentacles) can't be summoned either — they only arrive
  // with the model that brings them (CARNEVALEB-23) — so they're dropped from the pool.
  @override
  void onSearchChanged() =>
      _results = _service.matching(searchQuery).where((p) => p.recruitable).toList();

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
        _error = e is ApiException ? e.message : AppLocalizations.of(context).errorCouldNotReachServer;
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
        showAppToast(context, AppLocalizations.of(context).summonFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tapping anywhere in the dialog that isn't itself a focusable/tappable control drops
    // keyboard focus, hiding the suggestions panel with it — a real tap directly on the search
    // field or Cancel still wins its own gesture. Tapping back into the field brings both
    // straight back.
    return ThemedDialogCard(
      child: dismissSearchFocusOnTapOutside(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).summonTitle,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context).summonBlurb,
              style: TextStyle(fontSize: 12, color: context.subtleTextColor),
            ),
            const SizedBox(height: 12),
            buildSearchField(
              hintText: AppLocalizations.of(context).summonSearchHint,
            ),
            if (pickedFacets.isNotEmpty) ...[
              const SizedBox(height: 8),
              buildFacetChips(),
            ],
            const SizedBox(height: 8),
            // Fixed height, not Expanded: the dialog's Column is mainAxisSize.min, so it has no
            // bounded height to divide up. The suggestions float over the results rather than
            // pushing them down, as they do everywhere else the catalog search appears.
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
                  AppLocalizations.of(context).actionCancel,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    color: context.accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
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
          AppLocalizations.of(context).summonNoModels,
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
    final l10n = AppLocalizations.of(context);
    return ThemedDialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dismissTitle(name),
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.dismissBody,
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  l10n.actionCancel,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    color: context.subtleTextColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  l10n.actionRemove,
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
