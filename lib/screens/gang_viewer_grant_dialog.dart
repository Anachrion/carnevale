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

/// The modal opened by a grant model's tile button. One widget covers both kinds of grant (see
/// [GrantSource]): a **Mask** given to another friendly model once per game, and a per-round **choice**
/// a model makes on itself — both come down to picking an effect that drops a labelled token.
///
/// A Mask is a deliberate once-per-game act, so it's a two-step pick (target, then variant) behind a
/// Give button, and once given the modal shows who wears it with a Remove to undo a misclick. A choice
/// is a quick per-turn tap: each option applies immediately, replacing the model's previous pick.
class _GrantDialog extends StatefulWidget {
  const _GrantDialog({
    required this.gameId,
    required this.giver,
    required this.source,
    required this.targets,
    required this.current,
    required this.onStateChanged,
  });

  final int gameId;
  final api.ListEntry giver;
  final GrantSource source;

  /// Eligible mask targets (each with its profile), already filtered by [canWearMask]. Empty for a
  /// choice model (it always targets itself).
  final List<({api.ListEntry entry, api.Profile profile})> targets;

  /// The grant already on the board for this giver, paired with the model carrying it — null when
  /// nothing's been granted yet. Drives the mask "already given" summary and the Remove action, and
  /// highlights the current pick for a choice.
  final ({api.ListEntry carrier, api.Token token})? current;

  final void Function(int listEntryId, api.EntryState state) onStateChanged;

  @override
  State<_GrantDialog> createState() => _GrantDialogState();
}

class _GrantDialogState extends State<_GrantDialog> {
  bool _busy = false;

  /// Selected mask target (entry id) — null until picked. Unused for a choice.
  int? _targetId;

  /// Selected variant. Defaults to the only option when there's just one (Francisco's Oath), so a
  /// single-variant mask needs only a target picked before Give.
  late int _optionIndex = widget.source.options.length == 1 ? 0 : -1;

  /// A preview token for an effect label, rendered exactly as it will read on the tile.
  api.Token _preview(String effect) => api.Token(
    (b) => b
      ..id = 'preview'
      ..color = grantColor
      ..text = effect
      ..toggleable = false
      ..active = true,
  );

  // Drops (or replaces) the grant token on [targetEntryId] and closes. The token id encodes the giver,
  // so a choice re-pick overwrites the model's previous one in place. Mirrors the token mutations in
  // the Edit modal: busy-gated, echoes the new state to the tile, toasts on failure.
  Future<void> _apply(int targetEntryId, String effect) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final newState = await GameService().upsertToken(
        widget.gameId,
        targetEntryId,
        tokenId: grantTokenId(widget.giver.id),
        color: grantColor,
        text: effect,
        toggleable: false,
        active: true,
      );
      if (!mounted) return;
      widget.onStateChanged(targetEntryId, newState);
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        showAppToast(context, AppLocalizations.of(context).tokenUpdateFailed);
      }
    }
  }

  Future<void> _remove() async {
    final current = widget.current;
    if (current == null || _busy) return;
    setState(() => _busy = true);
    try {
      final newState = await GameService().removeToken(
        widget.gameId,
        current.carrier.id,
        current.token.id,
      );
      if (!mounted) return;
      widget.onStateChanged(current.carrier.id, newState);
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        showAppToast(context, AppLocalizations.of(context).tokenUpdateFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final source = widget.source;
    final given = widget.current != null;

    final Widget body;
    if (source.targetsOther && given) {
      body = _maskSummary(context, l10n);
    } else if (source.targetsOther) {
      body = _maskPicker(context, l10n);
    } else {
      body = _choicePicker(context, l10n);
    }

    return ThemedDialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The rule's own name (a proper noun — "Fanged Visage", "Split Personalities"), so the
          // modal reads as that specific ability rather than a generic "grant".
          Text(
            source.rule,
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
          Flexible(child: body),
        ],
      ),
    );
  }

  // Mask, already given: name who wears it and its effect, with Remove to undo and Done to close.
  Widget _maskSummary(BuildContext context, AppLocalizations l10n) {
    final current = widget.current!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          l10n.grantWornBy(current.carrier.name),
          style: GoogleFonts.cinzel(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.textColor,
          ),
        ),
        const SizedBox(height: 10),
        TokenChip(token: current.token.rebuild((b) => b.active = true)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _busy ? null : _remove,
              child: Text(
                l10n.actionRemove,
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w700,
                  color: AppPalette.brightRed,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.actionDone,
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w700,
                  color: context.accentColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Mask, not yet given: pick a target, then a variant (auto for a single-option mask), then Give.
  Widget _maskPicker(BuildContext context, AppLocalizations l10n) {
    if (widget.targets.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          l10n.grantNoTargets,
          style: TextStyle(fontSize: 13, color: context.subtleTextColor),
        ),
      );
    }
    final options = widget.source.options;
    final ready = _targetId != null && _optionIndex >= 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context, l10n.grantChooseTarget),
        // Only the target list scrolls — the effect picker and actions below stay pinned, so a long
        // eligible-target list (rare) never pushes them off-screen. Shrink-wrapped, so a short list
        // leaves the modal compact rather than always filling the height.
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              for (final t in widget.targets)
                _selectRow(
                  context,
                  selected: _targetId == t.entry.id,
                  onTap: () => setState(() => _targetId = t.entry.id),
                  child: Text(
                    t.entry.name,
                    style: GoogleFonts.cinzel(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        // A single-variant mask needs no effect list — the one effect is shown auto-selected.
        if (options.length > 1) ...[
          const SizedBox(height: 8),
          _sectionLabel(context, l10n.grantChooseEffect),
          for (var i = 0; i < options.length; i++)
            _selectRow(
              context,
              selected: _optionIndex == i,
              onTap: () => setState(() => _optionIndex = i),
              child: TokenChip(token: _preview(options[i])),
            ),
        ] else ...[
          const SizedBox(height: 10),
          TokenChip(token: _preview(options.first)),
        ],
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.actionCancel,
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w700,
                  color: context.subtleTextColor,
                ),
              ),
            ),
            TextButton(
              onPressed: (_busy || !ready)
                  ? null
                  : () => _apply(_targetId!, options[_optionIndex]),
              child: Text(
                l10n.grantGive,
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w700,
                  color: ready ? context.accentColor : context.subtleTextColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Choice model: each option applies on tap (replacing the previous pick). The current pick is
  // highlighted; Remove clears it. No target — a choice is always on the model itself.
  Widget _choicePicker(BuildContext context, AppLocalizations l10n) {
    final options = widget.source.options;
    final currentText = widget.current?.token.text;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 4),
            children: [
              _sectionLabel(context, l10n.grantChooseEffect),
              for (final effect in options)
                _selectRow(
                  context,
                  selected: currentText == effect,
                  onTap: _busy ? null : () => _apply(widget.giver.id, effect),
                  child: TokenChip(token: _preview(effect)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.current != null)
              TextButton(
                onPressed: _busy ? null : _remove,
                child: Text(
                  l10n.actionRemove,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    color: AppPalette.brightRed,
                  ),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.actionDone,
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w700,
                  color: context.accentColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 2),
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

  // A tappable row carrying [child] with a trailing selected/unselected indicator — the shared shape
  // for both target rows and effect rows.
  Widget _selectRow(
    BuildContext context, {
    required bool selected,
    required VoidCallback? onTap,
    required Widget child,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(child: child),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              size: 20,
              color: selected ? context.accentColor : context.subtleTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
