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

/// The shared full-screen background: the themed bg image, an optional blurred scrim, and (by
/// default) a SafeArea around the content. Extracted from the ~25-line scaffold that was
/// copy-pasted across ~10 screens (F-P2-3).
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.blurScrim = true,
    this.safeArea = true,
  });

  final Widget child;

  /// Whether to lay a blurred translucent scrim over the background image (most screens do; the
  /// home screen shows the artwork unscrimmed).
  final bool blurScrim;

  /// Whether to wrap [child] in a SafeArea (off for screens that manage their own insets).
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDark
                  ? 'assets/images/bg_dark.webp'
                  : 'assets/images/bg_light.webp',
            ),
            fit: BoxFit.cover,
            // Center crop: the bg artwork is a 1:1 square (canal centered). In portrait,
            // cover crops the sides (full height shown). In landscape, cover crops top &
            // bottom — centering keeps the horizon/canal band visible instead of only sky.
            alignment: Alignment.center,
          ),
        ),
        child: Stack(
          children: [
            if (blurScrim)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(color: Colors.black.withValues(alpha: 0.05)),
                ),
              ),
            safeArea ? SafeArea(child: child) : child,
          ],
        ),
      ),
    );
  }
}
