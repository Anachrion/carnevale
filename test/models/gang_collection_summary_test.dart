import 'package:carnevale/models/gang_collection_summary.dart';
import 'package:carnevale/services/collection_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  // Card reference ids are what a list entry points at; keep one per profile for legibility.
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

  api.ListEntry hire(int cardReferenceId, {bool summoned = false}) =>
      fakeListEntry(
        id: cardReferenceId,
        entryId: cardReferenceId,
        summoned: summoned,
      );

  final beggar = profile(1, 'Beggar');
  final gondolier = profile(2, 'Gondolier');
  final baroni = profile(3, 'Baroni');
  final catalogue = [beggar, gondolier, baroni];

  GangCollectionSummary summarise(
    List<api.ListEntry> entries,
    Map<int, CollectionEntry> shelf,
  ) => GangCollectionSummary.of(
    entries: entries,
    profiles: catalogue,
    lookup: (id) => shelf[id] ?? CollectionEntry.none,
  );

  test('splits the gang into exclusive buckets that sum to its size', () {
    final summary = summarise(
      [
        // 4 Beggars, of which 3 owned: 1 painted, 2 built.
        hire(10), hire(10), hire(10), hire(10),
        // 2 Gondoliers, 1 owned and built.
        hire(20), hire(20),
        // 2 Baroni, both painted.
        hire(30), hire(30),
      ],
      {
        1: const CollectionEntry(owned: 3, built: 3, painted: 1),
        2: const CollectionEntry(owned: 1, built: 1),
        3: const CollectionEntry(owned: 2, built: 2, painted: 2),
      },
    );

    expect(summary.total, 8);
    expect(summary.painted, 3); // 1 Beggar + 2 Baroni
    expect(summary.unpainted, 3); // 2 Beggars + 1 Gondolier
    expect(summary.boxed, 0);
    expect(summary.missing, 2); // 1 Beggar + 1 Gondolier
    expect(
      summary.painted + summary.unpainted + summary.boxed + summary.missing,
      summary.total,
    );
  });

  test('never counts more copies than the gang actually hires', () {
    // Owning six changes nothing about a gang that fields one.
    final summary = summarise(
      [hire(10)],
      {1: const CollectionEntry(owned: 6, built: 6, painted: 6)},
    );

    expect(summary.total, 1);
    expect(summary.painted, 1);
    expect(summary.missing, 0);
    expect(summary.isComplete, isTrue);
  });

  test('counts a model owned but not assembled as still boxed', () {
    final summary = summarise(
      [hire(10), hire(10)],
      {1: const CollectionEntry(owned: 2)},
    );

    expect(summary.boxed, 2);
    expect(summary.unpainted, 0);
    expect(summary.painted, 0);
  });

  test('everything is missing when the shelf is empty', () {
    final summary = summarise([hire(10), hire(20)], {});

    expect(summary.total, 2);
    expect(summary.missing, 2);
    expect(summary.isComplete, isFalse);
  });

  test('lists the shortfalls, worst gap first', () {
    final summary = summarise(
      [hire(10), hire(10), hire(10), hire(20), hire(20)],
      {
        1: const CollectionEntry(owned: 1, built: 1, painted: 1),
        2: const CollectionEntry(owned: 1, built: 1),
      },
    );

    expect(summary.shortfalls.map((s) => s.name), ['Beggar', 'Gondolier']);
    expect(summary.shortfalls.first.missing, 2);
    expect(summary.shortfalls.first.hired, 3);
    expect(summary.shortfalls.first.owned, 1);
  });

  test('leaves equipment out: it is not a miniature', () {
    final summary = summarise(
      [
        hire(10),
        fakeListEntry(
          id: 99,
          entryId: 99,
          entryType: api.ListEntryEntryTypeEnum.catalogColonColonEquipment,
        ),
      ],
      {1: const CollectionEntry(owned: 1)},
    );

    expect(summary.total, 1);
  });

  test('leaves a summoned model out: it was never bought', () {
    final summary = summarise(
      [hire(10), hire(20, summoned: true)],
      {1: const CollectionEntry(owned: 1)},
    );

    expect(summary.total, 1);
    expect(summary.missing, 0);
  });
}
