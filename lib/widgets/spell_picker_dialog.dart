import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/spell_selection.dart';
import 'spell_chips.dart';
import 'themed_dialog_card.dart';

export '../models/spell_selection.dart' show PoolSelectionResult, SpellPickerResult;

/// Opens the spell picker for [entry] and returns the player's edits, or null if cancelled.
/// [siblingEntries] is the rest of the gang (including summoned/equipment — filtered internally),
/// needed only for Apprentice Doctor's mentor picker.
Future<SpellPickerResult?> showSpellPickerDialog(
  BuildContext context, {
  required api.ListEntry entry,
  required List<api.Spell> allSpells,
  List<api.ListEntry> siblingEntries = const [],
}) => showDialog<SpellPickerResult>(
  context: context,
  builder: (_) => SpellPickerDialog(
    entry: entry,
    allSpells: allSpells,
    siblingEntries: siblingEntries,
  ),
);

/// The gang-builder / pre-game spell picker. Renders one section per the entry's spell pools
/// (rulebook p24) — shaped purely from that pool's own data (`of`, `unlimited`, `mentorDerived`,
/// how many Disciplines are eligible), never from which profile this happens to be — plus a
/// read-only "Granted" section for spells the model always knows regardless of picks.
class SpellPickerDialog extends StatefulWidget {
  const SpellPickerDialog({
    super.key,
    required this.entry,
    required this.allSpells,
    this.siblingEntries = const [],
  });

  final api.ListEntry entry;
  final List<api.Spell> allSpells;
  final List<api.ListEntry> siblingEntries;

  @override
  State<SpellPickerDialog> createState() => _SpellPickerDialogState();
}

class _PoolEditState {
  Set<String> disciplines;
  Set<int> spellIds;
  _PoolEditState({required this.disciplines, required this.spellIds});
}

class _MentorInfo {
  final int of;
  final List<String> eligibleDisciplines;
  final int slotCount;
  const _MentorInfo({
    required this.of,
    required this.eligibleDisciplines,
    required this.slotCount,
  });
}

class _SpellPickerDialogState extends State<SpellPickerDialog> {
  late final Map<int, String> _disciplineBySpellId;
  late final Map<int, _PoolEditState> _pools;
  late final Map<int, String?> _activeTab;
  final Map<String, bool> _collapsed = {};

  @override
  void initState() {
    super.initState();
    _disciplineBySpellId = {
      for (final s in widget.allSpells) s.id: disciplineSlug(s.discipline),
    };
    _pools = {
      for (final p in widget.entry.pools)
        p.id: _PoolEditState(
          disciplines: p.chosenDisciplines.toSet(),
          spellIds: p.spells.where((s) => !s.cantrip).map((s) => s.id).toSet(),
        ),
    };
    _activeTab = {
      for (final p in widget.entry.pools)
        p.id: _pools[p.id]!.disciplines.isNotEmpty
            ? _pools[p.id]!.disciplines.first
            : (p.eligibleDisciplines.isNotEmpty ? p.eligibleDisciplines.first : null),
    };
  }

  List<api.Spell> _choosable(String discipline) =>
      widget.allSpells
          .where((s) => disciplineSlug(s.discipline) == discipline && !s.cantrip)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  api.Spell? _cantripFor(String discipline) {
    try {
      return widget.allSpells.firstWhere(
        (s) => disciplineSlug(s.discipline) == discipline && s.cantrip,
      );
    } catch (_) {
      return null;
    }
  }

  api.ListEntry? get _mentorEntry {
    final id = widget.entry.mentoredByEntryId;
    if (id == null) return null;
    try {
      return widget.siblingEntries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // The mentor's *eligible* Disciplines (every Discipline she could pick from), not just the ones
  // she happens to have committed to herself — Apprenticeship grants access to her whole base kit,
  // regardless of her own picks (Doctor of the Firmament mentoring with only 2 of her 3 Disciplines
  // actually chosen still hands the apprentice all 3 to choose from). slotCount comes from
  // mageSlotCount, not the mentor's own (resolved) slotCount — Apprenticeship only ever copies the
  // Mage ability, so a mentor who also has Expert Sorcerer (Doctor of the Firmament: Mage(2) +
  // Expert Sorcerer(2), 4 slots combined) only hands over the Mage-sized 2, not the full 4. `of` is
  // always 1 (plain Mage: pick one Discipline) regardless of the mentor's own `of` — Aetheric
  // Gaze's "2 Disciplines at once" is Doctor of the Firmament's own separate ability, not part of
  // Mage, so copying Mage from her never copies that too.
  _MentorInfo _mentorInfo() {
    final mentor = _mentorEntry;
    final mentorPool = mentor != null && mentor.pools.isNotEmpty ? mentor.pools.first : null;
    if (mentorPool == null) {
      return const _MentorInfo(of: 1, eligibleDisciplines: [], slotCount: 0);
    }
    return _MentorInfo(
      of: 1,
      eligibleDisciplines: mentorPool.eligibleDisciplines.toList(),
      slotCount: mentorPool.mageSlotCount,
    );
  }

  void _toggleSpell(
    api.SpellPool pool, {
    required String discipline,
    required int spellId,
    required int of,
    required int slotCount,
  }) {
    setState(() {
      final st = _pools[pool.id]!;
      if (st.spellIds.contains(spellId)) {
        st.spellIds.remove(spellId);
        if (!st.spellIds.any((id) => _disciplineBySpellId[id] == discipline)) {
          st.disciplines.remove(discipline);
        }
      } else {
        if (st.spellIds.length >= slotCount) return;
        if (!st.disciplines.contains(discipline)) {
          if (st.disciplines.length >= of) return;
          st.disciplines.add(discipline);
        }
        st.spellIds.add(spellId);
      }
      _activeTab[pool.id] = discipline;
    });
  }

  // of == 1, >1 eligible: picking a Discipline replaces the whole pick (rulebook: spells share one
  // Discipline), same as switching tabs did before this rework.
  void _selectSingleDiscipline(api.SpellPool pool, String discipline) {
    final st = _pools[pool.id]!;
    if (st.disciplines.length == 1 && st.disciplines.first == discipline) return;
    setState(() {
      st.disciplines = {discipline};
      st.spellIds = {};
      _activeTab[pool.id] = discipline;
    });
  }

  void _toggleCollapsed(String sectionKey) =>
      setState(() => _collapsed[sectionKey] = !(_collapsed[sectionKey] ?? false));

  // Mentor picking moved to its own Apprenticeship dialog (opened from the gang-builder tile, not
  // this one) — this dialog never touches mentored_by_entry_id, so mentorChanged stays false and
  // the server leaves whatever mentor is already set untouched.
  void _save() {
    final poolSelections = <PoolSelectionResult>[
      for (final pool in widget.entry.pools)
        if (!pool.unlimited)
          PoolSelectionResult(
            poolId: pool.id,
            disciplines: _pools[pool.id]!.disciplines.toList(),
            spellIds: _pools[pool.id]!.spellIds.toList(),
          ),
    ];
    Navigator.of(context).pop(SpellPickerResult(poolSelections: poolSelections));
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accentColor;
    return ThemedDialogCard(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
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
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final pool in widget.entry.pools) _buildPoolSection(pool),
                    if (widget.entry.grantedSpells.isNotEmpty) _buildGrantedSection(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context).actionCancel, style: TextStyle(color: context.subtleTextColor)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _save,
                  child: Text(AppLocalizations.of(context).actionSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Every pool/grant renders as one of these — a header (tap to collapse/expand) plus its body.
  // Collapsed, the header shows [collapsedSummary] instead of the body, so a multi-pool model
  // (Seamstress, Tarot Reader) doesn't force scrolling past a finished pool to reach the next one.
  // [locked] (Apprentice Doctor's own-spells bubble before a mentor is chosen) disables the toggle
  // entirely and always renders collapsed, with a lock glyph instead of a chevron.
  Widget _collapsibleSection({
    required String sectionKey,
    required String title,
    String? badge,
    String? collapsedSummary,
    bool locked = false,
    required List<Widget> children,
  }) {
    final collapsed = locked || (_collapsed[sectionKey] ?? false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.subtleTextColor.withValues(alpha: locked ? 0.03 : 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.subtleTextColor.withValues(alpha: locked ? 0.1 : 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: locked ? null : () => _toggleCollapsed(sectionKey),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          locked
                              ? Icons.lock_outline
                              : (collapsed ? Icons.chevron_right : Icons.expand_more),
                          size: 16,
                          color: context.subtleTextColor.withValues(alpha: locked ? 0.5 : 0.8),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 11,
                              color: context.subtleTextColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (badge != null && !collapsed)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: context.accentColor.withValues(alpha: 0.45)),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: context.accentColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    // On its own full-width row (not squeezed beside the title) so a longer
                    // summary — a rule name plus Disciplines plus a spell count — has room to
                    // wrap onto a second line instead of being clipped to a few characters.
                    if (collapsed && collapsedSummary != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3, left: 20),
                        child: Text(
                          collapsedSummary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: context.subtleTextColor, height: 1.3),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (!collapsed) ...[const SizedBox(height: 8), ...children],
          ],
        ),
      ),
    );
  }

  // A rule authored only to carry a character-unique spell's data (The Drowned Nun's Dagonite
  // Baptism, Maria Fioritura's Creative Creation) has a blank name — it exists to be looked up by
  // spell_name, not printed. Rendering an empty bold line above the description read as a stray
  // blank line, so the name row is skipped entirely rather than shown empty.
  Widget _ruleCallout(api.SpellRuleRef rule) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: context.accentColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: context.accentColor.withValues(alpha: 0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (rule.name.isNotEmpty) ...[
          Text(
            rule.name,
            style: GoogleFonts.cinzel(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: context.accentColor,
            ),
          ),
          const SizedBox(height: 2),
        ],
        Text(
          rule.description,
          style: TextStyle(fontSize: 11.5, color: context.subtleTextColor, height: 1.4),
        ),
      ],
    ),
  );

  // Disciplines this pool's chip row should grey out: Tarot Reader's Minor Arcana bonus pool
  // (distinctFromOtherPools) can't repeat a Discipline another of this model's own pools already
  // committed to; Romani's Tarot (distinctDisciplinePerCopy) can't repeat one a sibling copy of
  // the same profile elsewhere in the gang already committed to. A model can be affected by either,
  // neither, or (in principle) both.
  Set<String> _blockedDisciplines(api.SpellPool pool) {
    final blocked = <String>{};
    if (pool.distinctFromOtherPools) {
      for (final other in widget.entry.pools) {
        if (other.id == pool.id) continue;
        final st = _pools[other.id];
        if (st != null) blocked.addAll(st.disciplines);
      }
    }
    if (widget.entry.distinctDisciplinePerCopy) {
      for (final sibling in widget.siblingEntries) {
        if (sibling.id == widget.entry.id) continue;
        if (sibling.profileName != widget.entry.profileName) continue;
        for (final p in sibling.pools) {
          blocked.addAll(p.chosenDisciplines);
        }
      }
    }
    return blocked;
  }

  Widget _disciplineChipRow(
    List<String> disciplines,
    Set<String> selected, {
    required void Function(String) onTap,
    Set<String> blocked = const {},
  }) {
    final accent = context.accentColor;
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: disciplines.map((slug) {
        final isSelected = selected.contains(slug);
        final isBlocked = blocked.contains(slug) && !isSelected;
        return GestureDetector(
          onTap: isBlocked ? null : () => onTap(slug),
          child: Opacity(
            opacity: isBlocked ? 0.4 : 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? accent.withValues(alpha: 0.85)
                    : context.subtleTextColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? accent : context.subtleTextColor.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                disciplineLabel(slug),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : context.textColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // The Cantrip row is always rendered (fixed position) once the pool grants one for this
  // Discipline, whether or not it's earned yet — otherwise it pops in the moment a spell is picked
  // and the whole tab visibly jumps (most noticeable switching between Doctor of the Firmament's
  // tabs). Only its checked state and label change once the Discipline is actually committed.
  // A slot_count: 0 pool (Tarot Reader's bonus pool, Romani's Tarot) grants nothing but that
  // Cantrip — the pickable list below is skipped entirely rather than shown fully disabled.
  Widget _spellList(api.SpellPool pool, String discipline, {required int of, required int slotCount}) {
    final st = _pools[pool.id]!;
    final cantripSpell = pool.grantsCantrip ? _cantripFor(discipline) : null;
    final cantripKnown = st.disciplines.contains(discipline);
    final blocked = !st.disciplines.contains(discipline) && st.disciplines.length >= of;
    final showPicks = slotCount > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPicks && blocked)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              AppLocalizations.of(context).spellDeselectHint,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: context.subtleTextColor,
              ),
            ),
          ),
        if (cantripSpell != null)
          _SpellRow(
            spell: KnownSpell.fromCatalogSpell(cantripSpell),
            checked: cantripKnown,
            enabled: false,
            onTap: null,
          ),
        if (showPicks)
          ..._choosable(discipline).map((spell) {
            final checked = st.spellIds.contains(spell.id);
            final enabled = checked || (!blocked && st.spellIds.length < slotCount);
            return _SpellRow(
              spell: KnownSpell.fromCatalogSpell(spell),
              checked: checked,
              enabled: enabled,
              onTap: enabled
                  ? () => _toggleSpell(
                      pool,
                      discipline: discipline,
                      spellId: spell.id,
                      of: of,
                      slotCount: slotCount,
                    )
                  : null,
            );
          }),
      ],
    );
  }

  Widget _buildPoolSection(api.SpellPool pool) {
    if (pool.unlimited) return _buildUnlimitedPool(pool);
    if (pool.mentorDerived) return _buildMentorDerivedPool(pool);
    return _buildStandardPool(
      pool,
      of: pool.of_,
      eligible: pool.eligibleDisciplines.toList(),
      slotCount: pool.slotCount,
    );
  }

  Widget _buildUnlimitedPool(api.SpellPool pool) {
    final known = [...pool.cantrips, ...pool.spells];
    return _collapsibleSection(
      sectionKey: 'pool-${pool.id}',
      title: pool.rule?.name ?? AppLocalizations.of(context).spellPoolTitle,
      collapsedSummary:
          '${pool.eligibleDisciplines.map(disciplineLabel).join(' + ')} · ${known.length} known',
      children: [
        // The pool's own rule callout (Arcane Totem, etc.) already says every spell of the
        // Discipline is known automatically — a second "nothing to choose here" banner repeated
        // the same fact and just took up space.
        if (pool.rule != null) _ruleCallout(pool.rule!),
        ...known.map(
          (s) => _SpellRow(
            spell: KnownSpell.fromPoolSpell(s, resetsEachRound: pool.resetsEachRound),
            checked: true,
            enabled: false,
            trailingLabel: AppLocalizations.of(context).spellAlwaysKnown,
            onTap: null,
          ),
        ),
      ],
    );
  }

  // Mentor selection itself lives in the Apprenticeship dialog (opened from the gang-builder tile
  // — see showApprenticeshipDialog), not here: this dialog only ever opens once a mentor is
  // already set (the tile's "Spells" button doesn't appear before that), so there's nothing to
  // pick here beyond the spells themselves.
  Widget _buildMentorDerivedPool(api.SpellPool pool) {
    final mentor = _mentorEntry;
    final mentorInfo = _mentorInfo();
    final st = _pools[pool.id]!;

    final l10n = AppLocalizations.of(context);
    if (mentor == null) {
      return _collapsibleSection(
        sectionKey: 'pool-${pool.id}',
        title: l10n.spellPoolTitle,
        collapsedSummary: l10n.spellNoMentorSetup,
        locked: true,
        children: const [],
      );
    }

    return _collapsibleSection(
      sectionKey: 'pool-${pool.id}',
      title: l10n.spellPoolTitle,
      collapsedSummary: _poolSummary(context, st, mentorInfo.slotCount),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            l10n.spellMentorLabel(mentor.name),
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: context.subtleTextColor,
            ),
          ),
        ),
        ..._standardPoolBody(
          pool,
          of: mentorInfo.of,
          eligible: mentorInfo.eligibleDisciplines,
          slotCount: mentorInfo.slotCount,
        ),
      ],
    );
  }

  Widget _buildStandardPool(
    api.SpellPool pool, {
    required int of,
    required List<String> eligible,
    required int slotCount,
  }) {
    final st = _pools[pool.id]!;
    return _collapsibleSection(
      sectionKey: 'pool-${pool.id}',
      title: pool.rule?.name ?? AppLocalizations.of(context).spellPoolTitle,
      badge: of > 1 ? AppLocalizations.of(context).spellUpToDisciplines(of) : null,
      collapsedSummary: _poolSummary(context, st, slotCount),
      children: [
        if (pool.rule != null) _ruleCallout(pool.rule!),
        ..._standardPoolBody(pool, of: of, eligible: eligible, slotCount: slotCount),
      ],
    );
  }

  String _poolSummary(BuildContext context, _PoolEditState st, int slotCount) {
    final l10n = AppLocalizations.of(context);
    final disciplines = st.disciplines.isEmpty
        ? l10n.spellNoDisciplineChosen
        : st.disciplines.map(disciplineLabel).join(' + ');
    return slotCount > 0
        ? '$disciplines · ${l10n.spellsSlashCount(st.spellIds.length, slotCount)}'
        : disciplines;
  }

  List<Widget> _standardPoolBody(
    api.SpellPool pool, {
    required int of,
    required List<String> eligible,
    required int slotCount,
  }) {
    final st = _pools[pool.id]!;
    final l10n = AppLocalizations.of(context);
    // Only one Discipline eligible: nothing to choose, it's implicitly committed.
    if (eligible.length <= 1) {
      final discipline = eligible.isEmpty ? null : eligible.first;
      if (discipline != null && st.disciplines.isEmpty) {
        st.disciplines = {discipline};
      }
      return [
        Text(
          slotCount > 0
              ? '${l10n.spellsKnownCountLong(st.spellIds.length, slotCount)}'
                    '${discipline != null ? ' · ${disciplineLabel(discipline)}' : ''}'
              : discipline != null
              ? '${disciplineLabel(discipline)} · ${l10n.spellCantripOnly}'
              : l10n.spellCantripOnly,
          style: TextStyle(fontSize: 11, color: context.subtleTextColor),
        ),
        const SizedBox(height: 8),
        if (discipline != null) _spellList(pool, discipline, of: of, slotCount: slotCount),
      ];
    }

    if (of == 1) {
      final active = st.disciplines.isNotEmpty ? st.disciplines.first : null;
      final blocked = _blockedDisciplines(pool);
      return [
        Text(
          slotCount > 0
              ? l10n.spellsKnownCountLong(st.spellIds.length, slotCount)
              : active != null
              ? '${disciplineLabel(active)} · ${l10n.spellCantripOnly}'
              : l10n.spellCantripOnly,
          style: TextStyle(fontSize: 11, color: context.subtleTextColor),
        ),
        const SizedBox(height: 8),
        _disciplineChipRow(
          eligible,
          st.disciplines,
          blocked: blocked,
          onTap: (d) => _selectSingleDiscipline(pool, d),
        ),
        if (blocked.isNotEmpty && (active == null || !blocked.contains(active)))
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              pool.distinctFromOtherPools
                  ? l10n.spellDistinctPool
                  : l10n.spellDistinctCopy,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: context.subtleTextColor,
              ),
            ),
          ),
        const SizedBox(height: 10),
        if (active != null) _spellList(pool, active, of: of, slotCount: slotCount),
      ];
    }

    // of > 1: tabs, one per eligible Discipline. Checking a spell implicitly commits its tab.
    final active = _activeTab[pool.id] ?? eligible.first;
    return [
      Text(
        l10n.spellsAndDisciplines(st.spellIds.length, slotCount, st.disciplines.length, of),
        style: TextStyle(fontSize: 11, color: context.subtleTextColor),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: eligible.map((d) {
          final isActive = d == active;
          final isChosen = st.disciplines.contains(d);
          return GestureDetector(
            onTap: () => setState(() => _activeTab[pool.id] = d),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isChosen
                    ? context.accentColor.withValues(alpha: 0.18)
                    : context.subtleTextColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive
                      ? context.accentColor
                      : context.subtleTextColor.withValues(alpha: 0.25),
                  width: isActive ? 1 : 0.5,
                ),
              ),
              child: Text(
                disciplineLabel(d),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? context.textColor : context.subtleTextColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      const SizedBox(height: 10),
      _spellList(pool, active, of: of, slotCount: slotCount),
    ];
  }

  // Every currently-active pool Cantrip (grants_cantrip, Discipline chosen right now — including
  // an unsaved live pick) — used to hide a granted Cantrip that duplicates one already shown
  // through a pool (Blood Crone's Major Arcana grants all 5 Cantrips outright; the one matching
  // whichever Discipline she's picked in her own pool is the *same* spell, not a second one).
  // The server already drops this duplicate from a saved entry's payload — this additionally
  // covers the live, not-yet-saved edit the server can't see yet.
  Set<String> get _activePoolCantripDisciplines {
    final result = <String>{};
    for (final pool in widget.entry.pools) {
      if (!pool.grantsCantrip) continue;
      final st = _pools[pool.id];
      if (st != null) result.addAll(st.disciplines);
    }
    return result;
  }

  Widget _buildGrantedSection() {
    final active = _activePoolCantripDisciplines;
    final grants = widget.entry.grantedSpells.where((g) {
      if (!g.cantrip) return true;
      final slug = grantedSpellDisciplineSlug(g.discipline);
      return slug == null || !active.contains(slug);
    }).toList();
    if (grants.isEmpty) return const SizedBox.shrink();
    final rules = <String, api.SpellRuleRef>{
      for (final g in grants)
        if (g.rule != null) g.rule!.name: g.rule!,
    };
    final l10n = AppLocalizations.of(context);
    return _collapsibleSection(
      sectionKey: 'granted',
      title: l10n.spellGranted,
      collapsedSummary: l10n.spellsPlural(grants.length),
      children: [
        for (final rule in rules.values) _ruleCallout(rule),
        ...grants.map(
          (g) => _SpellRow(
            spell: KnownSpell.fromGrantedSpell(g),
            checked: true,
            enabled: false,
            trailingLabel: l10n.spellGrantedLower,
            onTap: null,
          ),
        ),
      ],
    );
  }
}

class _SpellRow extends StatelessWidget {
  const _SpellRow({
    required this.spell,
    required this.checked,
    required this.enabled,
    this.trailingLabel,
    this.onTap,
  });

  final KnownSpell spell;
  final bool checked;
  final bool enabled;
  final String? trailingLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              checked ? Icons.check_circle : Icons.circle_outlined,
              size: 20,
              color: checked
                  ? accent
                  : context.subtleTextColor.withValues(alpha: enabled ? 0.6 : 0.25),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spell.name,
                          style: GoogleFonts.cinzel(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: enabled ? context.textColor : context.subtleTextColor,
                          ),
                        ),
                      ),
                      if (spell.cantrip)
                        // A Cantrip's cost is always 0 (not worth stating) and its rules — free,
                        // known once its Discipline is picked — are the rulebook's, not ours to
                        // spell out here; just its Difficulty is worth a glance.
                        Text(
                          'Cantrip · Diff ${spell.difficulty}',
                          style: TextStyle(fontSize: 10, color: context.subtleTextColor),
                        )
                      else if (trailingLabel != null)
                        Text(
                          trailingLabel!,
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: context.subtleTextColor,
                          ),
                        )
                      else
                        Text(
                          'WP ${spell.cost} · Diff ${spell.difficulty}',
                          style: TextStyle(fontSize: 10, color: context.subtleTextColor),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    spell.description,
                    style: TextStyle(fontSize: 11, color: context.subtleTextColor, height: 1.35),
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
