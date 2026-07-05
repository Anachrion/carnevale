import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';


/// tests for SpellsApi
void main() {
  final instance = CarnevaleApi().getSpellsApi();

  group(SpellsApi, () {
    // List all spells, optionally filtered by Discipline
    //
    //Future<BuiltList<Spell>> getSpells({ String discipline }) async
    test('test getSpells', () async {
      // TODO
    });

  });
}
