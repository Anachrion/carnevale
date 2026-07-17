/// One pool's committed Discipline(s) and picked (non-Cantrip) spell ids, ready to send back to
/// GangService.setEntrySpells. Submitted for every one of the entry's pools except `unlimited`
/// ones (nothing to pick there — the server auto-fills them), per the API's "always send every
/// pool, an omitted one loses its selection" contract.
class PoolSelectionResult {
  final int poolId;
  final List<String> disciplines;
  final List<int> spellIds;
  const PoolSelectionResult({
    required this.poolId,
    required this.disciplines,
    required this.spellIds,
  });
}

/// The player's edits from the spell picker dialog, ready to send to GangService.setEntrySpells.
class SpellPickerResult {
  final List<PoolSelectionResult> poolSelections;
  // Apprentice Doctor's Apprenticeship only: whether the mentor was touched at all this session,
  // and its new value — kept separate from `poolSelections` because omitting it server-side means
  // "leave untouched," not "clear," so a model with no mentor_derived pool never sends it.
  final bool mentorChanged;
  final int? mentoredByEntryId;
  const SpellPickerResult({
    required this.poolSelections,
    this.mentorChanged = false,
    this.mentoredByEntryId,
  });
}
