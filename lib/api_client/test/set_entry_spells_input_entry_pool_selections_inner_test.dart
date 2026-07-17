import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

// tests for SetEntrySpellsInputEntryPoolSelectionsInner
void main() {
  final instance = SetEntrySpellsInputEntryPoolSelectionsInnerBuilder();
  // TODO add properties to the builder and call build()

  group(SetEntrySpellsInputEntryPoolSelectionsInner, () {
    // Id of one of this model's pools (see ListEntry.pools[].id).
    // int poolId
    test('to test the property `poolId`', () async {
      // TODO
    });

    // The discipline(s) committed for this pool — usually one, up to the pool's `of` count for a multi-discipline pool (Doctor of the Firmament). 
    // BuiltList<String> disciplines
    test('to test the property `disciplines`', () async {
      // TODO
    });

    // The exact set of known (non-Cantrip) spell ids for this pool.
    // BuiltList<int> spellIds
    test('to test the property `spellIds`', () async {
      // TODO
    });

  });
}
