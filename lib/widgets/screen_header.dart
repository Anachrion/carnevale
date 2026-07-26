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
