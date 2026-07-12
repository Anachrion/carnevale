import 'package:built_value/serializer.dart';
import 'package:carnevale/app_palette.dart';
import 'package:carnevale/screens/gang_viewer_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

/// The activation marker ("has this model gone this turn?") darkens a model tile's background, so a
/// player can see at a glance who is still to activate. These drive the real service -> generated
/// client stack, so they also cover the `activated` field surviving (de)serialization.
void main() {
  const myPlayerId = 2;
  const opponentPlayerId = 3;
  // The faction the fake gang fixtures use, so the expected tile gradient can be derived from it.
  final guild = AppPalette.factionColors['guild']!;

  // An activated model is marked by darkening its tile's *background* only, so assert on the
  // gradient of the Container behind the model's name (the closest one above it) rather than on
  // any opacity — the name, stats and counters all stay at full strength.
  Gradient gradientOf(WidgetTester tester, String modelName) {
    final container = tester.widget<Container>(
      find
          .ancestor(of: find.text(modelName), matching: find.byType(Container))
          .first,
    );
    return (container.decoration! as BoxDecoration).gradient!;
  }

  bool isDarkened(WidgetTester tester, String modelName, Color factionColor) {
    final expected = AppPalette.entryTileGradient(factionColor, dimmed: true);
    return gradientOf(tester, modelName) == expected;
  }

  Future<void> pumpGangs(
    WidgetTester tester,
    FakeApiAdapter adapter, {
    required api.ModelList myGang,
    required api.ModelList foeGang,
  }) async {
    adapter.stub(
      'GET',
      '/games/1/players/$myPlayerId/list',
      modelListBody(myGang),
    );
    adapter.stub(
      'GET',
      '/games/1/players/$opponentPlayerId/list',
      modelListBody(foeGang),
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
          myPlayerId: myPlayerId,
          myLabel: 'Me',
          opponentPlayerId: opponentPlayerId,
          opponentLabel: 'Foe',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  setUp(() {
    AuthService().debugLogin(
      const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
    );
  });

  testWidgets(
    'darkens the tile of a model that has already activated, and leaves the rest solid',
    (tester) async {
      final adapter = installFakeApi();
      final myGang = fakeModelList(
        name: 'My Gang',
        entries: [
          fakeListEntry(
            name: 'Vitali',
            state: fakeEntryState(activated: false),
          ),
          fakeListEntry(
            id: 2,
            position: 2,
            name: 'Bruno',
            state: fakeEntryState(activated: true),
          ),
        ],
      );
      await pumpGangs(
        tester,
        adapter,
        myGang: myGang,
        foeGang: fakeModelList(name: 'Foe Gang'),
      );

      expect(isDarkened(tester, 'Vitali', guild), isFalse);
      expect(isDarkened(tester, 'Bruno', guild), isTrue);
    },
  );

  testWidgets('tapping the bolt activates a model and darkens its tile', (
    tester,
  ) async {
    final adapter = installFakeApi();
    final myGang = fakeModelList(
      name: 'My Gang',
      entries: [
        fakeListEntry(name: 'Vitali', state: fakeEntryState(activated: false)),
      ],
    );
    // What the server sends back once it has stamped the model with the current turn.
    adapter.stub(
      'PATCH',
      '/games/1/entries/1/counters',
      entryStateBody(fakeEntryState(activated: true)),
    );
    await pumpGangs(
      tester,
      adapter,
      myGang: myGang,
      foeGang: fakeModelList(name: 'Foe Gang'),
    );

    expect(isDarkened(tester, 'Vitali', guild), isFalse);

    await tester.tap(find.byIcon(Icons.bolt));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(isDarkened(tester, 'Vitali', guild), isTrue);
  });

  testWidgets('offers no activation toggle on the opponent\'s models', (
    tester,
  ) async {
    final adapter = installFakeApi();
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang'),
      foeGang: fakeModelList(
        name: 'Foe Gang',
        entries: [
          fakeListEntry(
            name: 'Nemico',
            state: fakeEntryState(activated: false),
          ),
        ],
      ),
    );

    // Switch to the opponent's tab. Their un-activated model shows no bolt at all — it's their
    // gang to activate, not ours; we only ever *see* the result.
    await tester.tap(find.text('Foe'));
    await tester.pumpAndSettle();

    expect(find.text('Nemico'), findsWidgets);
    expect(find.byIcon(Icons.bolt), findsNothing);
  });
}
