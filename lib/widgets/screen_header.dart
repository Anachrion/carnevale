import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

/// The shared top-of-screen header (F-P2-3): a drawer/menu button, a Cinzel title, and an optional
/// trailing widget (e.g. a "N profiles" count). Was copy-pasted across the cards, account, settings,
/// gangs and games screens.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.onMenu,
    this.trailing,
  });

  final String title;
  final VoidCallback onMenu;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: context.textColor),
            onPressed: onMenu,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: context.textColor,
              letterSpacing: 3,
            ),
          ),
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}
