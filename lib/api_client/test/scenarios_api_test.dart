import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

/// tests for ScenariosApi
void main() {
  final instance = CarnevaleApi().getScenariosApi();

  group(ScenariosApi, () {
    // List all scenarios
    //
    //Future<BuiltList<Scenario>> getScenarios() async
    test('test getScenarios', () async {
      // TODO
    });
  });
}
