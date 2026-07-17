import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

// tests for SpellPool
void main() {
  final instance = SpellPoolBuilder();
  // TODO add properties to the builder and call build()

  group(SpellPool, () {
    // int id
    test('to test the property `id`', () async {
      // TODO
    });

    // How many Disciplines this pool's chosen_disciplines may span at once (1 for almost every profile; 2 for Doctor of the Firmament).
    // int of_
    test('to test the property `of_`', () async {
      // TODO
    });

    // Non-Cantrip spells this pool grants, shared across every chosen Discipline when of > 1. Irrelevant when unlimited.
    // int slotCount
    test('to test the property `slotCount`', () async {
      // TODO
    });

    // When true, this model automatically knows every spell of its chosen Discipline(s) — spells/cantrips are pre-filled and there is nothing to pick.
    // bool unlimited
    test('to test the property `unlimited`', () async {
      // TODO
    });

    // Whether committing a Discipline in this pool grants that Discipline's free Cantrip (not counted against slot_count).
    // bool grantsCantrip
    test('to test the property `grantsCantrip`', () async {
      // TODO
    });

    // Apprentice Doctor's Apprenticeship: when true, eligible_disciplines/of/slot_count are resolved from the mentor entry named by the parent ListEntry's mentored_by_entry_id (null/empty until a mentor is chosen), not static per-profile data. chosen_disciplines and spells are still this model's own picks. 
    // bool mentorDerived
    test('to test the property `mentorDerived`', () async {
      // TODO
    });

    // The card's special rule that explains this pool's shape (e.g. Aetheric Gaze, Entwined Magics, Apprenticeship, Arcane Totem), or null for the standard Mage(X) case.
    // SpellRuleRef rule
    test('to test the property `rule`', () async {
      // TODO
    });

    // Discipline slugs this pool may pick from, e.g. [\"blood_rites\", \"divinity\"].
    // BuiltList<String> eligibleDisciplines
    test('to test the property `eligibleDisciplines`', () async {
      // TODO
    });

    // The subset of eligible_disciplines this model has actually committed to (size ≤ of).
    // BuiltList<String> chosenDisciplines
    test('to test the property `chosenDisciplines`', () async {
      // TODO
    });

    // The free Cantrip(s) for each committed Discipline (only present once grants_cantrip and a Discipline is chosen). Not counted against slot_count.
    // BuiltList<PoolSpell> cantrips
    test('to test the property `cantrips`', () async {
      // TODO
    });

    // The non-free spells this model currently knows through this pool.
    // BuiltList<PoolSpell> spells
    test('to test the property `spells`', () async {
      // TODO
    });

  });
}
