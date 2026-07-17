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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

/// The shared modal-bottom-sheet chrome (F-P2-3): keyboard-inset padding, a frosted rounded-top
/// surface, the little drag handle and an optional Cinzel title. Was duplicated across the
/// create-game, join-game, game-action and new-gang sheets.
class BottomSheetSurface extends StatelessWidget {
  const BottomSheetSurface({
    super.key,
    required this.children,
    this.title,
    this.scrollable = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;

  /// Optional heading rendered under the drag handle.
  final String? title;

  /// Wrap the content in a [SingleChildScrollView] (for sheets with text fields that grow past the
  /// viewport when the keyboard is up).
  final bool scrollable;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.subtleTextColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (title != null) ...[
          Text(
            title!,
            style: GoogleFonts.cinzel(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: context.textColor,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
        ],
        ...children,
      ],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: context.cardBgColor.withValues(alpha: 0.92),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: scrollable ? SingleChildScrollView(child: content) : content,
          ),
        ),
      ),
    );
  }
}
