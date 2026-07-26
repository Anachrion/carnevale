import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/card_viewer_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

void main() {
  testWidgets('CardViewerScreen renders the card pager for the given profiles', (
    tester,
  ) async {
    final profiles = [
      fakeProfile(name: 'Capodecina'),
      fakeProfile(id: 2, name: 'Bombardier'),
    ];

    await tester.pumpWidget(
      localizedApp(home: CardViewerScreen(profiles: profiles, initialIndex: 0)),
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
      localizedApp(home: CardViewerScreen(profiles: profiles, initialIndex: 0)),
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

  testWidgets(
    'Swiping to another card keeps showing the same side (front/back)',
    (tester) async {
      // Flip-to-reveal only exists in the single-face layout, so pin the viewport to portrait:
      // the default 800x600 test surface is landscape enough (ratio >= 1.2) that _showBothFaces
      // kicks in and renders front and back together, leaving nothing to flip.
      tester.view.physicalSize = const Size(600, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final profiles = [
        fakeProfile(
          name: 'Capodecina',
          cardReferences: [
            fakeCardReference(
              cardFront: 'p1_front.png',
              cardBack: 'p1_back.png',
            ),
          ],
        ),
        fakeProfile(
          id: 2,
          name: 'Bombardier',
          cardReferences: [
            fakeCardReference(
              cardFront: 'p2_front.png',
              cardBack: 'p2_back.png',
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        localizedApp(home: CardViewerScreen(profiles: profiles, initialIndex: 0)),
      );
      await tester.pump();

      Finder shown(String path) => find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == '_CardImage' && (w as dynamic).path == path,
      );

      expect(shown('p1_front.png'), findsOneWidget);
      expect(shown('p1_back.png'), findsNothing);

      // Flip to the back of card 1.
      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();
      expect(shown('p1_back.png'), findsOneWidget);
      expect(shown('p1_front.png'), findsNothing);

      // Swipe up to navigate to card 2 — should still show its back, not reset to front.
      await tester.drag(find.byType(PageView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(shown('p2_back.png'), findsOneWidget);
      expect(shown('p2_front.png'), findsNothing);
    },
  );
}
