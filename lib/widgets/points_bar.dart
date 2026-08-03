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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../l10n/app_localizations.dart';

/// The glass "N / limit ducats" panel with a progress bar beneath. Shared by
/// the gang builder ([editable]: shows how many ducats remain and turns red
/// once over budget) and the read-only game viewer (compact, faction-tinted
/// bar) — they rendered near-identical copies (F-P2-4).
class PointsBar extends StatelessWidget {
  const PointsBar({
    super.key,
    required this.used,
    required this.limit,
    required this.factionColor,
    this.editable = false,
  });

  final int used;
  final int limit;
  final Color factionColor;

  /// Builder mode: larger figures, a trailing "N left" counter, and over-budget
  /// red. The read-only viewer never exceeds its (frozen) limit.
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final ratio = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;
    final isOver = editable && used > limit;
    final barColor = isOver
        ? context.dangerColor
        : (editable ? context.accentColor : factionColor);
    final remaining = limit - used;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: context.panelGradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.panelBorderColor, width: 1.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$used',
                      style: GoogleFonts.cinzel(
                        fontSize: editable ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color: isOver ? context.dangerColor : context.textColor,
                      ),
                    ),
                    Text(
                      l10n.pointsBarSlashLimit(limit),
                      style: GoogleFonts.cinzel(
                        fontSize: editable ? 14 : 13,
                        color: context.subtleTextColor,
                      ),
                    ),
                    if (editable) ...[
                      const Spacer(),
                      Text(
                        isOver ? l10n.pointsBarOverBy(-remaining) : l10n.pointsBarLeft(remaining),
                        style: TextStyle(
                          fontSize: 12,
                          color: isOver
                              ? context.dangerColor
                              : context.subtleTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: Colors.black.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation(barColor),
                    minHeight: 6,
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
