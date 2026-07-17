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
/// compared against the string disciplines a model/pool carries. Each schema that embeds a
/// Discipline gets its own generated enum type, hence one overload per type used in this app.
String disciplineSlug(api.SpellDisciplineEnum discipline) =>
    api.standardSerializers.serializeWith(
          api.SpellDisciplineEnum.serializer,
          discipline,
        )
        as String;

String poolSpellDisciplineSlug(api.PoolSpellDisciplineEnum discipline) =>
    api.standardSerializers.serializeWith(
          api.PoolSpellDisciplineEnum.serializer,
          discipline,
        )
        as String;

String? grantedSpellDisciplineSlug(api.GrantedSpellDisciplineEnum? discipline) =>
    discipline == null
    ? null
    : api.standardSerializers.serializeWith(
            api.GrantedSpellDisciplineEnum.serializer,
            discipline,
          )
          as String;

/// A known or granted spell, unified across the three shapes the API returns one from (a pool's
/// PoolSpell, a profile's GrantedSpell, or the plain catalog Spell) so the picker/chips/detail
/// popup only ever deal with one type. `key` is null for a plain catalog spell (no cast state to
/// track outside a pool/grant context — see the gang-builder spell picker, which only ever shows
/// spells already wrapped as PoolSpell).
class KnownSpell {
  final String? key;
  final int? id;
  final String name;
  final String? disciplineName;
  final int? cost;
  final int? difficulty;
  final String description;
  final bool cantrip;
  final bool cast;
  final bool granted;
  // Whether this spell becomes castable again next round (true, the default) or stays cast for
  // the rest of the game once marked (false — Adventuring Noble's Arcane Totem pool only).
  final bool resetsEachRound;
  final api.SpellRuleRef? rule;

  const KnownSpell({
    this.key,
    this.id,
    required this.name,
    this.disciplineName,
    this.cost,
    this.difficulty,
    required this.description,
    required this.cantrip,
    this.cast = false,
    this.granted = false,
    this.resetsEachRound = true,
    this.rule,
  });

  factory KnownSpell.fromPoolSpell(api.PoolSpell spell, {required bool resetsEachRound}) =>
      KnownSpell(
        key: spell.key,
        id: spell.id,
        name: spell.name,
        disciplineName: disciplineLabel(poolSpellDisciplineSlug(spell.discipline)),
        cost: spell.cost,
        difficulty: spell.difficulty,
        description: spell.description,
        cantrip: spell.cantrip,
        cast: spell.cast,
        resetsEachRound: resetsEachRound,
      );

  factory KnownSpell.fromGrantedSpell(api.GrantedSpell spell) {
    final slug = grantedSpellDisciplineSlug(spell.discipline);
    return KnownSpell(
      key: spell.key,
      id: spell.id,
      name: spell.name,
      disciplineName: slug == null ? null : disciplineLabel(slug),
      cost: spell.cost,
      difficulty: spell.difficulty,
      description: spell.description ?? '',
      cantrip: spell.cantrip,
      cast: spell.cast,
      granted: true,
      resetsEachRound: spell.resetsEachRound,
      rule: spell.rule,
    );
  }

  factory KnownSpell.fromCatalogSpell(api.Spell spell) => KnownSpell(
    id: spell.id,
    name: spell.name,
    disciplineName: disciplineLabel(disciplineSlug(spell.discipline)),
    cost: spell.cost,
    difficulty: spell.difficulty,
    description: spell.description,
    cantrip: spell.cantrip,
  );
}

/// Every spell a model knows or has been granted — every pool's cantrip(s) and picked spells,
/// then every granted spell — in the order the picker/chips display them. Empty for a non-Mage
/// model (empty pools/grantedSpells).
List<KnownSpell> knownSpellsFor(api.ListEntry entry) => [
  for (final pool in entry.pools) ...[
    ...pool.cantrips.map(
      (s) => KnownSpell.fromPoolSpell(s, resetsEachRound: pool.resetsEachRound),
    ),
    ...pool.spells.map(
      (s) => KnownSpell.fromPoolSpell(s, resetsEachRound: pool.resetsEachRound),
    ),
  ],
  ...entry.grantedSpells.map(KnownSpell.fromGrantedSpell),
];

/// Popup showing a spell's Discipline, Will Point cost, Difficulty and effect. Opened by tapping
/// a [SpellChip] (or the in-game detail button), and shared by the gang builder and the roster.
void showSpellDetailDialog(BuildContext context, KnownSpell spell) {
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
                    color: context.accentColor,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            [
              if (spell.disciplineName != null) spell.disciplineName!,
              if (spell.cost != null) 'WP ${spell.cost}',
              if (spell.difficulty != null) 'Difficulty ${spell.difficulty}',
            ].join('  ·  '),
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 12),
          Divider(
            color: context.subtleTextColor.withValues(alpha: 0.3),
            thickness: 0.5,
          ),
          const SizedBox(height: 12),
          Text(
            spell.description,
            style: TextStyle(fontSize: 13, color: context.textColor, height: 1.5),
          ),
          if (spell.rule != null) ...[
            const SizedBox(height: 10),
            Text(
              spell.rule!.name,
              style: GoogleFonts.cinzel(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: context.accentColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              spell.rule!.description,
              style: TextStyle(fontSize: 11.5, color: context.subtleTextColor, height: 1.4),
            ),
          ],
        ],
      ),
    ),
  );
}

/// A compact pill showing a known spell's name (Cantrips are marked with a star). Tapping it opens
/// [showSpellDetailDialog]. Rendered on the light-on-dark faction gradient of a model tile.
class SpellChip extends StatelessWidget {
  const SpellChip({super.key, required this.spell});

  final KnownSpell spell;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSpellDetailDialog(context, spell),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (spell.cantrip) ...[
              Icon(Icons.star, size: 10, color: Colors.white.withValues(alpha: 0.75)),
              const SizedBox(width: 4),
            ],
            Text(
              spell.name,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            if (spell.granted) ...[
              const SizedBox(width: 4),
              Text(
                'granted',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The known/granted-spell chips for a model, tappable for details. Returns an empty list when
/// the model knows nothing, so callers can decide on a fallback.
List<Widget> spellChipsFor(api.ListEntry entry) =>
    knownSpellsFor(entry).map((s) => SpellChip(spell: s)).toList();

/// A pure toggle: the whole chip is the tap target for marking [spell] cast, dimming via opacity
/// only — no text swap, so nothing reflows and there's no small hit target to miss. Used in-game,
/// own models only; reading a spell's description lives in [showKnownSpellsDialog] instead (one
/// button per model, not per chip — splitting "cast" and "read" onto the same small chip caused
/// misclicks in testing). A `resetsEachRound: false` spell (Adventuring Noble's Arcane Totem) gets
/// a dashed outline so its "stays cast all game" behaviour reads at a glance.
class SpellToggleChip extends StatelessWidget {
  const SpellToggleChip({super.key, required this.spell, required this.onToggle});

  final KnownSpell spell;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Opacity(
        opacity: spell.cast ? 0.55 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: spell.cast
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.32),
              width: 0.5,
              style: spell.resetsEachRound ? BorderStyle.solid : BorderStyle.none,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (spell.cantrip) ...[
                Icon(Icons.star, size: 9, color: Colors.white.withValues(alpha: 0.75)),
                const SizedBox(width: 4),
              ],
              Text(
                spell.name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
              if (!spell.resetsEachRound) ...[
                const SizedBox(width: 5),
                Text(
                  'ONCE/GAME',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Small round "ⓘ" button, one per model, opening [showKnownSpellsDialog] — the single place to
/// read every spell a model knows/was granted, decoupled from the toggle chips above it.
class SpellDetailButton extends StatelessWidget {
  const SpellDetailButton({super.key, required this.spells});

  final List<KnownSpell> spells;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'View spell details',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => showKnownSpellsDialog(context, spells),
        child: Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 0.5),
          ),
          child: Text(
            'i',
            style: GoogleFonts.cinzel(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Read-only popup listing every spell in [spells] with its full detail — the in-game counterpart
/// to [showSpellDetailDialog], but for the whole model at once rather than one chip at a time.
void showKnownSpellsDialog(BuildContext context, List<KnownSpell> spells) {
  showDialog(
    context: context,
    builder: (context) => ThemedDialogCard(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Known spells',
              style: GoogleFonts.cinzel(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final spell in spells) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (spell.cantrip) ...[
                                  Icon(Icons.star, size: 11, color: context.accentColor),
                                  const SizedBox(width: 5),
                                ],
                                Expanded(
                                  child: Text(
                                    spell.name,
                                    style: GoogleFonts.cinzel(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: context.textColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  [
                                    if (spell.disciplineName != null) spell.disciplineName!,
                                    if (spell.cost != null) 'WP ${spell.cost}',
                                    if (!spell.resetsEachRound) 'once/game',
                                  ].join(' · '),
                                  style: TextStyle(fontSize: 10, color: context.subtleTextColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              spell.description,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: context.subtleTextColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (spell != spells.last)
                        Divider(
                          height: 1,
                          color: context.subtleTextColor.withValues(alpha: 0.15),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// A compact, per-model summary for the gang-builder tile: one chip per pool naming its committed
/// Discipline(s) and how many spells were picked from it, plus one chip per distinct granted-spell
/// rule (grouped, so Blood Crone's five granted Cantrips collapse to a single "All cantrips" chip
/// instead of every individual spell name). Deliberately not the same as [spellChipsFor]/
/// [knownSpellsFor] — a model with a lot of known spells (Blood Crone, Adventuring Noble) turned
/// the full per-spell chip list into a wall of pills that dominated the tile; here the point is a
/// glanceable "what did I pick" summary, with the full detail one tap away in the spell picker.
List<Widget> spellSummaryChipsFor(api.ListEntry entry) {
  final chips = <Widget>[];

  for (final pool in entry.pools) {
    if (pool.unlimited) {
      chips.add(
        _SummaryChip('${pool.eligibleDisciplines.map(disciplineLabel).join(' + ')} (all)'),
      );
      continue;
    }
    if (pool.chosenDisciplines.isEmpty) continue;
    // A pool with its own explaining rule (Tarot Reader's Minor Arcana bonus pool, Seamstress's
    // Entwined Magics) is labelled with that rule's name, so two Discipline chips on the same
    // model read as what they actually are instead of two identical-looking picks with no
    // context. A model's first/only pool usually has no rule at all (the plain Mage(X) case).
    final prefix = (pool.rule != null && pool.rule!.name.isNotEmpty) ? '${pool.rule!.name}: ' : '';
    final label = '$prefix${pool.chosenDisciplines.map(disciplineLabel).join(' + ')}';
    chips.add(_SummaryChip(pool.spells.isEmpty ? label : '$label (${pool.spells.length})'));
  }

  final groups = <String, List<api.GrantedSpell>>{};
  for (final g in entry.grantedSpells) {
    final key = (g.rule != null && g.rule!.name.isNotEmpty) ? g.rule!.name : g.name;
    groups.putIfAbsent(key, () => []).add(g);
  }
  for (final items in groups.values) {
    if (items.length > 1 && items.every((g) => g.cantrip)) {
      chips.add(const _SummaryChip('All cantrips', granted: true));
    } else {
      for (final g in items) {
        chips.add(_SummaryChip(g.name, granted: true));
      }
    }
  }

  return chips;
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip(this.label, {this.granted = false});

  final String label;
  final bool granted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: granted ? 0.08 : 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          fontStyle: granted ? FontStyle.italic : FontStyle.normal,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
