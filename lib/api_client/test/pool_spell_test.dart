import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

// tests for PoolSpell
void main() {
  final instance = PoolSpellBuilder();
  // TODO add properties to the builder and call build()

  group(PoolSpell, () {
    // Identifies this spell for PATCH .../spell_casts (UpdateSpellCastInput.spell_cast.key) — pass it back verbatim, don't try to construct it from `id`.
    // String key
    test('to test the property `key`', () async {
      // TODO
    });

    // int id
    test('to test the property `id`', () async {
      // TODO
    });

    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // String discipline
    test('to test the property `discipline`', () async {
      // TODO
    });

    // Will Points spent to attempt the spell.
    // int cost
    test('to test the property `cost`', () async {
      // TODO
    });

    // Magic Roll result needed to score an Ace.
    // int difficulty
    test('to test the property `difficulty`', () async {
      // TODO
    });

    // Whether this is the Discipline's free Cantrip (always known, not counted against the pool's slot_count).
    // bool cantrip
    test('to test the property `cantrip`', () async {
      // TODO
    });

    // String description
    test('to test the property `description`', () async {
      // TODO
    });

    // Whether this spell has been marked cast this round (see PATCH .../spell_casts). Always false outside a live game.
    // bool cast
    test('to test the property `cast`', () async {
      // TODO
    });

  });
}
