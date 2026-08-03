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

/// Shared surface for the app's edit/detail popups: a rounded card that follows the app theme
/// (cream in light, cool near-black in dark) with a gold border, so popups feel native in both
/// themes rather than using a fixed color.
class ThemedDialogCard extends StatelessWidget {
  const ThemedDialogCard({super.key, required this.child, this.padding = const EdgeInsets.fromLTRB(24, 24, 24, 12)});

  final Widget child;

  /// Defaults to a shorter bottom inset, tuned for dialogs that end in a "Done" button (which
  /// carries its own padding); popups ending in plain content pass a symmetric inset instead.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: context.cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.accentColor.withValues(alpha: 0.6), width: 1.2),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
