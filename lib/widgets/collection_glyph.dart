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

import '../app_colors.dart';

/// How far along one miniature is. Ordered narrowest-last, the way the counts nest.
enum CollectionState { boxed, built, painted }

/// The collection glyph: a base, a figure standing on it, and a fill — the miniature itself.
///
/// It carries two jobs, and keeping them apart is what keeps the lists calm:
///
///  * [CollectionGlyph.mark] is **binary** — the solid figure, drawn only when the player owns at
///    least one. It appears in the search rows and in the "my collection" filter chip, the same
///    drawing in both so the connection is obvious. It never says how many, or in what state.
///  * [CollectionGlyph.new] draws one of the three [CollectionState]s, and appears only where all
///    three are being compared: the counter dialog, the Collection screen, the gang summary.
///
/// Colour is the caller's to supply, because the two surfaces this sits on want different answers:
/// faction tiles are saturated and dark in *both* themes, so they take the fixed ramp in
/// [tileColorFor]; themed panels take [surfaceColorFor], which resolves through the app's
/// theme-aware getters.
class CollectionGlyph extends StatelessWidget {
  const CollectionGlyph({
    super.key,
    required this.state,
    required this.color,
    this.size = 16,
  });

  /// The binary "in my collection" mark: one solid figure, one colour, no count.
  const CollectionGlyph.mark({super.key, required this.color, this.size = 16})
    : state = CollectionState.painted;

  final CollectionState state;
  final Color color;
  final double size;

  /// The ramp for a faction tile. Those are dark whatever the theme, so these are fixed: gold for
  /// the goal state, and the tile's own white-at-opacity vocabulary for the two before it.
  static Color tileColorFor(CollectionState state) => switch (state) {
    CollectionState.painted => AppPalette.mutedGold,
    CollectionState.built => Colors.white.withValues(alpha: 0.75),
    CollectionState.boxed => Colors.white.withValues(alpha: 0.45),
  };

  /// The ramp for a themed panel — a dialog or a glass surface, cream in light and near-black in
  /// dark. Routed through the accent getters so it flips with the theme like everything else.
  static Color surfaceColorFor(BuildContext context, CollectionState state) =>
      switch (state) {
        CollectionState.painted => context.accentColor,
        CollectionState.built => context.secondaryAccentColor,
        CollectionState.boxed => context.subtleTextColor,
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GlyphPainter(state: state, color: color)),
    );
  }
}

/// Draws the figure on a 24x24 grid, scaled to whatever the widget was given. Kept as paths rather
/// than an asset so it recolours with a single Paint and stays crisp at 14px in a list row.
class _GlyphPainter extends CustomPainter {
  const _GlyphPainter({required this.state, required this.color});

  final CollectionState state;
  final Color color;

  static const _grid = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _grid;
    canvas.scale(scale);

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // The base is always solid: owning the miniature is what every state has in common.
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(12, 20), width: 15, height: 4.8),
      fill,
    );

    final body = Path()
      ..moveTo(12, 9)
      ..cubicTo(9.4, 9, 7.8, 10.9, 7.4, 13.2)
      ..lineTo(6.4, 17.8)
      ..lineTo(17.6, 17.8)
      ..lineTo(16.8, 13.2)
      ..cubicTo(16.2, 10.9, 14.6, 9, 12, 9)
      ..close();
    const head = Offset(12, 6.2);
    const headRadius = 2.6;

    switch (state) {
      case CollectionState.boxed:
        // Nothing standing on the base yet: the figure is only a ghost of itself.
        final ghost = Paint()
          ..color = color.withValues(alpha: color.a * 0.22)
          ..style = PaintingStyle.fill;
        canvas.drawPath(body, ghost);
        canvas.drawCircle(head, headRadius, ghost);
      case CollectionState.built:
        final outline = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(body, outline);
        canvas.drawCircle(head, headRadius, outline);
      case CollectionState.painted:
        canvas.drawPath(body, fill);
        canvas.drawCircle(head, headRadius, fill);
    }
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.state != state || old.color != color;
}
