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
        GoogleFonts.ebGaramond(
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
