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
import '../app_colors.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.opaque = false,
  });

  final Widget child;

  /// Inner padding around [child]. Pass [EdgeInsets.zero] when the child manages its own insets
  /// (e.g. a `Material`/`InkWell` tappable row or a bare `TextField`).
  final EdgeInsetsGeometry padding;

  /// Paint a solid [AppColors.cardBgColor] base beneath the frosted gradient. Inline rows sit on
  /// the page and read fine at the default translucency, but a modal popup floats over a darkened
  /// scrim — in light theme the translucent cream then composites to a muddy grey. Opaque popups
  /// get a proper theme-correct surface (cream in light, near-black in dark) while keeping the
  /// ornamental gradient and border on top.
  final bool opaque;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: DecoratedBox(
          // Solid backing (opaque popups only), under the gradient below. A BoxDecoration can't
          // carry both a color and a gradient, so the two live on separate layers.
          decoration: BoxDecoration(
            color: opaque ? context.cardBgColor : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: context.panelGradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.panelBorderColor, width: 1.0),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
