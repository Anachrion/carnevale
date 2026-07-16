import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/card_viewer_screen.dart';
import 'package:carnevale/screens/gang_builder_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('Hire tab pages through faction profiles before mercenaries', (
    tester,
  ) async {
    // Under the default role sort, the gifted Hero outranks the faction's own rank-and-file,
    // so sorting on role alone interleaves it between them.
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(
          id: 1,
          name: 'Il Dottore',
          faction: 'gifted',
          ducats: 12,
          keywords: const ['Hero'],
        ),
        fakeProfile(id: 2, name: 'Capodecina', faction: 'guild', ducats: 20),
        fakeProfile(
          id: 3,
          name: 'Colombina',
          faction: 'gifted',
          ducats: 10,
          keywords: const [],
        ),
        fakeProfile(
          id: 4,
          name: 'Bravoes',
          faction: 'guild',
          ducats: 30,
          keywords: const [],
        ),
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

    final gang = fakeModelList(name: 'The Rooks', entries: []);

    await tester.pumpWidget(MaterialApp(home: GangBuilderScreen(gang: gang)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Hire'));
    await tester.pump();
    // Let the 250ms tab-switch PageView animation finish, so the Hire tab's tiles are built before
    // we tap one — a single pump lands mid-animation, before they exist.
    await tester.pump(const Duration(milliseconds: 400));

    // Open the card viewer from a faction tile; swiping up/down pages through the
    // list it was handed, which must carry the mercenaries last.
    await tester.tap(find.text('Capodecina').first);
    await tester.pumpAndSettle();

    final viewer = tester.widget<CardViewerScreen>(
      find.byType(CardViewerScreen),
    );
    expect(viewer.profiles.map((p) => p.name).toList(), [
      'Capodecina',
      'Bravoes',
      'Il Dottore',
      'Colombina',
    ]);
    // ...and it opened on the card that was actually tapped.
    expect(viewer.profiles[viewer.initialIndex].name, 'Capodecina');
  });
}
