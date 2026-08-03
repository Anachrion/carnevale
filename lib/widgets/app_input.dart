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
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

/// The app's shared accent-underline [InputDecoration] (F-P2-3): a subtle accent enabled underline
/// that brightens to the solid accent on focus (theme-aware — gold on dark, deep red on light).
/// Was re-inlined across the auth, gang and game forms (the old per-screen `_decoration(label)`
/// helpers).
InputDecoration goldInputDecoration(
  BuildContext context, {
  String? label,
  String? hint,
  TextStyle? labelStyle,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle:
        labelStyle ??
        GoogleFonts.cinzel(
          color: context.subtleTextColor,
          fontSize: 13,
        ),
    hintStyle: hint == null
        ? null
        : TextStyle(
            color: context.subtleTextColor.withValues(alpha: 0.6),
            fontSize: 15,
          ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: context.accentColor.withValues(alpha: 0.5)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: context.accentColor, width: 1.5),
    ),
  );
}
