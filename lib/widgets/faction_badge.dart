import 'package:flutter/material.dart';
import '../app_palette.dart';

/// The circular, faction-colored icon badge shown beside a gang's name. Shared
/// by the gang builder header and the read-only viewer header, which rendered
/// near-identical copies at different sizes (F-P2-4).
class FactionBadge extends StatelessWidget {
  const FactionBadge({
    super.key,
    required this.faction,
    required this.color,
    this.size = 32,
  });

  final String? faction;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconPath = AppPalette.factionIcons[faction];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      padding: EdgeInsets.all(size * 0.19),
      child: iconPath != null
          ? Image.asset(
              iconPath,
              fit: BoxFit.contain,
              color: Colors.white,
              colorBlendMode: BlendMode.srcIn,
            )
          : Icon(Icons.flag, color: Colors.white, size: size * 0.5),
    );
  }
}
