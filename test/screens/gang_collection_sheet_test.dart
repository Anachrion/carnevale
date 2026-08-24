import 'package:built_value/serializer.dart';
import 'package:carnevale/services/collection_service.dart';
import 'package:carnevale/widgets/gang_collection_sheet.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

const _itemType = FullType(api.CollectionItem);

void main() {
  api.Profile profile(int id, String name) => fakeProfile(
    id: id,
    name: name,
    keywords: const [],
    cardReferences: [
      api.CardReference(
        (b) => b
          ..id = id * 10
          ..identifier = 'guild-$name'
          ..name = name
          ..cardFront = '$name-front.webp'
          ..cardBack = '$name-back.webp',
      ),
    ],
  );

  final beggar = profile(1, 'Beggar');
  final gondolier = profile(2, 'Gondolier');

  api.ListEntry hire(int cardReferenceId) =>
      fakeListEntry(id: cardReferenceId, entryId: cardReferenceId);

  // The shelf has to be loaded in setUp, never in the test body: testWidgets runs its body in a
  // fake-async zone where a real Future never completes unless the tester pumps it.
  Future<void> loadShelf(List<api.CollectionItem> items) async {
    final adapter = installFakeApi();
    await CollectionService().reset();
    adapter.stub('GET', '/collection', listBody(items, _itemType));
    await CollectionService().load();
  }

  Future<void> openSheet(
    WidgetTester tester, {
    required List<api.ListEntry> entries,
  }) async {
    await tester.pumpWidget(
      localizedApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showGangCollectionSheet(
                  context,
                  entries: entries,
                  profiles: [beggar, gondolier],
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('a gang the shelf cannot fill', () {
    setUp(
      () => loadShelf([
        fakeCollectionItem(profileId: 1, owned: 1, built: 1, painted: 1),
      ]),
    );

    testWidgets('names the shortfall and how far short it is', (tester) async {
      await openSheet(
        tester,
        entries: [hire(10), hire(10), hire(10), hire(20)],
      );

      expect(find.text('4 miniatures'), findsOneWidget);
      expect(
        find.text('You are 3 miniatures short of fielding this gang'),
        findsOneWidget,
      );
      // Worst gap first: two Beggars missing, then the Gondolier.
      expect(find.text('Beggar'), findsOneWidget);
      expect(find.text('1 of 3'), findsOneWidget);
      expect(find.text('0 of 1'), findsOneWidget);
    });
  });

  group('a gang the shelf covers', () {
    setUp(
      () => loadShelf([
        fakeCollectionItem(profileId: 1, owned: 2, built: 2, painted: 2),
      ]),
    );

    testWidgets('says so plainly', (tester) async {
      await openSheet(tester, entries: [hire(10), hire(10)]);

      expect(
        find.text('Every miniature in this gang is on your shelf.'),
        findsOneWidget,
      );
      expect(find.textContaining('short of fielding'), findsNothing);
    });
  });

  group('an empty gang', () {
    setUp(() => loadShelf(<api.CollectionItem>[]));

    testWidgets('says it has no models rather than showing zeros', (
      tester,
    ) async {
      await openSheet(tester, entries: const []);

      expect(find.text('This gang has no models yet.'), findsOneWidget);
      expect(find.text('Painted'), findsNothing);
    });
  });
}
