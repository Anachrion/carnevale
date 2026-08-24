import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/cards_screen.dart';
import 'package:carnevale/screens/collection_screen.dart';
import 'package:carnevale/screens/home_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale/services/collection_service.dart';
import 'package:carnevale/services/profile_service.dart';
import 'package:carnevale/widgets/collection_glyph.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

const _profileType = FullType(api.Profile);
const _itemType = FullType(api.CollectionItem);

void main() {
  late FakeApiAdapter adapter;

  final catalogue = [
    fakeProfile(id: 1, name: 'Beggar', ducats: 6, keywords: const []),
    fakeProfile(id: 2, name: 'Gondolier', ducats: 11, keywords: const []),
  ];

  // The switches ride in on the sign-in payload, so each state needs its own setUp — testWidgets
  // runs its body in a fake-async zone where the login round trip would never complete.
  Future<void> prepare({required bool enabled, required bool visible}) async {
    adapter = installFakeApi();
    ProfileService().reset();
    await CollectionService().reset();
    adapter.stub('GET', '/profiles', listBody(catalogue, _profileType));
    adapter.stub(
      'GET',
      '/collection',
      listBody([
        fakeCollectionItem(profileId: 1, owned: 2, built: 1),
      ], _itemType),
    );
    await signInFakeUser(
      adapter,
      collectionEnabled: enabled,
      collectionVisible: visible,
    );
  }

  tearDown(() => AuthService().logOut());

  Future<void> pumpCards(WidgetTester tester) async {
    await tester.pumpWidget(localizedApp(home: const CardsScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('offered but not enabled', () {
    setUp(() => prepare(enabled: false, visible: true));

    testWidgets('the catalogue carries no trace of the feature', (
      tester,
    ) async {
      await pumpCards(tester);

      expect(find.byType(CollectionGlyph), findsNothing);
      expect(find.text('My collection'), findsNothing);
      // ...and the models are all still there.
      expect(find.text('Beggar'), findsOneWidget);
      expect(find.text('Gondolier'), findsOneWidget);
    });

    testWidgets(
      'the Collection screen introduces the feature instead of opening it',
      (tester) async {
        await tester.pumpWidget(localizedApp(home: const CollectionScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Track what you own'), findsOneWidget);
        expect(find.text('Enable'), findsOneWidget);
        // The tabs are not there to be found yet.
        expect(find.text('Add'), findsNothing);
      },
    );

    testWidgets('the home screen still offers the way in', (tester) async {
      await tester.pumpWidget(localizedApp(home: const HomeScreen()));
      await tester.pump();

      expect(find.text('Collection'), findsOneWidget);
    });

    testWidgets('switching it on opens the collection', (tester) async {
      adapter.stub('PATCH', '/account', {
        'user': {
          'id': 1,
          'email': 'Eldrim@example.com',
          'username': 'Eldrim',
          'collection_enabled': true,
          'collection_visible': true,
        },
      });

      await tester.pumpWidget(localizedApp(home: const CollectionScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enable'));
      await tester.pumpAndSettle();

      expect(find.text('Track what you own'), findsNothing);
      expect(find.text('Add'), findsOneWidget);
    });
  });

  group('enabled', () {
    setUp(() => prepare(enabled: true, visible: true));

    testWidgets(
      'disabling from the header takes effect without leaving the screen',
      (tester) async {
        adapter.stub('PATCH', '/account', {
          'user': {
            'id': 1,
            'email': 'Eldrim@example.com',
            'username': 'Eldrim',
            'collection_enabled': false,
            'collection_visible': true,
          },
        });

        await tester.pumpWidget(localizedApp(home: const CollectionScreen()));
        await tester.pumpAndSettle();
        expect(find.text('Add'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.power_settings_new));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Disable'));
        await tester.pumpAndSettle();

        // The screen falls back to its introduction there and then; it used to keep showing the
        // collection it had just switched off until you navigated away and back.
        expect(find.text('Track what you own'), findsOneWidget);
        expect(find.text('Add'), findsNothing);
      },
    );
  });

  group('hidden from the menus', () {
    setUp(() => prepare(enabled: true, visible: false));

    testWidgets('the home screen drops the entry', (tester) async {
      await tester.pumpWidget(localizedApp(home: const HomeScreen()));
      await tester.pump();

      expect(find.text('Collection'), findsNothing);
      // The other destinations are untouched.
      expect(find.text('Cards'), findsOneWidget);
    });

    testWidgets(
      'the marks go with it, even though the feature was switched on',
      (tester) async {
        await pumpCards(tester);

        expect(find.byType(CollectionGlyph), findsNothing);
        expect(find.text('My collection'), findsNothing);
      },
    );
  });

  group('switched on and offered', () {
    setUp(() => prepare(enabled: true, visible: true));

    testWidgets('everything is back', (tester) async {
      await pumpCards(tester);

      // One glyph in the filter chip, one on the row of the model that is owned.
      expect(find.byType(CollectionGlyph), findsNWidgets(2));
      expect(find.text('My collection'), findsOneWidget);
    });

    testWidgets('the home screen offers the entry', (tester) async {
      await tester.pumpWidget(localizedApp(home: const HomeScreen()));
      await tester.pump();

      expect(find.text('Collection'), findsOneWidget);
    });
  });
}
