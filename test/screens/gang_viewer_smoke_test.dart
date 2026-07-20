import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/card_viewer_screen.dart';
import 'package:carnevale/screens/gang_viewer_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale/services/profile_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets(
    'GameGangsScreen renders a player\'s gang with card and equipment entries',
    (tester) async {
      AuthService().debugLogin(
        const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
      );
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
      adapter.stub(
        'GET',
        '/games/1/players/3/list',
        modelListBody(fakeModelList(name: 'Foe Gang')),
      );
      adapter.stub(
        'GET',
        '/profiles',
        listBody<api.Profile>([fakeProfile()], const FullType(api.Profile)),
      );
      adapter.stub(
        'GET',
        '/equipment',
        listBody<api.Equipment>([], const FullType(api.Equipment)),
      );

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
    },
  );

  // A-11: a failed first load used to be a dead end ("Could not load this gang." with no way out);
  // now it offers a Retry that re-fetches.
  testWidgets('offers a retry when the gang fails to load, then recovers', (
    tester,
  ) async {
    AuthService().debugLogin(
      const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
    );
    final adapter = installFakeApi();
    // The opponent tab loads fine; only my gang's list is left unstubbed, so it 404s.
    adapter.stub(
      'GET',
      '/games/1/players/3/list',
      modelListBody(fakeModelList(name: 'Foe Gang')),
    );

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

    expect(find.text('Could not load this gang.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    // The list (and the catalog halves the first load needs) are now reachable.
    adapter.stub(
      'GET',
      '/games/1/players/2/list',
      modelListBody(
        fakeModelList(name: 'My Gang', entries: [fakeListEntry(name: 'Capodecina')]),
      ),
    );
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([fakeProfile()], const FullType(api.Profile)),
    );
    adapter.stub(
      'GET',
      '/equipment',
      listBody<api.Equipment>([], const FullType(api.Equipment)),
    );

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Could not load this gang.'), findsNothing);
    expect(find.text('Capodecina'), findsWidgets);
  });

  // CARNEVALEB-43: the card viewer must open on the illustration each entry was actually hired
  // as, not always the profile's first — matters for A/B-pair models (one profile hired twice via
  // two different card references).
  testWidgets(
    'Tapping an A/B-pair entry opens the card viewer on the illustration it was hired as',
    (tester) async {
      AuthService().debugLogin(
        const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
      );
      // The catalog is cached for the process lifetime (ProfileService); earlier tests in this
      // file already populated it, so it must be dropped before stubbing a different catalog.
      ProfileService().reset();
      final adapter = installFakeApi();

      final abProfile = fakeProfile(
        name: 'La Fattucchiera',
        cardReferences: [
          fakeCardReference(
            id: 10,
            identifier: 'la-fattucchiera-a',
            profileName: 'La Fattucchiera',
          ),
          fakeCardReference(
            id: 11,
            identifier: 'la-fattucchiera-b',
            profileName: 'La Fattucchiera',
          ),
        ],
      );

      final myGang = fakeModelList(
        name: 'My Gang',
        entries: [
          fakeListEntry(id: 1, position: 1, name: 'La Fattucchiera A', entryId: 10),
          fakeListEntry(id: 2, position: 2, name: 'La Fattucchiera B', entryId: 11),
        ],
      );
      adapter.stub('GET', '/games/1/players/2/list', modelListBody(myGang));
      adapter.stub(
        'GET',
        '/games/1/players/3/list',
        modelListBody(fakeModelList(name: 'Foe Gang')),
      );
      adapter.stub(
        'GET',
        '/profiles',
        listBody<api.Profile>([abProfile], const FullType(api.Profile)),
      );
      adapter.stub(
        'GET',
        '/equipment',
        listBody<api.Equipment>([], const FullType(api.Equipment)),
      );

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

      await tester.tap(find.text('La Fattucchiera B'));
      await tester.pumpAndSettle();

      final viewer = tester.widget<CardViewerScreen>(
        find.byType(CardViewerScreen),
      );
      expect(viewer.initialIndex, 1);
      expect(viewer.selectedReferenceIds, [10, 11]);
    },
  );
}
