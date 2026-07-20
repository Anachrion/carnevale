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
