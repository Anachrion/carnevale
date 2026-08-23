import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/collection_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale/services/collection_service.dart';
import 'package:carnevale/services/profile_service.dart';
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
    fakeProfile(id: 3, name: 'Baroni', ducats: 15, keywords: const ['Hero']),
  ];

  setUp(() async {
    adapter = installFakeApi();
    ProfileService().reset();
    await CollectionService().reset();
    adapter.stub('GET', '/profiles', listBody(catalogue, profileType));
    await signInFakeUser(adapter);
  });

  tearDown(() async {
    await AuthService().logOut();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(localizedApp(home: const CollectionScreen()));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'splits the catalogue between the shelf and what is missing from it',
    (tester) async {
      adapter.stub(
        'GET',
        '/collection',
        listBody([
          fakeCollectionItem(profileId: 1, owned: 4, built: 3, painted: 1),
        ], itemType),
      );

      await pumpScreen(tester);

      // The shelf holds the Beggar and nothing else.
      expect(find.text('Beggar'), findsOneWidget);
      expect(find.text('Gondolier'), findsNothing);

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // The other side holds exactly the complement.
      expect(find.text('Gondolier'), findsOneWidget);
      expect(find.text('Baroni'), findsOneWidget);
      expect(find.text('Beggar'), findsNothing);
    },
  );

  testWidgets('shows the exclusive buckets, not the nested totals', (
    tester,
  ) async {
    // 4 owned, 3 of them built, 1 of those painted -> 1 painted, 2 built, 1 boxed.
    adapter.stub(
      'GET',
      '/collection',
      listBody([
        fakeCollectionItem(profileId: 1, owned: 4, built: 3, painted: 1),
      ], itemType),
    );

    await pumpScreen(tester);

    expect(find.text('1'), findsNWidgets(2)); // painted and boxed
    expect(find.text('2'), findsOneWidget); // built but not painted
    expect(
      find.text('4'),
      findsNothing,
    ); // the nested total is never shown here
  });

  testWidgets('adding a miniature moves the row to the other tab', (
    tester,
  ) async {
    adapter.stub(
      'GET',
      '/collection',
      listBody(<api.CollectionItem>[], itemType),
    );
    adapter.stub(
      'PUT',
      '/collection/2',
      serializeItem(fakeCollectionItem(profileId: 2, owned: 1)),
    );

    await pumpScreen(tester);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Gondolier'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find
            .ancestor(
              of: find.text('Gondolier'),
              matching: find.byType(GestureDetector),
            )
            .first,
        matching: find.byIcon(Icons.add),
      ),
    );
    await tester.pumpAndSettle();

    // Gone from "Add"...
    expect(find.text('Gondolier'), findsNothing);

    // ...and on the shelf.
    await tester.tap(find.text('My collection'));
    await tester.pumpAndSettle();
    expect(find.text('Gondolier'), findsOneWidget);
  });

  testWidgets('each tab keeps its own search across a switch', (tester) async {
    adapter.stub(
      'GET',
      '/collection',
      listBody([
        fakeCollectionItem(profileId: 1, owned: 1),
        fakeCollectionItem(profileId: 3, owned: 1),
      ], itemType),
    );

    await pumpScreen(tester);

    await tester.enterText(find.byType(TextField).first, 'Baroni');
    await tester.pumpAndSettle();
    expect(find.text('Beggar'), findsNothing);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    // The other tab's own search is untouched, so its full list shows.
    expect(find.text('Gondolier'), findsOneWidget);

    await tester.tap(find.text('My collection'));
    await tester.pumpAndSettle();
    // And coming back, the first tab still holds what was typed there and stays narrowed by it.
    expect(find.widgetWithText(TextField, 'Baroni'), findsOneWidget);
    expect(find.text('Beggar'), findsNothing);
  });
}
