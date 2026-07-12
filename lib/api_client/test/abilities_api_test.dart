import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

/// tests for AbilitiesApi
void main() {
  final instance = CarnevaleApi().getAbilitiesApi();

  group(AbilitiesApi, () {
    // List all glossary abilities (character and weapon special rules)
    //
    //Future<BuiltList<Ability>> getAbilities({ String category }) async
    test('test getAbilities', () async {
      // TODO
    });
  });
}
