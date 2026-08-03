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

/// The shared top-of-screen header (F-P2-3): a drawer/menu button, a Cinzel title, and an optional
/// trailing widget (e.g. a "N profiles" count). Was copy-pasted across the cards, account, settings,
/// gangs and games screens.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.onMenu,
    this.onBack,
    this.trailing,
  }) : assert(
         onMenu != null || onBack != null,
         'ScreenHeader needs either onMenu (drawer) or onBack (pushed sub-page)',
       );

  final String title;

  /// Opens the drawer on a top-level destination. Mutually exclusive with [onBack]; when [onBack]
  /// is supplied the leading affordance becomes a back arrow instead of the hamburger.
  final VoidCallback? onMenu;

  /// Pops the current route on a pushed sub-page. When set, the leading button is a back arrow.
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              onBack != null ? Icons.arrow_back : Icons.menu,
              color: context.textColor,
            ),
            onPressed: onBack ?? onMenu,
          ),
          const SizedBox(width: 4),
          // Expanded rather than a fixed Text + Spacer: the title takes whatever room is left and
          // ellipsizes instead of overflowing, so a long title (or a narrow phone) can't push the
          // trailing count off the edge. Reads identically whenever there is room to spare.
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cinzel(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: context.textColor,
                letterSpacing: 3,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
