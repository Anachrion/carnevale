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

  Color get cardBgColor => _isDark ? AppPalette.surfaceDark : AppPalette.paper;

  /// Scaffold / drawer background.
  Color get backgroundColor => _isDark ? AppPalette.backgroundDark : AppPalette.background;
}
