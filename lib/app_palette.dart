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

/// The app's single source of truth for brand colors.
///
/// These are the *primitive* tokens — the raw hues, named once. Theme-aware colors that resolve
/// by light/dark (text, backgrounds, etc.) live on the `AppColors` extension in app_colors.dart,
/// which re-exports this class so importing app_colors.dart is enough to reach both.
///
/// Change a value here and it changes everywhere that references it — that's the whole point.
abstract final class AppPalette {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const gold = Color(0xFFC4A050); // primary accent
  static const mutedGold = Color(
    0xFFB1986C,
  ); // dark-mode accent / border partner
  static const red = Color(0xFF8B1A1A); // light-mode accent partner
  static const brightRed = Color(
    0xFFC0392B,
  ); // stronger red (over-limit, destructive)
  static const antiqueGold = Color(
    0xFF8C6B2A,
  ); // secondary accent — dark theme (deeper gold)
  static const terracotta = Color(
    0xFFB5604D,
  ); // secondary accent — light theme (brighter red)

  // ── Neutrals — light ───────────────────────────────────────────────────────
  static const background = Color(0xFFF0EDE6); // scaffold (light)
  static const paper = Color(0xFFF5F2EE); // cards / panels (light)
  static const ink = Color(0xFF2C2418); // primary text (light)
  static const inkSubtle = Color(0xFF7A6E62); // secondary text (light)

  // ── Neutrals — dark ────────────────────────────────────────────────────────
  static const backgroundDark = Color(
    0xFF14171F,
  ); // scaffold / drawer / toast (dark)
  static const surfaceDark = Color(0xFF191D27); // raised cards / popups (dark)
  static const inkLight = Color(0xFFEDE8DF); // primary text (dark)
  static const inkLightSubtle = Color(0xFFAA9E92); // secondary text (dark)

  // ── Accents / misc ─────────────────────────────────────────────────────────
  static const equipment = Color(0xFF4A3F35); // equipment tiles

  /// A killed model's tile. The faction color drains away to a cold slate, so a dead model reads as
  /// *out of the game* rather than merely quiet — distinct from an activated model, which keeps its
  /// faction color and is only darkened.
  static const deadEntry = Color(0xFF33383F);
  static const toggleBlue = Color(0xFF6C9BC2); // settings theme-toggle accent
  static const controlNavyDark = Color(
    0xFF0E1828,
  ); // settings control surface (dark)

  // Stat-pill borders: [current-side, starting-side] gradient stops.
  static const hpBorder = [Color(0xFFCB9898), Color(0xFFA14343)];
  static const wpBorder = [Color(0xFF93AED2), Color(0xFF3B6BAE)];
  static const cpBorder = [Color(0xFF89AF97), Color(0xFF296E42)];

  // ── Factions ───────────────────────────────────────────────────────────────
  static const factionColors = <String, Color>{
    'doctors': Color(0xFF177282),
    'strigoi': Color(0xFF2a3d6e),
    'gifted': Color(0xFFb04510),
    'rashaar': Color(0xFF1a5a40),
    'patricians': Color(0xFF5a1a7a),
    'vatican': Color(0xFF8a6018),
    'guild': Color(0xFF831822),
  };

  static const factionIcons = <String, String>{
    'doctors': 'assets/images/icons/doctors icon.png',
    'gifted': 'assets/images/icons/gifted icon.png',
    'guild': 'assets/images/icons/guild icon.png',
    'patricians': 'assets/images/icons/patricians icon.png',
    'rashaar': 'assets/images/icons/rashaar icon.png',
    'strigoi': 'assets/images/icons/strigoi icon.png',
    'vatican': 'assets/images/icons/vatican icon.png',
  };

  /// The gradient behind a circular faction icon — the faction [color] raked toward black on the
  /// diagonal, so the badge reads as a lit disc rather than a flat one. Same ramp depth as
  /// [entryTileGradient], so a faction badge and a gang entry tile look like one family; the
  /// diagonal (rather than left-to-right) is what suits a circle.
  ///
  /// [opacity] fades the whole ramp for an unselected/dimmed state. It's applied to both stops
  /// rather than flattening the badge back to a single translucent color, so an unselected chip
  /// still reads as the same object, just quieter.
  static LinearGradient factionIconGradient(Color color, {double opacity = 1}) {
    final dark = Color.lerp(color, Colors.black, 0.45)!;
    return LinearGradient(
      colors: [
        color.withValues(alpha: opacity),
        dark.withValues(alpha: opacity),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// The left-to-right gradient behind a gang entry tile: the faction [color]
  /// fading toward black. Shared by the builder and viewer tiles (F-P2-4).
  ///
  /// [dimmed] darkens the whole ramp — used for a model that has already activated this turn. It
  /// deliberately darkens only the background, leaving the name, stats and counters on top at full
  /// strength: fading the entire tile would make the very content you still need to read (and the
  /// bolt you'd tap to undo it) the hardest thing on it.
  static LinearGradient entryTileGradient(Color color, {bool dimmed = false}) {
    final base = dimmed ? Color.lerp(color, Colors.black, 0.6)! : color;
    return LinearGradient(
      colors: [base, Color.lerp(base, Colors.black, 0.45)!],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }
}
