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
