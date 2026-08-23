import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/card_viewer_screen.dart';
import 'package:carnevale/services/settings_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// Finds the [_CardImage] currently showing [path]. Private to card_viewer_screen, so it is matched
/// by runtime type name rather than imported.
Finder shown(String path) => find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == '_CardImage' && (w as dynamic).path == path,
);

/// Two profiles with known front/back image paths, so assertions can name the exact face on screen.
List<api.Profile> twoCardProfiles() => [
  fakeProfile(
    name: 'Capodecina',
    cardReferences: [
      fakeCardReference(cardFront: 'p1_front.png', cardBack: 'p1_back.png'),
    ],
  ),
  fakeProfile(
    id: 2,
    name: 'Bombardier',
    cardReferences: [
      fakeCardReference(cardFront: 'p2_front.png', cardBack: 'p2_back.png'),
    ],
  ),
];

/// Pins the viewport for one test and restores it afterwards. The default 800x600 test surface is
/// landscape, which is load-bearing for the dual-face layout — every test that cares about which
/// layout it gets must say so explicitly rather than inherit it.
void useViewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

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

    // The pager is built over both profiles. (It used to be checked through the "1 / 2" position
    // indicator, which went with the navigation hint in CARNEVALEB-76.)
    expect(find.byType(PageView), findsOneWidget);
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
    final screen = tester.getSize(find.byType(Scaffold));

    // Bottom right: below the close button it used to sit beside, and right of centre.
    expect(
      tester.getCenter(button).dy,
      greaterThan(tester.getCenter(close).dy),
    );
    expect(tester.getCenter(button).dx, greaterThan(screen.width / 2));
    // Still on the bottom bar: below the card, not floating in the middle of the screen. The
    // collection button shares this row when someone is logged in; nobody is here.
    expect(tester.getCenter(button).dy, greaterThan(screen.height * 0.75));

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
      useViewport(tester, const Size(600, 900));

      final profiles = twoCardProfiles();

      await tester.pumpWidget(
        localizedApp(home: CardViewerScreen(profiles: profiles, initialIndex: 0)),
      );
      await tester.pump();

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

  // The dual-face layout replaces the flippable single face when the user preference is on AND the
  // viewport is landscape enough (width >= height * 1.2). Both halves of that gate matter: it was
  // the untested landscape default that silently broke the flip test above.
  group('dual-face landscape layout', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    // SettingsService is a process-wide singleton, so a test that turns the preference off would
    // leak into every later test in this file if it were not put back.
    tearDown(() async {
      await SettingsService().setBothFacesLandscape(true);
    });

    Future<void> pumpViewer(WidgetTester tester, Size size) async {
      useViewport(tester, size);
      await tester.pumpWidget(
        localizedApp(
          home: CardViewerScreen(profiles: twoCardProfiles(), initialIndex: 0),
        ),
      );
      await tester.pump();
    }

    testWidgets('shows front and back together in landscape', (tester) async {
      await pumpViewer(tester, const Size(1000, 600));

      expect(shown('p1_front.png'), findsOneWidget);
      expect(shown('p1_back.png'), findsOneWidget);
    });

    testWidgets('tapping does not flip when both faces are already up', (
      tester,
    ) async {
      await pumpViewer(tester, const Size(1000, 600));

      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();

      // Still both faces: there is no hidden side to reveal, so the tap is inert rather than
      // swapping the pair out for a single flipped face.
      expect(shown('p1_front.png'), findsOneWidget);
      expect(shown('p1_back.png'), findsOneWidget);
    });

    testWidgets('keeps a single face in portrait', (tester) async {
      await pumpViewer(tester, const Size(600, 900));

      expect(shown('p1_front.png'), findsOneWidget);
      expect(shown('p1_back.png'), findsNothing);
    });

    testWidgets('keeps a single face in a nearly-square window', (tester) async {
      // Landscape, but ratio 1.125 < 1.2: too cramped for two portrait faces side by side.
      await pumpViewer(tester, const Size(900, 800));

      expect(shown('p1_front.png'), findsOneWidget);
      expect(shown('p1_back.png'), findsNothing);
    });

    testWidgets('keeps a single face in landscape when the preference is off', (
      tester,
    ) async {
      await SettingsService().setBothFacesLandscape(false);
      await pumpViewer(tester, const Size(1000, 600));

      expect(shown('p1_front.png'), findsOneWidget);
      expect(shown('p1_back.png'), findsNothing);
    });

    testWidgets('only the current card shows both faces', (tester) async {
      await pumpViewer(tester, const Size(1000, 600));

      // Card 2 is off-screen but built by the PageView; it must not also render a pair.
      expect(shown('p2_front.png'), findsNothing);
      expect(shown('p2_back.png'), findsNothing);
    });
  });
}
