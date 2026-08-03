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
/// coloured disc. A *toggleable* token shows its on/off state and marks itself as toggleable: a
/// labelled one via a trailing status LED (lit on / hollow off), a dot-only one via a radio disc — a
/// ring that fills to a solid centre when on and empties when off. A toggled-off token also dims. The
/// colour stays a cue, so the stat pills stay the loudest thing on the row. [onTap] flips it.
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
    // Every dot-only token is a fixed circle; only a label makes the chip a pill.
    final circle = !hasText;

    // The dot-only disc. Static → a plain filled disc. Toggleable → a radio: a ring that fills to a
    // solid centre when on and empties when off — carrying both its on/off state and its "toggleable"
    // mark in one, so a dot-only token needs no separate LED.
    final Widget disc = !toggleable
        ? Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(shape: BoxShape.circle, color: swatch),
          )
        : Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: swatch, width: 2),
            ),
            child: active
                ? Center(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: swatch),
                    ),
                  )
                : null,
          );

    final Widget primary = hasText
        ? Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: swatch,
            ),
          )
        : disc;

    // Only a *labelled* toggleable token gets the trailing status LED (lit on / hollow off); a
    // dot-only one already carries its state in the radio disc above.
    final Widget? led = (hasText && toggleable)
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
        padding: EdgeInsets.symmetric(horizontal: circle ? 0 : 12),
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

    // A counter token carries a running total, shown as a corner badge in its own colour — the same
    // treatment as the underwater counter marker. Tapping the token opens a −/+ stepper.
    final count = token.count;
    final Widget body = count == null
        ? chip
        : Stack(
            clipBehavior: Clip.none,
            children: [
              chip,
              Positioned(
                right: -5,
                bottom: -4,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 17),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: swatch,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.35), width: 1),
                  ),
                  child: Text(
                    '$count',
                    style: GoogleFonts.cinzel(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );

    if (onTap == null) return body;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: body);
  }
}
