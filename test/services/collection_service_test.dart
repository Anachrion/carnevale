import 'package:built_value/serializer.dart';
import 'package:carnevale/services/api_client.dart';
import 'package:carnevale/services/collection_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

const _itemType = FullType(api.CollectionItem);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeApiAdapter fakeApi;

  setUp(() async {
    fakeApi = installFakeApi();
    await CollectionService().reset();
  });

  // These mirror spec/models/collection/item_spec.rb one case for one. The rule lives in two
  // places deliberately — the steppers write optimistically and must not flicker through a state
  // the server would never store — so both copies are held to the same examples.
  group('CollectionEntry.withCount', () {
    test('raising a narrower count pulls the wider ones up', () {
      const entry = CollectionEntry(owned: 1);

      expect(
        entry.withCount(CollectionCount.painted, 1),
        const CollectionEntry(owned: 1, built: 1, painted: 1),
      );
    });

    test('lowering a wider count pushes the narrower ones down', () {
      const entry = CollectionEntry(owned: 3, built: 3, painted: 2);

      expect(
        entry.withCount(CollectionCount.owned, 1),
        const CollectionEntry(owned: 1, built: 1, painted: 1),
      );
    });

    test('lowering built takes painted with it and leaves owned alone', () {
      const entry = CollectionEntry(owned: 3, built: 3, painted: 3);

      expect(
        entry.withCount(CollectionCount.built, 1),
        const CollectionEntry(owned: 3, built: 1, painted: 1),
      );
    });

    test('a first painted miniature provisions the counts it implies', () {
      expect(
        CollectionEntry.none.withCount(CollectionCount.painted, 1),
        const CollectionEntry(owned: 1, built: 1, painted: 1),
      );
    });

    test('raising built past owned buys the miniature', () {
      const entry = CollectionEntry(owned: 1, built: 1, painted: 1);

      expect(
        entry.withCount(CollectionCount.built, 2),
        const CollectionEntry(owned: 2, built: 2, painted: 1),
      );
    });

    test('floors a count at zero', () {
      const entry = CollectionEntry(owned: 2, built: 1);

      expect(entry.withCount(CollectionCount.owned, -3), CollectionEntry.none);
    });

    test('exposes the exclusive buckets the screens show', () {
      const entry = CollectionEntry(owned: 4, built: 3, painted: 1);

      expect(entry.boxed, 1);
      expect(entry.unpainted, 2);
    });
  });

  group('load', () {
    test('keys what the player owns by profile', () async {
      fakeApi.stub(
        'GET',
        '/collection',
        listBody([
          fakeCollectionItem(profileId: 7, owned: 3, built: 2, painted: 1),
        ], _itemType),
      );

      await CollectionService().load();

      expect(CollectionService().owns(7), isTrue);
      expect(CollectionService().owns(8), isFalse);
      expect(
        CollectionService().entryFor(7),
        const CollectionEntry(owned: 3, built: 2, painted: 1),
      );
      expect(CollectionService().totals, (owned: 3, built: 2, painted: 1));
    });

    test('an unknown profile reads as owning none, never as null', () async {
      fakeApi.stub(
        'GET',
        '/collection',
        listBody(<api.CollectionItem>[], _itemType),
      );

      await CollectionService().load();

      expect(CollectionService().entryFor(99), CollectionEntry.none);
      expect(CollectionService().ownedProfileIds, isEmpty);
    });

    test(
      'falls back to the last-loaded copy when the server is unreachable',
      () async {
        fakeApi.stub(
          'GET',
          '/collection',
          listBody([
            fakeCollectionItem(profileId: 7, owned: 2, built: 1),
          ], _itemType),
        );
        await CollectionService().load();

        // A cold start with no network: same stored prefs, an adapter that answers nothing.
        ApiClient().dio.httpClientAdapter = FakeApiAdapter();
        CollectionService().dropMemory();

        await CollectionService().load();

        expect(
          CollectionService().entryFor(7),
          const CollectionEntry(owned: 2, built: 1),
        );
      },
    );
  });

  group('setCount', () {
    Future<void> loadWith(List<api.CollectionItem> items) async {
      fakeApi.stub('GET', '/collection', listBody(items, _itemType));
      await CollectionService().load();
    }

    test('shows the settled counts before the server answers', () async {
      await loadWith([fakeCollectionItem(profileId: 7, owned: 1)]);
      fakeApi.stub(
        'PUT',
        '/collection/7',
        serializeItem(
          fakeCollectionItem(profileId: 7, owned: 1, built: 1, painted: 1),
        ),
      );

      final pending = CollectionService().setCount(
        7,
        CollectionCount.painted,
        1,
      );

      // Already applied locally, without waiting for the round trip.
      expect(
        CollectionService().entryFor(7),
        const CollectionEntry(owned: 1, built: 1, painted: 1),
      );
      expect(await pending, isTrue);
    });

    test(
      'sends the whole settled entry, not just the count that moved',
      () async {
        await loadWith([fakeCollectionItem(profileId: 7, owned: 1)]);
        fakeApi.stub(
          'PUT',
          '/collection/7',
          serializeItem(
            fakeCollectionItem(profileId: 7, owned: 1, built: 1, painted: 1),
          ),
        );

        await CollectionService().setCount(7, CollectionCount.painted, 1);

        final sent = (fakeApi.requests.last.data as Map)['item'] as Map;
        expect(sent, containsPair('owned', 1));
        expect(sent, containsPair('built', 1));
        expect(sent, containsPair('painted', 1));
      },
    );

    test('puts the previous counts back when the write fails', () async {
      await loadWith([
        fakeCollectionItem(profileId: 7, owned: 3, built: 2, painted: 1),
      ]);
      // PUT deliberately unstubbed: the adapter answers 404.

      final ok = await CollectionService().setCount(
        7,
        CollectionCount.owned,
        1,
      );

      expect(ok, isFalse);
      expect(
        CollectionService().entryFor(7),
        const CollectionEntry(owned: 3, built: 2, painted: 1),
      );
    });

    test(
      'a failed first write leaves the profile out of the collection',
      () async {
        await loadWith(<api.CollectionItem>[]);

        final ok = await CollectionService().setCount(
          7,
          CollectionCount.owned,
          1,
        );

        expect(ok, isFalse);
        expect(CollectionService().owns(7), isFalse);
      },
    );

    test(
      'dropping every count removes the profile from the collection',
      () async {
        await loadWith([
          fakeCollectionItem(profileId: 7, owned: 2, built: 2, painted: 2),
        ]);
        fakeApi.stub(
          'PUT',
          '/collection/7',
          serializeItem(
            fakeCollectionItem(profileId: 7, owned: 0, built: 0, painted: 0),
          ),
        );

        await CollectionService().setCount(7, CollectionCount.owned, 0);

        expect(CollectionService().owns(7), isFalse);
        expect(CollectionService().entryFor(7), CollectionEntry.none);
      },
    );
  });

  test('reset forgets the collection and its cached copy', () async {
    fakeApi.stub(
      'GET',
      '/collection',
      listBody([fakeCollectionItem(profileId: 7, owned: 2)], _itemType),
    );
    await CollectionService().load();

    await CollectionService().reset();
    ApiClient().dio.httpClientAdapter = FakeApiAdapter();

    expect(CollectionService().isLoaded, isFalse);
    // Nothing left on disk to restore from, so an offline load now genuinely fails.
    await expectLater(CollectionService().load(), throwsA(anything));
  });
}
