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
import 'app_palette.dart';

// Re-exported so a single `import '../app_colors.dart'` reaches both the theme-aware getters
// below and the raw AppPalette tokens.
export 'app_palette.dart';

/// Theme-aware semantic colors: these resolve to a light or dark [AppPalette] token based on the
/// current brightness. Prefer these over reaching for a raw palette token when a value should
/// flip between themes.
extension AppColors on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get textColor => _isDark ? AppPalette.inkLight : AppPalette.ink;

  Color get subtleTextColor => _isDark ? AppPalette.inkLightSubtle : AppPalette.inkSubtle;

  /// The primary brand accent, theme-aware: pale gold on the dark theme, deep red on the light
  /// theme (the `gold`/`red` pairing used across the app).
  Color get accentColor => _isDark ? AppPalette.gold : AppPalette.red;

  /// The secondary brand accent, theme-aware and derived one step from [accentColor]: deep
  /// antique gold on dark, brick terracotta on light. For a second tier that stays in the
  /// primary's family without colliding with the destructive `brightRed`.
  Color get secondaryAccentColor => _isDark ? AppPalette.antiqueGold : AppPalette.terracotta;

  /// Destructive / error signal — over-limit points, delete actions, validation errors. Kept
  /// constant across themes: the stronger `brightRed` reads as "warning" against either accent
  /// (and, in light theme, stays distinct from the deep-red [accentColor]).
  Color get dangerColor => AppPalette.brightRed;

  Color get cardBgColor => _isDark ? AppPalette.surfaceDark : AppPalette.paper;

  /// Scaffold / drawer background.
  Color get backgroundColor => _isDark ? AppPalette.backgroundDark : AppPalette.background;

  /// The frosted "glass panel" gradient shared by GlassPanel and the various points/summary bars.
  /// The two color stops are intentional gradient endpoints (top→bottom) — kept as a pair, never
  /// collapsed: light is translucent paper, dark is a soft black scrim.
  LinearGradient get panelGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: _isDark
            ? const [Color(0x10000000), Color(0x88000000)]
            : [AppPalette.paper.withValues(alpha: 0.30), AppPalette.paper.withValues(alpha: 0.75)],
      );

  /// The hairline border that pairs with [panelGradient].
  Color get panelBorderColor =>
      _isDark ? AppPalette.mutedGold.withValues(alpha: 0.45) : Colors.white.withValues(alpha: 0.30);
}
