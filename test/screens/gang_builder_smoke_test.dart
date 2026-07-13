import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gang_builder_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('GangBuilderScreen renders the gang and its entries', (
    tester,
  ) async {
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(name: 'Capodecina'),
      ], const FullType(api.Profile)),
    );
    adapter.stub(
      'GET',
      '/equipment',
      listBody<api.Equipment>([], const FullType(api.Equipment)),
    );
    adapter.stub(
      'GET',
      '/spells',
      listBody<api.Spell>([], const FullType(api.Spell)),
    );

    final gang = fakeModelList(
      name: 'The Rooks',
      entries: [fakeListEntry(name: 'Capodecina')],
    );

    await tester.pumpWidget(MaterialApp(home: GangBuilderScreen(gang: gang)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('The Rooks'), findsOneWidget);
    expect(find.text('Capodecina'), findsWidgets);
  });
}
