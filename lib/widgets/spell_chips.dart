import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import 'themed_dialog_card.dart';

const Map<String, String> disciplineLabels = {
  'blood_rites': 'Blood Rites',
  'divinity': 'Divinity',
  'fateweaving': 'Fateweaving',
  'runes_of_sovereignty': 'Runes of Sovereignty',
  'wild_magic': 'Wild Magic',
};

String disciplineLabel(String slug) => disciplineLabels[slug] ?? slug;

/// The wire slug (e.g. 'blood_rites') for a generated discipline enum, so it can be labelled or
/// compared against the string disciplines a model carries.
String disciplineSlug(api.SpellDisciplineEnum discipline) =>
    api.standardSerializers.serializeWith(
          api.SpellDisciplineEnum.serializer,
          discipline,
        )
        as String;

/// Popup showing a spell's Discipline, Will Point cost, Difficulty and effect. Opened by tapping
/// a [SpellChip], and shared by the gang builder and the in-game model list.
void showSpellDetailDialog(BuildContext context, api.Spell spell) {
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
                  spell.name,
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
              ),
              if (spell.cantrip) ...[
                const SizedBox(width: 12),
                Text(
                  'Cantrip',
                  style: GoogleFonts.cinzel(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.gold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${disciplineLabel(disciplineSlug(spell.discipline))}  ·  WP ${spell.cost}  ·  Difficulty ${spell.difficulty}',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 12),
          Divider(
            color: context.subtleTextColor.withOpacity(0.3),
            thickness: 0.5,
          ),
          const SizedBox(height: 12),
          Text(
            spell.description,
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

/// A compact pill showing a known spell's name (Cantrips are marked with a star). Tapping it opens
/// [showSpellDetailDialog]. Rendered on the light-on-dark faction gradient of a model tile.
class SpellChip extends StatelessWidget {
  const SpellChip({super.key, required this.spell});

  final api.Spell spell;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSpellDetailDialog(context, spell),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.28), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (spell.cantrip) ...[
              Icon(Icons.star, size: 10, color: Colors.white.withOpacity(0.75)),
              const SizedBox(width: 4),
            ],
            Text(
              spell.name,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The known-spell chips for a model: the free Cantrip first (if any), then the chosen spells.
/// Returns an empty list when the model knows nothing, so callers can decide on a fallback.
List<Widget> spellChipsFor(api.ListEntry entry) {
  return [
    if (entry.cantrip != null) SpellChip(spell: entry.cantrip!),
    ...entry.spells.where((s) => !s.cantrip).map((s) => SpellChip(spell: s)),
  ];
}
