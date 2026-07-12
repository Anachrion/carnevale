import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

/// tests for EquipmentApi
void main() {
  final instance = CarnevaleApi().getEquipmentApi();

  group(EquipmentApi, () {
    // List all equipment
    //
    //Future<BuiltList<Equipment>> getEquipment() async
    test('test getEquipment', () async {
      // TODO
    });
  });
}
