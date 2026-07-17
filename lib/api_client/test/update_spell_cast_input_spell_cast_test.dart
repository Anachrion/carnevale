import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

// tests for UpdateSpellCastInputSpellCast
void main() {
  final instance = UpdateSpellCastInputSpellCastBuilder();
  // TODO add properties to the builder and call build()

  group(UpdateSpellCastInputSpellCast, () {
    // Identifies the spell within this model — copy it verbatim from the `key` field of the PoolSpell/GrantedSpell being marked (see ListEntry.pools[].spells[]/cantrips[] and ListEntry.granted_spells[]). Opaque; don't try to construct it client-side. 
    // String key
    test('to test the property `key`', () async {
      // TODO
    });

    // The desired state (true = mark cast, false = clear it) rather than a toggle.
    // bool cast
    test('to test the property `cast`', () async {
      // TODO
    });

  });
}
