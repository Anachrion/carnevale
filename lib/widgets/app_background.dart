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
                  ? 'assets/images/bg_dark.png'
                  : 'assets/images/bg_light.png',
            ),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
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
