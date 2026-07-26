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
import 'glass_panel.dart';

/// A glass-panel row with a left-aligned [label] and a trailing [child] control, used to lay out
/// individual settings entries. Shared by the Settings and Account settings screens.
class SettingRow extends StatelessWidget {
  const SettingRow({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: context.textColor,
            ),
          ),
          const Spacer(),
          child,
        ],
      ),
    );
  }
}

/// A full-width, frosted-glass action button with an icon and label, tinted by [color]. Pass a
/// separate [tintColor] to gradient-fill with a different hue than the border/label (e.g. a red
/// wash on an accent-bordered "Log out"). Shows a spinner instead of the label while [loading].
class GlassActionButton extends StatelessWidget {
  const GlassActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.tintColor,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color? tintColor;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = tintColor ?? color;
    // Give the button a near-opaque base (a dark navy in dark mode, a light paper in light mode) so
    // the busy background no longer bleeds through, then layer the accent [tint] over it for hue.
    // Earlier this was a bare 6–30%-alpha tint with the label drawn in the accent [color] — readable
    // enough in gold, but a low-contrast muddle for the steel-blue actions. The label now uses the
    // high-contrast text color; the accent survives in the icon, border and fill tint.
    final baseTop = isDark
        ? const Color(0xD90D1622)
        : Colors.white.withValues(alpha: 0.74);
    final baseBottom = isDark
        ? const Color(0xF20D1622)
        : Colors.white.withValues(alpha: 0.90);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.alphaBlend(
                      tint.withValues(alpha: isDark ? 0.16 : 0.12),
                      baseTop,
                    ),
                    Color.alphaBlend(
                      tint.withValues(alpha: isDark ? 0.32 : 0.22),
                      baseBottom,
                    ),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.7),
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: loading
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: color,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: GoogleFonts.cinzel(
                            color: context.textColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
