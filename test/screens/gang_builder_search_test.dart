import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gang_builder_screen.dart';
import 'package:carnevale/widgets/profile_search.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// The Hire tab runs the same catalog search as the Cards screen — free text over abilities and
/// rules, plus ANDed facet chips — but pinned to what this gang can actually hire: its own faction
/// plus the Gifted mercenaries. These cover both halves of that.
void main() {
  Future<void> pumpHireTab(WidgetTester tester) async {
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(
          id: 1,
          name: 'Capodecina',
          faction: 'guild',
          keywords: const ['Leader'],
          abilities: const ['Brave', 'Acrobatic (2)'],
        ),
        fakeProfile(
          id: 2,
          name: 'Bravoes',
          faction: 'guild',
          keywords: const ['Henchman'],
          abilities: const ['Brave'],
        ),
        fakeProfile(
          id: 3,
          name: 'Barnabotti',
          faction: 'guild',
          keywords: const ['Henchman'],
          abilities: const ['Fear (1)'],
        ),
        // A mercenary: hireable by any gang, so it must stay in the search pool...
        fakeProfile(
          id: 4,
          name: 'Colombina',
          faction: 'gifted',
          keywords: const ['Henchman'],
          abilities: const ['Brave'],
        ),
        // ...whereas another faction's model must never be reachable from this gang's Hire tab.
        fakeProfile(
          id: 5,
          name: 'Nemico',
          faction: 'strigoi',
          keywords: const ['Leader'],
          abilities: const ['Brave'],
        ),
      ], const FullType(api.Profile)),
    );
    adapter.stub(
      'GET',
      '/equipment',
      listBody<api.Equipment>([
        fakeEquipment(id: 1, name: 'Gondola', description: 'A boat.'),
        fakeEquipment(
          id: 2,
          name: 'Grappling Hook',
          description: 'Climb a wall bravely.',
        ),
      ], const FullType(api.Equipment)),
    );
    adapter.stub(
      'GET',
      '/spells',
      listBody<api.Spell>([], const FullType(api.Spell)),
    );

    // fakeModelList defaults to the guild faction.
    final gang = fakeModelList(name: 'The Rooks', entries: []);
    await tester.pumpWidget(localizedApp(home: GangBuilderScreen(gang: gang)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Hire'));
    await tester.pump();
    // Let the 250ms tab-switch PageView animation finish, so the Hire tab (and its search field)
    // is actually built before a test types into it — a single pump lands mid-animation.
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets(
    'searches abilities, not just names, and picking a suggestion filters the hire list',
    (tester) async {
      await pumpHireTab(tester);
      expect(find.text('Barnabotti'), findsOneWidget);

      // "brav" is not a substring of Barnabotti's *name* — the old hire filter was name-only, so this
      // is exactly the case that used to come back empty.
      await tester.enterText(find.byType(TextField), 'brav');
      await tester.pump();

      // Brave is carried by the two guild models plus the Gifted mercenary — but not by the strigoi
      // model, which this gang can't hire. The count comes from the whole catalog, hence 4.
      expect(find.text('ability · 4'), findsOneWidget);

      await tester.tap(find.text('Brave'));
      await tester.pump();

      expect(find.text('Capodecina'), findsOneWidget);
      expect(find.text('Bravoes'), findsOneWidget);
      expect(find.text('Colombina'), findsOneWidget);
      // Fear, not Brave.
      expect(find.text('Barnabotti'), findsNothing);
      // The strigoi Leader is Brave, but belongs to another faction: never hireable, never shown.
      expect(find.text('Nemico'), findsNothing);
    },
  );

  testWidgets(
    'picking a suggestion survives the field losing focus on pointer-down',
    (tester) async {
      // The bug this covers: EditableText's default tap-outside action unfocuses the search field
      // the instant a pointer goes down anywhere outside it — the suggestions panel included — and
      // the panel only shows while the field has focus, so it was torn down mid-tap and the row
      // never saw the pointer-up. Tapping a suggestion did nothing at all.
      //
      // Two things make it reproduce here. The platform override: that action leaves focus alone
      // for a touch on native Android/iOS (which is why the installed app was fine) and drops it
      // everywhere else, kIsWeb included — kIsWeb cannot be faked in a test, so a desktop platform
      // stands in for mobile web and runs the identical code path. And the pump between down and
      // up: a real tap spans frames, so the rebuild that removed the panel landed inside the
      // gesture, whereas tester.tap sends both events with no frame in between and never saw it.
      // Restored in a finally rather than an addTearDown: the framework's "no debug variable was
      // left set" check runs before tear-downs do, so a leaked override fails the test on its way
      // out and hides whatever the assertions actually said.
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      try {
        await pumpHireTab(tester);

        await tester.enterText(find.byType(TextField), 'brav');
        await tester.pump();
        expect(find.text('Brave'), findsOneWidget);

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Brave')),
        );
        await tester.pump();
        await gesture.up();
        await tester.pump();

        // Assert on the chip and the cleared field, not on who is left in the list: "brav" as free
        // text already filters out everything that isn't Brave, so the list looks identical whether
        // the tap landed or not — which is what let this reach production.
        expect(find.byType(FacetChip), findsOneWidget);
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          isEmpty,
        );
        // With the text gone, the chip alone is doing the filtering.
        expect(find.text('Capodecina'), findsOneWidget);
        expect(find.text('Barnabotti'), findsNothing);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );

  testWidgets('two facet chips AND together: brave leaders only', (
    tester,
  ) async {
    await pumpHireTab(tester);

    await tester.enterText(find.byType(TextField), 'brav');
    await tester.pump();
    await tester.tap(find.text('Brave'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'lead');
    await tester.pump();
    await tester.tap(find.text('Leader'));
    await tester.pump();

    // Bravoes and Colombina are Brave but Henchmen; Barnabotti is neither.
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Bravoes'), findsNothing);
    expect(find.text('Colombina'), findsNothing);
    expect(find.text('Barnabotti'), findsNothing);
  });

  testWidgets('finds equipment by name, even when no model matches', (
    tester,
  ) async {
    await pumpHireTab(tester);

    // The bug this covers: "gondola" matches no *profile*, and the empty state keyed off the
    // profiles alone, so the whole list — Equipment section included — was replaced with
    // "nothing found" and the gear you were looking for disappeared.
    await tester.enterText(find.byType(TextField), 'gondola');
    await tester.pump();

    expect(find.text('Gondola'), findsOneWidget);
    expect(find.text('Grappling Hook'), findsNothing);
    expect(find.text('Capodecina'), findsNothing);
    expect(find.text('Nothing matches your search.'), findsNothing);
  });

  testWidgets('sweeps equipment descriptions too, alongside matching models', (
    tester,
  ) async {
    await pumpHireTab(tester);

    // "brave" is in the Grappling Hook's description, and is an ability on three hireable models —
    // so the one search returns both kinds of result.
    await tester.enterText(find.byType(TextField), 'brave');
    await tester.pump();

    expect(find.text('Grappling Hook'), findsOneWidget);
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Gondola'), findsNothing);
  });

  testWidgets('a facet chip excludes equipment, which carries no abilities', (
    tester,
  ) async {
    await pumpHireTab(tester);

    await tester.enterText(find.byType(TextField), 'brav');
    await tester.pump();
    await tester.tap(find.text('Brave'));
    await tester.pump();

    // Asking for the Brave *ability* is a question about models. The Grappling Hook merely has
    // "bravely" in its prose, so it must not ride along on an ability filter.
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Grappling Hook'), findsNothing);
    expect(find.text('Gondola'), findsNothing);
  });

  testWidgets('a search matching nothing hireable says so', (tester) async {
    await pumpHireTab(tester);

    await tester.enterText(find.byType(TextField), 'nemico');
    await tester.pump();

    expect(find.text('Nothing matches your search.'), findsOneWidget);
  });
}
