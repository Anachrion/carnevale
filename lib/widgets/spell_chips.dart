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
import '../l10n/app_localizations.dart';
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

/// A compact pill naming a model's spells, tappable to open [showKnownSpellsDialog] — everything
/// used to live as one toggle/read-only chip per spell plus a separate "i" detail button, but that
/// turned into a wall of pills for a model with a lot of spells (Blood Crone, Adventuring Noble).
/// Pass [onToggle] for your own live model (each row's checkbox then marks that spell cast); leave
/// it null for an opponent's model, where the dialog is read-only.
class SpellsButton extends StatelessWidget {
  const SpellsButton({super.key, required this.spells, this.onToggle});

  final List<KnownSpell> spells;
  final ValueChanged<KnownSpell>? onToggle;

  @override
  Widget build(BuildContext context) {
    final cast = spells.where((s) => s.cast).length;
    return GestureDetector(
      onTap: () => showKnownSpellsDialog(context, spells, onToggle: onToggle),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.32), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_fix_high, size: 13, color: Colors.white.withValues(alpha: 0.85)),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context).spellsButtonLabel(cast, spells.length),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Every spell in [spells] with its full detail, one row each. Read-only when [onToggle] is null
/// (an opponent's model, or the gang-builder/roster's plain reference view); for your own live
/// model, each row's checkbox marks that spell cast. The checked state shown here is this dialog's
/// own local copy — [onToggle] is what actually persists it (see [GangViewerBody]'s
/// onToggleSpellCast) — so the dialog stays responsive to taps immediately without needing to be
/// wired into the tile's own rebuilds while it's open.
void showKnownSpellsDialog(
  BuildContext context,
  List<KnownSpell> spells, {
  ValueChanged<KnownSpell>? onToggle,
}) {
  showDialog(
    context: context,
    builder: (context) => _KnownSpellsDialog(spells: spells, onToggle: onToggle),
  );
}

class _KnownSpellsDialog extends StatefulWidget {
  const _KnownSpellsDialog({required this.spells, this.onToggle});

  final List<KnownSpell> spells;
  final ValueChanged<KnownSpell>? onToggle;

  @override
  State<_KnownSpellsDialog> createState() => _KnownSpellsDialogState();
}

class _KnownSpellsDialogState extends State<_KnownSpellsDialog> {
  late final Set<String> _cast = {
    for (final s in widget.spells)
      if (s.key != null && s.cast) s.key!,
  };

  bool _isCast(KnownSpell spell) => spell.key == null ? spell.cast : _cast.contains(spell.key);

  @override
  Widget build(BuildContext context) {
    return ThemedDialogCard(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).spellsKnownTitle,
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
                    for (final spell in widget.spells) ...[
                      _row(spell),
                      if (spell != widget.spells.last)
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
    );
  }

  Widget _row(KnownSpell spell) {
    final cast = _isCast(spell);
    final onToggle = widget.onToggle;
    final canToggle = onToggle != null && spell.key != null;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: canToggle
          ? () {
              setState(() => cast ? _cast.remove(spell.key) : _cast.add(spell.key!));
              onToggle(spell);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              cast ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: cast
                  ? context.accentColor
                  : context.subtleTextColor.withValues(alpha: canToggle ? 0.6 : 0.3),
            ),
            const SizedBox(width: 8),
            Expanded(
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
                          // The star above already marks a Cantrip; its cost is always 0.
                          if (!spell.cantrip && spell.cost != null) 'WP ${spell.cost}',
                          if (spell.difficulty != null) 'Diff ${spell.difficulty}',
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
          ],
        ),
      ),
    );
  }
}

/// A compact, per-model summary for the gang-builder tile: one chip per pool naming its committed
/// Discipline(s) and how many spells were picked from it, plus one chip per distinct granted-spell
/// rule (grouped, so Blood Crone's five granted Cantrips collapse to a single "All cantrips" chip
/// instead of every individual spell name). Deliberately not the same as [SpellsButton]/
/// [knownSpellsFor] — a model with a lot of known spells (Blood Crone, Adventuring Noble) turned
/// the full per-spell chip list into a wall of pills that dominated the tile; here the point is a
/// glanceable "what did I pick" summary, with the full detail one tap away in the spell picker.
List<Widget> spellSummaryChipsFor(AppLocalizations l10n, api.ListEntry entry) {
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
      chips.add(_SummaryChip(l10n.spellAllCantrips, granted: true));
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
