import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/cards_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale/services/collection_service.dart';
import 'package:carnevale/services/profile_service.dart';
import 'package:carnevale/widgets/collection_glyph.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

void main() {
  const profileType = FullType(api.Profile);
  const itemType = FullType(api.CollectionItem);

  late FakeApiAdapter adapter;

  final catalogue = [
    fakeProfile(id: 1, name: 'Beggar', ducats: 6, keywords: const []),
    fakeProfile(id: 2, name: 'Gondolier', ducats: 11, keywords: const []),
  ];

  setUp(() async {
    adapter = installFakeApi();
    ProfileService().reset();
    await CollectionService().reset();
    adapter.stub('GET', '/profiles', listBody(catalogue, profileType));
    adapter.stub(
      'GET',
      '/collection',
      listBody([
        fakeCollectionItem(profileId: 1, owned: 2, built: 1),
      ], itemType),
    );
  });

  tearDown(() async {
    await AuthService().logOut();
  });

  // pump() rather than pumpAndSettle(): the screen shows a CircularProgressIndicator while it
  // loads, and an indefinite animation never settles. Same pattern as the other Cards tests.
  Future<void> pumpCards(WidgetTester tester) async {
    await tester.pumpWidget(localizedApp(home: const CardsScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('signed in', () {
    // Signing in has to happen in setUp, not inside the test body: testWidgets runs its body in a
    // fake-async zone where a real Future (the login round trip, the secure-storage channel) never
    // completes unless the tester pumps it, so awaiting one there hangs the test outright.
    setUp(() => signInFakeUser(adapter));

    testWidgets('marks the models on the shelf, and only those', (
      tester,
    ) async {
      await pumpCards(tester);

      // One glyph in the filter chip, one on the Beggar's row, none on the Gondolier's.
      expect(find.byType(CollectionGlyph), findsNWidgets(2));
      expect(
        find.descendant(
          of: find
              .ancestor(
                of: find.text('Beggar'),
                matching: find.byType(GestureDetector),
              )
              .first,
          matching: find.byType(CollectionGlyph),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find
              .ancestor(
                of: find.text('Gondolier'),
                matching: find.byType(GestureDetector),
              )
              .first,
          matching: find.byType(CollectionGlyph),
        ),
        findsNothing,
      );
    });

    testWidgets('the mark says nothing about how far along the miniatures are', (
      tester,
    ) async {
      await pumpCards(tester);

      // 2 owned, 1 built — neither number appears on the row. A browse list answers yes or no.
      expect(find.text('×2'), findsNothing);
      expect(find.text('2'), findsNothing);
    });

    testWidgets('the filter narrows the catalogue to the shelf', (
      tester,
    ) async {
      await pumpCards(tester);

      expect(find.text('Gondolier'), findsOneWidget);

      await tester.tap(find.text('My collection'));
      await tester.pump();

      expect(find.text('Beggar'), findsOneWidget);
      expect(find.text('Gondolier'), findsNothing);
    });
  });

  testWidgets(
    'signed out, the screen is exactly what it was before the feature',
    (tester) async {
      await pumpCards(tester);

      expect(find.byType(CollectionGlyph), findsNothing);
      expect(find.text('My collection'), findsNothing);
      expect(find.text('Beggar'), findsOneWidget);
      expect(find.text('Gondolier'), findsOneWidget);
    },
  );
}
