import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gang_builder_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

/// The List tab pins the Leader to the top and makes it undraggable, so a hired Leader always leads
/// the roster and can't be reordered below its models. Every other model stays long-press-draggable.
void main() {
  Future<void> pumpListTab(WidgetTester tester, api.ModelList gang) async {
    final adapter = installFakeApi();
    // The builder loads these on open; empty stubs are enough — the List tab renders each entry
    // from the entry's own name/keywords, and the pin reads keywords off the entry itself.
    adapter.stub('GET', '/profiles',
        listBody<api.Profile>([], const FullType(api.Profile)));
    adapter.stub('GET', '/equipment',
        listBody<api.Equipment>([], const FullType(api.Equipment)));
    adapter.stub('GET', '/spells',
        listBody<api.Spell>([], const FullType(api.Spell)));

    await tester.pumpWidget(MaterialApp(home: GangBuilderScreen(gang: gang)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  Set<Key?> draggableKeys(WidgetTester tester) => tester
      .widgetList<ReorderableDelayedDragStartListener>(
        find.byType(ReorderableDelayedDragStartListener),
      )
      .map((w) => w.key)
      .toSet();

  testWidgets('the Leader tile is not draggable; other models are', (tester) async {
    final gang = fakeModelList(
      entries: [
        fakeListEntry(id: 1, position: 1, name: 'Capodecina', keywords: const ['Leader']),
        fakeListEntry(id: 2, position: 2, name: 'Bravoes', keywords: const ['Henchman']),
        fakeListEntry(id: 3, position: 3, name: 'Barnabotti', keywords: const ['Henchman']),
      ],
    );

    await pumpListTab(tester, gang);

    expect(find.text('Capodecina'), findsOneWidget);
    final keys = draggableKeys(tester);
    // The Leader (entry id 1) carries no drag listener; the two Henchmen do.
    expect(keys, isNot(contains(const ValueKey(1))));
    expect(keys, contains(const ValueKey(2)));
    expect(keys, contains(const ValueKey(3)));
  });

  testWidgets('pins the hard Leader, not a flex Leader that appears first', (tester) async {
    final gang = fakeModelList(
      entries: [
        // A flex Leader listed first, but a hard Leader is present, so the server demoted it to a
        // plain Hero: it should be draggable, not the pinned header.
        fakeListEntry(
          id: 1,
          position: 1,
          name: 'The Duke',
          keywords: const ['Leader', 'Hero'],
          flexibleLeader: true,
          demotedLeader: true,
        ),
        fakeListEntry(id: 2, position: 2, name: 'Capodecina', keywords: const ['Leader']),
        fakeListEntry(id: 3, position: 3, name: 'Bravoes', keywords: const ['Henchman']),
      ],
    );

    await pumpListTab(tester, gang);

    final keys = draggableKeys(tester);
    // The hard Leader (Capodecina, id 2) is the pinned header → not draggable.
    expect(keys, isNot(contains(const ValueKey(2))));
    // The demoted flex Leader (id 1) and the henchman (id 3) reorder freely.
    expect(keys, contains(const ValueKey(1)));
    expect(keys, contains(const ValueKey(3)));
  });

  testWidgets('a demoted, promotable flex Leader shows Hero and a promote button', (tester) async {
    final gang = fakeModelList(
      entries: [
        // Two unconditional flex Leaders, no forced one: the topmost leads, the other is a demoted,
        // promotable Hero.
        fakeListEntry(
          id: 1,
          position: 1,
          name: 'The Duke',
          keywords: const ['Leader', 'Hero'],
          flexibleLeader: true,
        ),
        fakeListEntry(
          id: 2,
          position: 2,
          name: 'Prince of Thieves',
          keywords: const ['Leader', 'Hero'],
          flexibleLeader: true,
          demotedLeader: true,
          promotableLeader: true,
        ),
      ],
    );

    await pumpListTab(tester, gang);

    final keys = draggableKeys(tester);
    // The Duke leads → header (not draggable); the demoted Prince is in the reorderable list.
    expect(keys, isNot(contains(const ValueKey(1))));
    expect(keys, contains(const ValueKey(2)));
    // The demoted flex Leader reads as a Hero and offers the promote action.
    expect(find.text('hero'), findsOneWidget);
    expect(find.text('Promote leader'), findsOneWidget);
  });

  testWidgets('a leaderless gang leaves every model draggable', (tester) async {
    final gang = fakeModelList(
      faction: 'gifted',
      entries: [
        fakeListEntry(id: 1, position: 1, name: 'Colombina', keywords: const ['Henchman']),
        fakeListEntry(id: 2, position: 2, name: 'Arlecchino', keywords: const ['Henchman']),
      ],
    );

    await pumpListTab(tester, gang);

    final keys = draggableKeys(tester);
    expect(keys, contains(const ValueKey(1)));
    expect(keys, contains(const ValueKey(2)));
  });
}
