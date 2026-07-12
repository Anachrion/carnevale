import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/cards_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

/// The faction row must show all seven factions at any screen width. It used to be a horizontal
/// ListView of fixed-width chips, so on a narrow phone the last one (Rashaar) sat off-screen behind
/// a sideways scroll — a filter you can't see is a filter you don't know you have.
void main() {
  const factions = [
    'guild',
    'doctors',
    'vatican',
    'patricians',
    'strigoi',
    'gifted',
    'rashaar',
  ];

  Future<void> pumpCardsAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([fakeProfile()], const FullType(api.Profile)),
    );
    await tester.pumpWidget(const MaterialApp(home: CardsScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  /// Each faction icon is a distinct asset, so finding one by its path is the honest check that it
  /// was actually laid out — not merely that seven chips of some kind exist.
  Finder factionIcon(String faction) => find.byWidgetPredicate(
    (w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName.contains(faction),
  );

  testWidgets(
    'lays out all seven factions on a narrow phone, without overflowing',
    (tester) async {
      // 360px is where the old fixed chips (7 x 56px + 32px padding = 424px) overflowed.
      await pumpCardsAt(tester, const Size(360, 800));

      for (final faction in factions) {
        expect(
          factionIcon(faction),
          findsOneWidget,
          reason: 'missing $faction',
        );
      }
      // A RenderFlex overflow surfaces as an exception during layout.
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('still fits all seven on the narrowest phones', (tester) async {
    await pumpCardsAt(tester, const Size(320, 700));

    for (final faction in factions) {
      expect(factionIcon(faction), findsOneWidget, reason: 'missing $faction');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('the last faction sits on screen and filters when tapped', (
    tester,
  ) async {
    await pumpCardsAt(tester, const Size(360, 800));

    // Rashaar is the one that used to be pushed past the right edge. Assert it is actually within
    // the viewport, then tap it where it sits — no scrolling — to prove it's genuinely reachable.
    final rashaar = factionIcon('rashaar');
    expect(tester.getRect(rashaar).right, lessThanOrEqualTo(360.0));

    await tester.tap(rashaar);
    await tester.pump();

    // The fake catalog holds a single guild profile, so filtering to Rashaar empties the list —
    // which only happens if the tap actually landed on the chip and toggled the filter.
    expect(find.text('No profiles found.'), findsOneWidget);
  });
}
