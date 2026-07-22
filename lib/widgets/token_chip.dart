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

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_palette.dart';

/// The fixed, theme-independent swatch for a player-token colour — the same in light and dark,
/// chosen to read on any faction row (see AppPalette.token*).
Color tokenColor(api.TokenColorEnum color) => switch (color) {
      api.TokenColorEnum.crimson => AppPalette.tokenCrimson,
      api.TokenColorEnum.azure => AppPalette.tokenAzure,
      api.TokenColorEnum.teal => AppPalette.tokenTeal,
      api.TokenColorEnum.amethyst => AppPalette.tokenAmethyst,
      api.TokenColorEnum.fuchsia => AppPalette.tokenFuchsia,
      api.TokenColorEnum.pewter => AppPalette.tokenPewter,
      _ => AppPalette.tokenPewter,
    };

/// The palette offered when building a token, in display order.
const List<api.TokenColorEnum> kTokenPalette = [
  api.TokenColorEnum.crimson,
  api.TokenColorEnum.azure,
  api.TokenColorEnum.teal,
  api.TokenColorEnum.amethyst,
  api.TokenColorEnum.fuchsia,
  api.TokenColorEnum.pewter,
];

/// A player token as it renders on the model tile's marker shelf: a quiet neutral chip (matching the
/// counter markers). A *labelled* token shows its colour in the label; a *dot-only* token is the
/// coloured disc. A *toggleable* token also carries a small status LED — lit when on, a hollow ring
/// when off — which is what distinguishes it from a fixed marker; a toggled-off token additionally
/// dims. The colour stays a cue, so the stat pills remain the loudest thing on the row. [onTap]
/// flips a toggleable token's active state.
class TokenChip extends StatelessWidget {
  const TokenChip({super.key, required this.token, this.onTap});

  final api.Token token;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final swatch = tokenColor(token.color);
    final active = token.active;
    final toggleable = token.toggleable;
    final label = token.text ?? '';
    final hasText = label.isNotEmpty;
    // A static dot-only token stays a fixed circle; anything with a label or a toggle LED is a pill.
    final circle = !hasText && !toggleable;

    // Labelled → the coloured label; dot-only → the coloured disc. (A token is only ever off when it's
    // toggleable, so the disc stays the filled colour cue — the LED below carries the on/off state.)
    final Widget primary = hasText
        ? Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: swatch,
            ),
          )
        : Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(shape: BoxShape.circle, color: swatch),
          );

    // The toggle LED: lit (filled + faint glow) when on, a hollow ring when off. Present only on a
    // toggleable token — its absence is how a fixed marker reads as fixed.
    final Widget? led = toggleable
        ? Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? swatch : Colors.transparent,
              border: active ? null : Border.all(color: swatch, width: 1.5),
              boxShadow: active
                  ? [BoxShadow(color: swatch.withValues(alpha: 0.55), blurRadius: 5)]
                  : null,
            ),
          )
        : null;

    // Same quiet dark chip + hairline light border as the counter markers, so tokens and counters
    // read as one family. Only a genuinely toggled-off token dims — an active token stays full.
    final chip = Opacity(
      opacity: active ? 1 : 0.45,
      child: Container(
        height: 34,
        width: circle ? 34 : null,
        padding: EdgeInsets.symmetric(horizontal: circle ? 0 : (hasText ? 12 : 9)),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
        ),
        // mainAxisSize.min so a pill hugs its content instead of stretching the whole line.
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            primary,
            if (led != null) ...[const SizedBox(width: 7), led],
          ],
        ),
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: chip);
  }
}
