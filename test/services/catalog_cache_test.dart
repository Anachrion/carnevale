import 'package:built_value/serializer.dart';
import 'package:carnevale/services/catalog_cache.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('round-trips a catalog collection through storage', () async {
    SharedPreferences.setMockInitialValues({});

    await CatalogCache.save(
      'equipment',
      [fakeEquipment(id: 1, name: 'Gondola'), fakeEquipment(id: 2, name: 'Lantern')],
      const FullType(api.Equipment),
    );

    final restored = await CatalogCache.restore<api.Equipment>(
      'equipment',
      const FullType(api.Equipment),
    );

    expect(restored, isNotNull);
    expect(restored!.map((e) => e.name), ['Gondola', 'Lantern']);
  });

  test('returns null when nothing has been saved', () async {
    SharedPreferences.setMockInitialValues({});

    final restored = await CatalogCache.restore<api.Equipment>(
      'missing',
      const FullType(api.Equipment),
    );

    expect(restored, isNull);
  });
}
