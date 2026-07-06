import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

/// The app's shared gold-underline [InputDecoration] (F-P2-3): a subtle-gold enabled underline that
/// brightens to solid gold on focus. Was re-inlined across the auth, gang and game forms (the old
/// per-screen `_decoration(label)` helpers).
InputDecoration goldInputDecoration(
  BuildContext context, {
  String? label,
  String? hint,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: GoogleFonts.notoSans(
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
      borderSide: BorderSide(color: AppPalette.gold.withValues(alpha: 0.5)),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppPalette.gold, width: 1.5),
    ),
  );
}
