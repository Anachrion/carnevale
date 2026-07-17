import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';
import 'themed_dialog_card.dart';

/// The player's edit from the Apprenticeship dialog — just the chosen mentor, since copying an
/// ability other than Mage isn't implemented yet. Null [mentorEntryId] clears the mentor.
class ApprenticeshipResult {
  final int? mentorEntryId;
  const ApprenticeshipResult({this.mentorEntryId});
}

/// Opens the Apprentice Doctor's Apprenticeship picker: choose a mentor (a Hero+Doctor elsewhere
/// in the gang), which unlocks copying that mentor's Mage ability — the only ability this rework
/// supports copying so far. Returns null if cancelled.
Future<ApprenticeshipResult?> showApprenticeshipDialog(
  BuildContext context, {
  required api.ListEntry entry,
  required List<api.ListEntry> siblingEntries,
}) => showDialog<ApprenticeshipResult>(
  context: context,
  builder: (_) => ApprenticeshipDialog(entry: entry, siblingEntries: siblingEntries),
);

class ApprenticeshipDialog extends StatefulWidget {
  const ApprenticeshipDialog({super.key, required this.entry, required this.siblingEntries});

  final api.ListEntry entry;
  final List<api.ListEntry> siblingEntries;

  @override
  State<ApprenticeshipDialog> createState() => _ApprenticeshipDialogState();
}

class _ApprenticeshipDialogState extends State<ApprenticeshipDialog> {
  int? _mentorEntryId;

  @override
  void initState() {
    super.initState();
    _mentorEntryId = widget.entry.mentoredByEntryId;
  }

  // "pick one character in your gang with both the Doctor and Hero keywords to be this
  // character's mentor" — Leaders and Henchmen don't qualify even if they carry one of the two.
  List<api.ListEntry> get _candidates => widget.siblingEntries
      .where(
        (e) =>
            e.id != widget.entry.id &&
            e.keywords.contains('Hero') &&
            e.keywords.contains('Doctor') &&
            e.mage,
      )
      .toList();

  api.SpellRuleRef? get _rule {
    try {
      return widget.entry.pools.firstWhere((p) => p.mentorDerived).rule;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accentColor;
    final rule = _rule;
    final candidates = _candidates;
    return ThemedDialogCard(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.entry.name,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
            const SizedBox(height: 14),
            if (rule != null && rule.name.isNotEmpty) ...[
              _ruleCallout(context, rule),
              const SizedBox(height: 10),
            ],
            Text(
              'Mentor',
              style: TextStyle(
                fontSize: 11,
                color: context.subtleTextColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            if (candidates.isEmpty && _mentorEntryId == null)
              Text(
                'No eligible mentor yet — hire a Hero with the Doctor keyword first.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: context.subtleTextColor),
              )
            else
              DropdownButtonFormField<int?>(
                initialValue: _mentorEntryId,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  filled: true,
                  fillColor: context.subtleTextColor.withValues(alpha: 0.08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('— No mentor selected —')),
                  for (final c in candidates) DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (id) => setState(() => _mentorEntryId = id),
              ),
            const SizedBox(height: 14),
            Text(
              'Ability to copy',
              style: TextStyle(
                fontSize: 11,
                color: context.subtleTextColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Opacity(
              opacity: _mentorEntryId == null ? 0.4 : 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mage — copies the mentor\'s spell Disciplines',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Copying a unique skill or weapon profile isn\'t supported yet — Mage is the only ability available here.',
                style: TextStyle(fontSize: 10.5, color: context.subtleTextColor),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: TextStyle(color: context.subtleTextColor)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(ApprenticeshipResult(mentorEntryId: _mentorEntryId)),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ruleCallout(BuildContext context, api.SpellRuleRef rule) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: context.accentColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: context.accentColor.withValues(alpha: 0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rule.name,
          style: GoogleFonts.cinzel(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: context.accentColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          rule.description,
          style: TextStyle(fontSize: 11.5, color: context.subtleTextColor, height: 1.4),
        ),
      ],
    ),
  );
}
