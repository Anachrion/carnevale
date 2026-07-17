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
