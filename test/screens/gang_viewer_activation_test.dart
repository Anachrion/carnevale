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

  /// The model names in the order they are actually laid out down the list — the whole point of the
  /// death reorder, so assert on what's rendered rather than on any internal list.
  ///
  /// Scoped to the list itself: an open stat/counter dialog is titled with the model's name too, and
  /// would otherwise be counted as a second row for that model.
  List<String?> rowOrder(WidgetTester tester) {
    const names = ['Bruno', 'Vitali', 'Enzo'];
    return tester
        .widgetList<Text>(
          find.descendant(
            of: find.byType(AnimatedList),
            matching: find.byType(Text),
          ),
        )
        .map((t) => t.data)
        .where(names.contains)
        .toList();
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
    // The tile's background is animated (it's what makes a death visible), so let it land before
    // reading the gradient — mid-flight it's an interpolation between the two.
    await tester.pumpAndSettle();

    expect(isDarkened(tester, 'Vitali', guild), isTrue);
  });

  testWidgets('sinks a killed model to the bottom of the gang, with a skull', (
    tester,
  ) async {
    final adapter = installFakeApi();
    final myGang = fakeModelList(
      name: 'My Gang',
      entries: [
        // Dead, but first in the roster — it must still end up last on screen.
        fakeListEntry(name: 'Bruno', state: fakeEntryState(lifePoints: 0)),
        fakeListEntry(
          id: 2,
          position: 2,
          name: 'Vitali',
          state: fakeEntryState(lifePoints: 6),
        ),
        fakeListEntry(
          id: 3,
          position: 3,
          name: 'Enzo',
          state: fakeEntryState(lifePoints: 4),
        ),
      ],
    );
    await pumpGangs(
      tester,
      adapter,
      myGang: myGang,
      foeGang: fakeModelList(name: 'Foe Gang'),
    );

    // The living gang stays together at the top, in roster order; the casualty drops below them.
    expect(rowOrder(tester), ['Vitali', 'Enzo', 'Bruno']);

    expect(find.text('💀'), findsOneWidget);
    // Dead drops the faction color entirely, rather than merely darkening it like an activation.
    expect(
      gradientOf(tester, 'Bruno'),
      AppPalette.entryTileGradient(AppPalette.deadEntry),
    );
    expect(gradientOf(tester, 'Vitali'), AppPalette.entryTileGradient(guild));
  });

  testWidgets(
    'a model that dies stays put while it turns, then drops to the bottom',
    (tester) async {
      final adapter = installFakeApi();
      final myGang = fakeModelList(
        name: 'My Gang',
        entries: [
          fakeListEntry(name: 'Bruno', state: fakeEntryState(lifePoints: 1)),
          fakeListEntry(
            id: 2,
            position: 2,
            name: 'Vitali',
            state: fakeEntryState(lifePoints: 6),
          ),
        ],
      );
      // Bruno takes his last point of damage.
      adapter.stub(
        'PATCH',
        '/games/1/entries/1/stats',
        entryStateBody(fakeEntryState(lifePoints: 0)),
      );
      await pumpGangs(
        tester,
        adapter,
        myGang: myGang,
        foeGang: fakeModelList(name: 'Foe Gang'),
      );

      expect(rowOrder(tester), ['Bruno', 'Vitali']);

      await tester.tap(find.text('HP 1/10'));
      await tester.pumpAndSettle();
      final lifeRow = find
          .ancestor(of: find.text('Life Points'), matching: find.byType(Row))
          .first;
      await tester.tap(
        find.descendant(of: lifeRow, matching: find.byIcon(Icons.remove)),
      );
      await tester.pump();

      // Beat one: he has died, and the skull is in — but he is still standing in his own place, so
      // you actually watch it happen rather than seeing a card teleport.
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('💀'), findsOneWidget);
      expect(rowOrder(tester), ['Bruno', 'Vitali']);

      // Beat two: the body is carried off and the living close ranks.
      await tester.pumpAndSettle();
      expect(rowOrder(tester), ['Vitali', 'Bruno']);
    },
  );

  testWidgets('a model healed back above 0 is alive again', (tester) async {
    final adapter = installFakeApi();
    final myGang = fakeModelList(
      name: 'My Gang',
      entries: [
        fakeListEntry(name: 'Vitali', state: fakeEntryState(lifePoints: 0)),
      ],
    );
    // Death is derived from HP, so healing through the ordinary stats endpoint revives the model —
    // there is no separate "un-kill" action to get out of step with the HP shown beside it.
    adapter.stub(
      'PATCH',
      '/games/1/entries/1/stats',
      entryStateBody(fakeEntryState(lifePoints: 5)),
    );
    await pumpGangs(
      tester,
      adapter,
      myGang: myGang,
      foeGang: fakeModelList(name: 'Foe Gang'),
    );

    expect(find.text('💀'), findsOneWidget);

    // Heal it through the ordinary HP stepper — the pill reads "HP 0/10".
    await tester.tap(find.text('HP 0/10'));
    await tester.pumpAndSettle();

    // Scoped to the Life Points row: the tile behind the dialog has an add-counter button that is
    // also an Icons.add, and it comes first in the tree.
    final lifeRow = find
        .ancestor(of: find.text('Life Points'), matching: find.byType(Row))
        .first;
    await tester.tap(
      find.descendant(of: lifeRow, matching: find.byIcon(Icons.add)),
    );
    // The revival is optimistic now — death mirrors HP locally — so a single pump already brings the
    // model back, no round-trip needed.
    await tester.pump();
    expect(find.text('💀'), findsNothing);

    // The save is debounced (~900ms after the last tap); advance past it and settle the round-trip so
    // no timer is left pending.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('💀'), findsNothing);
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
