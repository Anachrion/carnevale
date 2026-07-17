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
