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

/// A pill-shaped sort toggle: tap to select, tap again to flip direction (an
/// up/down arrow shows the current direction while selected). Shared by the
/// cards browser and the gang builder's hire tab, which rendered byte-identical
/// copies (F-P2-4).
class SortChip extends StatelessWidget {
  const SortChip({
    super.key,
    required this.label,
    required this.selected,
    required this.ascending,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool ascending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? accent : Colors.white.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : context.subtleTextColor,
                letterSpacing: 0.5,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 3),
              Icon(
                ascending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 10,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Resolves a tap on a [SortChip]: if [tapped] is already the [current] sort
/// field, flip the direction; otherwise switch to [tapped], ascending. Returns
/// the new `(field, ascending)`. Collapses the asc/desc-flip logic that was
/// copy-pasted behind every sort control (F-P2-4).
(T, bool) applySortTap<T>(T tapped, T current, bool ascending) =>
    tapped == current ? (current, !ascending) : (tapped, true);
