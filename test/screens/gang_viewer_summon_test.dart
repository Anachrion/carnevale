import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gang_viewer_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// Summoning: the rare models whose special rules conjure new models onto the board mid-battle.
/// The summoned model joins the (otherwise frozen) gang, costs it nothing, and is the only kind of
/// model that can be removed again.
void main() {
  const myPlayerId = 2;
  const opponentPlayerId = 3;

  final capodecina = fakeListEntry(name: 'Capodecina');
  final spawn = fakeListEntry(
    id: 9,
    position: 9,
    name: 'Ugdru Spawn',
    entryId: 77,
    // A distinct cost, so a test can prove this number is never printed for a summoned model.
    cost: 33,
    summoned: true,
    state: fakeEntryState(lifePoints: 6),
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
      modelListBody(fakeModelList(name: 'Foe Gang')),
    );
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(id: 1, name: 'Capodecina', faction: 'guild'),
        // Another faction entirely — a summon routinely reaches outside the gang's own faction,
        // which is exactly why the picker isn't restricted the way the Hire tab is.
        fakeProfile(
          id: 2,
          name: 'Ugdru Spawn',
          faction: 'rashaar',
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

  testWidgets('summons a model from another faction into the gang', (
    tester,
  ) async {
    final adapter = installFakeApi();
    // What the server returns once the spawn has been conjured in.
    adapter.stub(
      'POST',
      '/games/1/summons',
      modelListBody(
        fakeModelList(name: 'My Gang', entries: [capodecina, spawn]),
      ),
    );
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', entries: [capodecina]),
    );

    expect(find.text('Ugdru Spawn'), findsNothing);

    await tester.tap(find.text('Summon'));
    await tester.pumpAndSettle();

    // The picker searches the whole catalog, so a rashaar model is offered to a guild gang.
    await tester.enterText(find.byType(TextField), 'ugdru');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ugdru Spawn').last);
    await tester.pumpAndSettle();

    // It's on the board, with an entry state of its own — so it can take damage, carry counters and
    // activate exactly like a hired model. (The fixture's starting HP is 10.)
    expect(find.text('Ugdru Spawn'), findsOneWidget);
    expect(find.text('HP 6/10'), findsOneWidget);
  });

  testWidgets('shows a summoned model as costing nothing', (tester) async {
    final adapter = installFakeApi();
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', entries: [capodecina, spawn]),
    );

    // The summoned model prints a dash rather than its ducat value, because it never cost the gang
    // anything — the server leaves it out of total_cost for the same reason.
    expect(find.text('—'), findsOneWidget);
    expect(find.text('33'), findsNothing);
  });

  testWidgets('offers to remove a summoned model, but not a hired one', (
    tester,
  ) async {
    final adapter = installFakeApi();
    adapter.stub(
      'DELETE',
      '/games/1/summons/9',
      modelListBody(fakeModelList(name: 'My Gang', entries: [capodecina])),
    );
    await pumpGangs(
      tester,
      adapter,
      myGang: fakeModelList(name: 'My Gang', entries: [capodecina, spawn]),
    );

    // Exactly one remove button, on the summoned model — the hired roster is frozen for the game.
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Ugdru Spawn'), findsNothing);
    expect(find.text('Capodecina'), findsOneWidget);
  });

  testWidgets('offers no summon button on the opponent\'s gang', (
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

    expect(find.text('Summon'), findsNothing);
  });
}
