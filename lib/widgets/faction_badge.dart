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
      decoration: BoxDecoration(
        gradient: AppPalette.factionIconGradient(color),
        shape: BoxShape.circle,
      ),
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
