import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gang_viewer_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// Violent Transformation: Yune Lobravym and The Beast Within are one model with two printed cards.
/// The rule has the two forms share their Life, Will and Command Points "including any that have
/// been lost", so the swap is one entry changing form rather than two models being juggled — and
/// the points must survive it untouched.
/// Finds the card face currently on screen by its image path. _CardImage is private to
/// card_viewer_screen, so it is matched by runtime type name — same approach as
/// card_viewer_smoke_test. The card's name is drawn into the art, so this is the only way to assert
/// *which* card the viewer opened.
Finder shownCard(String path) => find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == '_CardImage' && (w as dynamic).path == path,
);

void main() {
  const myPlayerId = 2;
  const opponentPlayerId = 3;

  final capodecina = fakeListEntry(name: 'Capodecina');

  final yune = fakeListEntry(
    id: 9,
    position: 2,
    name: 'Yune Lobravym',
    entryId: 77,
    cost: 23,
    transformable: true,
    identifier: 'strigoi-yune-lobravym',
    alternateIdentifier: 'strigoi-the-beast-within',
    alternateName: 'The Beast Within',
    // Already wounded, so the transform has something to carry across.
    state: fakeEntryState(lifePoints: 12),
  );

  // What the server answers with: the same entry, same id, same state — only the form has changed.
  final beast = fakeListEntry(
    id: 9,
    position: 2,
    name: 'The Beast Within',
    // Still Yune's card reference: `entryId` is the row the gang hired and paid for, and the server
    // deliberately leaves it alone across a transformation. Only `identifier` moves.
    entryId: 77,
    // Still the hire's cost: transforming never moves what the gang paid.
    cost: 23,
    transformable: true,
    transformed: true,
    identifier: 'strigoi-the-beast-within',
    alternateIdentifier: 'strigoi-yune-lobravym',
    alternateName: 'Yune Lobravym',
    state: fakeEntryState(lifePoints: 12),
  );

  Future<void> pumpGangs(
    WidgetTester tester,
    FakeApiAdapter adapter, {
    required api.ModelList myGang,
  }) async {
    adapter.stub(
      'GET',
      '/games/1/players/$myPlayerId/list',
      modelListBody(myGang),
    );
    adapter.stub(
      'GET',
      '/games/1/players/$opponentPlayerId/list',
      modelListBody(fakeModelList(name: 'Foe Gang', faction: 'strigoi', entries: [yune])),
    );
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(id: 1, name: 'Capodecina', faction: 'strigoi'),
        fakeProfile(
          id: 2,
          name: 'Yune Lobravym',
          faction: 'strigoi',
          cardReferences: [
            fakeCardReference(
              id: 77,
              identifier: 'strigoi-yune-lobravym',
              profileName: 'Yune Lobravym',
              cardFront: 'yune_front.png',
              cardBack: 'yune_back.png',
            ),
          ],
        ),
        // The Beast Within is a catalog profile of its own — non-recruitable, so the Hire tab and
        // the summon picker filter it out, but the viewer's profile list still carries it.
        fakeProfile(
          id: 3,
          name: 'The Beast Within',
          faction: 'strigoi',
          recruitable: false,
          cardReferences: [
            fakeCardReference(
              id: 78,
              identifier: 'strigoi-the-beast-within',
              profileName: 'The Beast Within',
              cardFront: 'beast_front.png',
              cardBack: 'beast_back.png',
            ),
          ],
        ),
      ], const FullType(api.Profile)),
    );
    adapter.stub(
      'GET',
      '/equipment',
      listBody<api.Equipment>([], const FullType(api.Equipment)),
    );

    await tester.pumpWidget(
      localizedApp(
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

  testWidgets('swaps the model to its other card, keeping its wounds', (
    tester,
  ) async {
    final adapter = installFakeApi();
    adapter.stub(
      'PATCH',
      '/games/1/entries/9/transform',
      modelListBody(
        fakeModelList(name: 'My Gang', faction: 'strigoi', entries: [capodecina, beast]),
      ),
    );
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', faction: 'strigoi', entries: [capodecina, yune]),
    );

    expect(find.text('Yune Lobravym'), findsOneWidget);
    expect(find.text('The Beast Within'), findsNothing);
    expect(find.text('HP 12/10'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.sync_alt));
    await tester.pumpAndSettle();

    // Same model, other card — and the damage it had taken came with it, because both forms share
    // the one entry state.
    expect(find.text('The Beast Within'), findsOneWidget);
    expect(find.text('Yune Lobravym'), findsNothing);
    expect(find.text('HP 12/10'), findsOneWidget);
  });

  testWidgets('offers the button only on a model that has another form', (
    tester,
  ) async {
    final adapter = installFakeApi();
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', faction: 'strigoi', entries: [capodecina, yune]),
    );

    // Two models on the board, one transform button: an ordinary model has one card and no swap.
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.byIcon(Icons.sync_alt), findsOneWidget);
  });

  // Regression: the tile said "The Beast Within" but tapping it opened Yune's card, because the
  // viewer resolved the profile from `entryId` — which deliberately still points at the hire.
  testWidgets('opens the card of the form the model is actually in', (
    tester,
  ) async {
    final adapter = installFakeApi();
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', faction: 'strigoi', entries: [capodecina, beast]),
    );

    await tester.tap(find.text('The Beast Within'));
    await tester.pumpAndSettle();

    // The name is printed inside the card art, so the face on screen is the only thing that says
    // which card this is. It must be the Beast's, even though the entry is still hired as — and
    // still costs — Yune.
    expect(shownCard('beast_front.png'), findsOneWidget);
    expect(shownCard('yune_front.png'), findsNothing);
  });

  testWidgets("offers no transform button on the opponent's models", (
    tester,
  ) async {
    final adapter = installFakeApi();
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', faction: 'strigoi', entries: [capodecina]),
    );

    await tester.tap(find.text('Foe'));
    await tester.pumpAndSettle();

    // The opponent's Yune is transformable, but you don't move their models — same reasoning as
    // activation and every other in-game control.
    expect(find.text('Yune Lobravym'), findsOneWidget);
    expect(find.byIcon(Icons.sync_alt), findsNothing);
  });
}
