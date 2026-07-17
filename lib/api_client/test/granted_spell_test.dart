import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

// tests for GrantedSpell
void main() {
  final instance = GrantedSpellBuilder();
  // TODO add properties to the builder and call build()

  group(GrantedSpell, () {
    // Identifies this spell for PATCH .../spell_casts (UpdateSpellCastInput.spell_cast.key) — pass it back verbatim, don't try to construct it from `id`.
    // String key
    test('to test the property `key`', () async {
      // TODO
    });

    // The underlying Catalog::Spell id when this grant references a real catalog spell (e.g. Galilean Priest's Waves of Force); null for a character-unique spell that has no catalog row (e.g. The Drowned Nun's Dagonite Baptism).
    // int id
    test('to test the property `id`', () async {
      // TODO
    });

    // Null for a character-unique, discipline-less spell.
    // String discipline
    test('to test the property `discipline`', () async {
      // TODO
    });

    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // Will Points spent to attempt the spell. Null only if the unique spell's data is incomplete.
    // int cost
    test('to test the property `cost`', () async {
      // TODO
    });

    // Magic Roll result needed to score an Ace. Null only if the unique spell's data is incomplete.
    // int difficulty
    test('to test the property `difficulty`', () async {
      // TODO
    });

    // String description
    test('to test the property `description`', () async {
      // TODO
    });

    // bool cantrip
    test('to test the property `cantrip`', () async {
      // TODO
    });

    // Whether this grant counts against a pool's slot_count. Every grant today is additive (false).
    // bool consumesSlot
    test('to test the property `consumesSlot`', () async {
      // TODO
    });

    // The card's special rule that explains this grant (e.g. Water Affinity, Major Arcana, Dagonite Baptism, Creative Creation).
    // SpellRuleRef rule
    test('to test the property `rule`', () async {
      // TODO
    });

    // Whether this spell has been marked cast this round (see PATCH .../spell_casts). Always false outside a live game.
    // bool cast
    test('to test the property `cast`', () async {
      // TODO
    });

  });
}
