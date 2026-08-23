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

import 'package:flutter/material.dart';

import '../app_colors.dart';

/// The seven faction toggles, sized to fit the screen rather than scrolling. They used to be
/// fixed-width chips in a horizontal ListView, which overflowed on a narrow phone and pushed
/// Rashaar — the last one — off the edge, behind a sideways scroll nobody thinks to try on a
/// filter row. A filter you can't see is a filter you don't know you have, so they shrink
/// together instead, down to the point where all seven still fit.
///
/// Extracted from the Cards screen when the Collection screen wanted the same row (CARNEVALEB-76);
/// the sizing arithmetic is the part worth having in one place.
class FactionFilterRow extends StatelessWidget {
  const FactionFilterRow({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  /// The faction slugs currently picked. Empty means "all factions", not "none".
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  static const factions = [
    'guild',
    'doctors',
    'vatican',
    'patricians',
    'strigoi',
    'gifted',
    'rashaar',
  ];

  @override
  Widget build(BuildContext context) {
    const gap = 8.0;
    const padding = 16.0;
    const maxDiameter = 48.0;
    // Floor, so they stay a usable tap target. Seven of these plus the gaps need ~276px, which
    // clears even the narrowest phones in circulation — so the row never overflows in practice.
    const minDiameter = 28.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth - padding * 2;
        final diameter =
            ((available - gap * (factions.length - 1)) / factions.length).clamp(
              minDiameter,
              maxDiameter,
            );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: SizedBox(
            height: diameter + 12,
            child: Row(
              spacing: gap,
              children: [
                for (final faction in factions)
                  _FactionIconChip(
                    faction: faction,
                    diameter: diameter,
                    selected: selected.contains(faction),
                    onTap: () => onToggle(faction),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FactionIconChip extends StatelessWidget {
  const _FactionIconChip({
    required this.faction,
    required this.diameter,
    required this.selected,
    required this.onTap,
  });
  final String faction;

  /// Set by the filter row, which divides the screen width across the seven factions so they all
  /// stay visible. Spacing is the row's job, so the chip carries no margin of its own.
  final double diameter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppPalette.factionColors[faction] ?? context.accentColor;
    final iconPath = AppPalette.factionIcons[faction]!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppPalette.factionIconGradient(
            color,
            opacity: selected ? 1 : 0.5,
          ),
        ),
        // Scales with the chip, so the glyph keeps its proportions as the row tightens.
        padding: EdgeInsets.all(diameter / 12),
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.35),
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}
