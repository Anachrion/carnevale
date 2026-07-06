import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'glass_panel.dart';

/// The rich gang row used on the Gangs tab and the in-game gang-selection step:
/// faction-coloured icon, list name, faction label, and cost/limit. Purely
/// presentational — callers supply a [trailing] widget (a chevron on the Gangs
/// tab, a Select button in-game) and, optionally, whole-card [onTap]/[onLongPress].
class GangTile extends StatelessWidget {
  const GangTile({
    super.key,
    required this.name,
    required this.faction,
    required this.totalCost,
    required this.points,
    required this.trailing,
    this.onTap,
    this.onLongPress,
    this.dimmed = false,
    this.footer,
  });

  final String? name;
  final String faction;
  final int totalCost;
  final int points;
  final Widget trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Optional content rendered on its own row below the main row, inside the same
  /// card (e.g. an actions row that appears when the tile is expanded).
  final Widget? footer;

  /// Fades the row's text/icon to signal it isn't currently actionable (e.g. an
  /// over-limit gang during selection).
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final factionColor = AppPalette.factionColors[faction] ?? AppPalette.gold;
    final iconPath = AppPalette.factionIcons[faction];
    final content = Opacity(
      opacity: dimmed ? 0.5 : 1,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: factionColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: iconPath != null
                ? Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                  )
                : const Icon(Icons.flag, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? '',
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _factionLabel(faction),
                  style: TextStyle(
                    fontSize: 12,
                    color: factionColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalCost',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.accentColor,
                ),
              ),
              Text(
                '/ $points',
                style: TextStyle(fontSize: 10, color: context.subtleTextColor),
              ),
            ],
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );

    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: footer == null
                ? content
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [content, footer!],
                  ),
          ),
        ),
      ),
    );
  }

  static String _factionLabel(String f) => f[0].toUpperCase() + f.substring(1);
}
