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
/// counter markers) carrying a small colour dot — the colour is a *cue*, not a fill, so the stat
/// pills stay the loudest thing on the row. No label → just the dot; a toggleable token that is off
/// dims to a hollow ring. [onTap] flips a toggleable token's active state.
class TokenChip extends StatelessWidget {
  const TokenChip({super.key, required this.token, this.onTap});

  final api.Token token;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final swatch = tokenColor(token.color);
    final active = token.active;
    final label = token.text ?? '';
    final hasText = label.isNotEmpty;

    final dot = Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? swatch : Colors.transparent,
        border: active ? null : Border.all(color: swatch, width: 2),
      ),
    );

    // Same quiet dark chip + hairline light border as the counter markers, so tokens and counters
    // read as one family. Only a genuinely toggled-off token dims — an active token stays full.
    final chip = Opacity(
      opacity: active ? 1 : 0.45,
      child: Container(
        height: 34,
        width: hasText ? null : 34,
        padding: EdgeInsets.symmetric(horizontal: hasText ? 11 : 0),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dot,
            if (hasText) ...[
              const SizedBox(width: 7),
              Text(
                label,
                style: GoogleFonts.cinzel(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: chip);
  }
}
