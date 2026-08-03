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

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import 'themed_dialog_card.dart';

/// Popup showing an equipment item's name, cost and description. Shared by the gang builder and the
/// read-only gang viewer, which rendered byte-identical copies (F-P2-4).
void showEquipmentDetailDialog(BuildContext context, api.Equipment e) {
  showDialog(
    context: context,
    builder: (context) => ThemedDialogCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  e.name,
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${e.cost}',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: context.subtleTextColor.withValues(alpha: 0.3),
            thickness: 0.5,
          ),
          const SizedBox(height: 12),
          Text(
            e.description,
            style: TextStyle(
              fontSize: 13,
              color: context.textColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}
