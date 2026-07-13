import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/card_viewer_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('CardViewerScreen renders the card pager for the given profiles', (
    tester,
  ) async {
    final profiles = [
      fakeProfile(name: 'Capodecina'),
      fakeProfile(id: 2, name: 'Bombardier'),
    ];

    await tester.pumpWidget(
      MaterialApp(home: CardViewerScreen(profiles: profiles, initialIndex: 0)),
    );
    await tester.pump();

    // The page indicator reflects position/count (reached via the ProfileX front/back image getters).
    expect(find.textContaining('1 / 2'), findsOneWidget);
  });

  testWidgets('The abilities button sits at the bottom right and opens the sheet', (
    tester,
  ) async {
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/abilities',
      listBody<api.Ability>([], const FullType(api.Ability)),
    );

    final profiles = [fakeProfile(name: 'Capodecina')];

    await tester.pumpWidget(
      MaterialApp(home: CardViewerScreen(profiles: profiles, initialIndex: 0)),
    );
    await tester.pump();

    final button = find.widgetWithText(TextButton, 'Abilities');
    final close = find.byIcon(Icons.close);
    final hint = find.textContaining('flip');
    final screen = tester.getSize(find.byType(Scaffold));

    // Bottom right: below the close button it used to sit beside, and right of centre.
    expect(
      tester.getCenter(button).dy,
      greaterThan(tester.getCenter(close).dy),
    );
    expect(tester.getCenter(button).dx, greaterThan(screen.width / 2));
    // On the same line as the flip/swipe hint, which sits on the left.
    expect(tester.getCenter(button).dy, closeTo(tester.getCenter(hint).dy, 1));
    expect(tester.getCenter(hint).dx, lessThan(screen.width / 2));

    // The button is laid out at its natural height rather than being squashed by its parent and
    // painted with its top and bottom edges clipped off.
    expect(tester.getRect(button).height, greaterThanOrEqualTo(36));

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(
      find.text('This character has no special abilities.'),
      findsOneWidget,
    );
  });
}
