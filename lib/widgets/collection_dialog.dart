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

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/collection_service.dart';
import 'app_toast.dart';
import 'collection_glyph.dart';
import 'themed_dialog_card.dart';

/// Steps one model's collection counts (CARNEVALEB-76).
///
/// Deliberately the same surface as the in-game WP/CP editor — [ThemedDialogCard], 34px circular
/// steppers, a "Done" that just closes: this is the app's established way to nudge a counter on a
/// model, and a second component doing the same job would only be a second thing to keep in step.
/// One dialog serves both the card viewer and the Collection screen.
///
/// Painted sits at the top because it sits at the top of the hierarchy: the counts read downward
/// from the narrowest, and the hint below explains what happens when one of them is lowered.
Future<void> showCollectionDialog(BuildContext context, api.Profile profile) {
  return showDialog<void>(
    context: context,
    builder: (_) => _CollectionDialog(profile: profile),
  );
}

class _CollectionDialog extends StatelessWidget {
  const _CollectionDialog({required this.profile});

  final api.Profile profile;

  Future<void> _step(
    BuildContext context,
    CollectionCount count,
    int value,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await CollectionService().setCount(profile.id, count, value);
    if (!ok && context.mounted) {
      showAppToast(context, l10n.collectionSaveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ThemedDialogCard(
      child: ListenableBuilder(
        listenable: CollectionService(),
        builder: (context, _) {
          final entry = CollectionService().entryFor(profile.id);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
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
              _CountRow(
                state: CollectionState.painted,
                label: l10n.collectionPainted,
                value: entry.painted,
                onChanged: (v) => _step(context, CollectionCount.painted, v),
              ),
              _CountRow(
                state: CollectionState.built,
                label: l10n.collectionBuilt,
                value: entry.built,
                onChanged: (v) => _step(context, CollectionCount.built, v),
              ),
              _CountRow(
                state: CollectionState.boxed,
                label: l10n.collectionOwned,
                value: entry.owned,
                onChanged: (v) => _step(context, CollectionCount.owned, v),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.collectionNestingHint,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.45,
                  color: context.subtleTextColor,
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
          );
        },
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({
    required this.state,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final CollectionState state;
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CollectionGlyph(
            state: state,
            color: CollectionGlyph.surfaceColorFor(context, state),
          ),
          const SizedBox(width: 10),
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
          _StepperButton(
            icon: Icons.remove,
            // Nothing below zero; the server refuses it too.
            onTap: value <= 0 ? null : () => onChanged(value - 1),
          ),
          SizedBox(
            width: 44,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
          ),
          _StepperButton(icon: Icons.add, onTap: () => onChanged(value + 1)),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
