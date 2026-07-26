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
