import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gang_viewer_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('GameGangsScreen renders a player\'s gang with card and equipment entries', (tester) async {
    AuthService().debugLogin(const AuthUser(id: 1, email: 'a@b.c', username: 'tester'));
    final adapter = installFakeApi();

    final myGang = fakeModelList(
      name: 'My Gang',
      entries: [
        fakeListEntry(name: 'Capodecina'),
        fakeListEntry(
          id: 2,
          position: 2,
          name: 'Blunderbuss',
          entryType: api.ListEntryEntryTypeEnum.catalogColonColonEquipment,
          entryId: 5,
          cost: 10,
        ),
      ],
    );
    adapter.stub('GET', '/games/1/players/2/list', modelListBody(myGang));
    adapter.stub('GET', '/games/1/players/3/list', modelListBody(fakeModelList(name: 'Foe Gang')));
    adapter.stub('GET', '/profiles', listBody<api.Profile>([fakeProfile()], const FullType(api.Profile)));
    adapter.stub('GET', '/equipment', listBody<api.Equipment>([], const FullType(api.Equipment)));

    await tester.pumpWidget(
      const MaterialApp(
        home: GameGangsScreen(
          gameId: 1,
          myPlayerId: 2,
          myLabel: 'Me',
          opponentPlayerId: 3,
          opponentLabel: 'Foe',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Capodecina'), findsWidgets);
    expect(find.text('Blunderbuss'), findsWidgets);
  });
}
