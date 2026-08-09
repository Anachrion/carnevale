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
    alternateIdentifier: 'strigoi-the-beast-within',
    alternateName: 'The Beast Within',
    // Already wounded and a Will Point down, so the transform has something to carry across.
    state: fakeEntryState(lifePoints: 12),
  );

  // What the server answers with: the same entry, same id, same state — only the form has changed.
  final beast = fakeListEntry(
    id: 9,
    position: 2,
    name: 'The Beast Within',
    entryId: 78,
    // Still the hire's cost: transforming never moves what the gang paid.
    cost: 23,
    transformable: true,
    transformed: true,
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
      modelListBody(fakeModelList(name: 'Foe Gang', entries: [yune])),
    );
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(id: 1, name: 'Capodecina', faction: 'guild'),
        fakeProfile(
          id: 2,
          name: 'Yune Lobravym',
          faction: 'strigoi',
          cardReferences: [fakeCardReference(id: 77)],
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
        fakeModelList(name: 'My Gang', entries: [capodecina, beast]),
      ),
    );
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', entries: [capodecina, yune]),
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
      myGang: fakeModelList(name: 'My Gang', entries: [capodecina, yune]),
    );

    // Two models on the board, one transform button: an ordinary model has one card and no swap.
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.byIcon(Icons.sync_alt), findsOneWidget);
  });

  testWidgets("offers no transform button on the opponent's models", (
    tester,
  ) async {
    final adapter = installFakeApi();
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', entries: [capodecina]),
    );

    await tester.tap(find.text('Foe'));
    await tester.pumpAndSettle();

    // The opponent's Yune is transformable, but you don't move their models — same reasoning as
    // activation and every other in-game control.
    expect(find.text('Yune Lobravym'), findsOneWidget);
    expect(find.byIcon(Icons.sync_alt), findsNothing);
  });
}
