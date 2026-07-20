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

import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../l10n/app_localizations.dart';
import '../services/api_exception.dart';
import 'app_input.dart';
import 'app_toast.dart';
import 'bottom_sheet_surface.dart';

// Faction display order for the create-gang picker (distinct from AppPalette.factionColors' order).
const kCreateGangFactions = [
  'guild',
  'doctors',
  'vatican',
  'patricians',
  'strigoi',
  'gifted',
  'rashaar',
];

/// Bottom sheet that captures a new gang's name/faction/point-limit and calls
/// [onCreate], popping the freshly created list on success. Shared by the Gangs
/// tab and the in-game gang-selection step. [initialPoints] seeds the point
/// limit field — the game passes its ducat limit so a gang built there matches.
class CreateGangSheet extends StatefulWidget {
  const CreateGangSheet({
    super.key,
    required this.onCreate,
    this.initialPoints = 100,
  });
  final Future<api.ModelList> Function(String name, String faction, int points)
  onCreate;
  final int initialPoints;

  @override
  State<CreateGangSheet> createState() => _CreateGangSheetState();
}

class _CreateGangSheetState extends State<CreateGangSheet> {
  final _nameController = TextEditingController();
  late final _pointsController = TextEditingController(
    text: '${widget.initialPoints}',
  );
  String _selectedFaction = kCreateGangFactions.first;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Guard re-entry: the button is disabled while saving, but the name field's onSubmitted (Enter)
    // isn't — without this, hitting Enter twice created two gangs on the server (A-8).
    if (_saving) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final points = int.tryParse(_pointsController.text.trim()) ?? widget.initialPoints;
    setState(() => _saving = true);
    try {
      final gang = await widget.onCreate(name, _selectedFaction, points);
      if (mounted) Navigator.of(context).pop(gang);
    } on ApiException catch (e) {
      // Was silently swallowed, leaving the user staring at a stopped spinner with no idea why.
      if (mounted) {
        setState(() => _saving = false);
        showAppToast(context, e.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        showAppToast(context, AppLocalizations.of(context).errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomSheetSurface(
      scrollable: true,
      title: l10n.gangCreateTitle,
      children: [
        TextField(
          controller: _nameController,
          autofocus: true,
          style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
          decoration: goldInputDecoration(context, label: l10n.gangNameLabel),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _pointsController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
          decoration: goldInputDecoration(context, label: l10n.gangPointLimit),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.gangFactionLabel,
          style: TextStyle(
            fontSize: 12,
            color: context.subtleTextColor,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: kCreateGangFactions.map((f) {
              final selected = f == _selectedFaction;
              final color = AppPalette.factionColors[f] ?? context.accentColor;
              final iconPath = AppPalette.factionIcons[f]!;
              return GestureDetector(
                onTap: () => setState(() => _selectedFaction = f),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppPalette.factionIconGradient(
                      color,
                      opacity: selected ? 1 : 0.35,
                    ),
                    border: selected
                        ? Border.all(color: Colors.white, width: 2.5)
                        : null,
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  padding: const EdgeInsets.all(9),
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    l10n.gangCreateButton,
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
