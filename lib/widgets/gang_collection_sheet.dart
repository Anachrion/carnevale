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
import '../models/gang_collection_summary.dart';
import 'bottom_sheet_surface.dart';
import 'collection_glyph.dart';

/// Whether a gang can be put on the table with what the player actually owns (CARNEVALEB-76).
///
/// A sheet rather than a dialog: this presents a reading, it does not edit anything — and sheets
/// are what this app uses to present. The counting lives in [GangCollectionSummary]; everything
/// here is presentation.
Future<void> showGangCollectionSheet(
  BuildContext context, {
  required Iterable<api.ListEntry> entries,
  required List<api.Profile> profiles,
}) {
  final summary = GangCollectionSummary.of(
    entries: entries,
    profiles: profiles,
  );
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _GangCollectionSheet(summary: summary),
  );
}

class _GangCollectionSheet extends StatelessWidget {
  const _GangCollectionSheet({required this.summary});

  final GangCollectionSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (summary.total == 0) {
      return BottomSheetSurface(
        title: l10n.collectionGangTitle,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Text(
              l10n.collectionGangEmpty,
              style: TextStyle(fontSize: 14, color: context.subtleTextColor),
            ),
          ),
        ],
      );
    }

    return BottomSheetSurface(
      title: l10n.collectionGangTitle,
      scrollable: true,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.collectionGangTotal(summary.total),
                style: GoogleFonts.cinzel(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              const SizedBox(height: 12),
              _SummaryBar(summary: summary),
              const SizedBox(height: 20),
              _LegendRow(
                state: CollectionState.painted,
                label: l10n.collectionPainted,
                count: summary.painted,
              ),
              _LegendRow(
                state: CollectionState.built,
                label: l10n.collectionGangUnpainted,
                count: summary.unpainted,
              ),
              _LegendRow(
                state: CollectionState.boxed,
                label: l10n.collectionGangBoxed,
                count: summary.boxed,
              ),
              _LegendRow(
                state: null,
                label: l10n.collectionGangMissing,
                count: summary.missing,
              ),
              const SizedBox(height: 18),
              Divider(
                height: 1,
                thickness: 1,
                color: context.subtleTextColor.withValues(alpha: 0.25),
              ),
              const SizedBox(height: 16),
              if (summary.isComplete)
                Text(
                  l10n.collectionGangComplete,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.subtleTextColor,
                  ),
                )
              else ...[
                Text(
                  l10n.collectionGangShort(summary.missing),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: 10),
                for (final shortfall in summary.shortfalls)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            shortfall.name,
                            style: TextStyle(
                              fontSize: 13,
                              color: context.subtleTextColor,
                            ),
                          ),
                        ),
                        Text(
                          l10n.collectionGangOwnedOf(
                            shortfall.owned,
                            shortfall.hired,
                          ),
                          style: TextStyle(
                            fontSize: 13,
                            color: context.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// The gang as one bar. Segments are exclusive and proportional, so the eye reads the ratio of
/// ready-to-play to still-in-the-box directly off the width.
class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.summary});

  final GangCollectionSummary summary;

  @override
  Widget build(BuildContext context) {
    final segments = <(Color, int)>[
      (
        CollectionGlyph.surfaceColorFor(context, CollectionState.painted),
        summary.painted,
      ),
      (
        CollectionGlyph.surfaceColorFor(context, CollectionState.built),
        summary.unpainted,
      ),
      (
        CollectionGlyph.surfaceColorFor(context, CollectionState.boxed),
        summary.boxed,
      ),
      (context.dangerColor, summary.missing),
    ].where((segment) => segment.$2 > 0).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            for (final (index, (color, count)) in segments.indexed)
              Expanded(
                flex: count,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    // A hairline in the sheet's own colour between segments: the built gold and
                    // the painted gold are close enough that the boundary needs help.
                    border: index == segments.length - 1
                        ? null
                        : Border(
                            right: BorderSide(
                              color: context.cardBgColor,
                              width: 1.5,
                            ),
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

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.state,
    required this.label,
    required this.count,
  });

  /// Null for the "missing" row, which has no miniature to draw — it is the absence of one.
  final CollectionState? state;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final color = state == null
        ? context.dangerColor
        : CollectionGlyph.surfaceColorFor(context, state!);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: state == null
                ? Icon(Icons.close, size: 16, color: color)
                : CollectionGlyph(state: state!, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: context.textColor),
            ),
          ),
          Text(
            '$count',
            style: GoogleFonts.cinzel(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
