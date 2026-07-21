import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/cards_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// Drives the search box the way a player does: type, pick a suggestion, watch the list narrow.
void main() {
  Future<void> pumpCards(WidgetTester tester) async {
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(
          id: 1,
          name: 'Capodecina',
          keywords: const ['Leader'],
          abilities: const ['Brave', 'Acrobatic (2)'],
        ),
        fakeProfile(
          id: 2,
          name: 'Bombardier',
          keywords: const ['Henchman'],
          abilities: const ['Brave'],
        ),
        fakeProfile(
          id: 3,
          name: 'Doge',
          keywords: const ['Leader'],
          abilities: const ['Fear (1)'],
        ),
      ], const FullType(api.Profile)),
    );
    await tester.pumpWidget(localizedApp(home: CardsScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('typing suggests an ability, and picking it filters the list', (
    tester,
  ) async {
    await pumpCards(tester);
    expect(find.text('Doge'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'brav');
    await tester.pump();

    // The suggestion names the facet, what kind it is and how many models have it.
    expect(find.text('Brave'), findsOneWidget);
    expect(find.text('ability · 2'), findsOneWidget);

    await tester.tap(find.text('Brave'));
    await tester.pump();

    // Promoted to a chip: the text box is cleared and only the brave models remain.
    expect(find.text('Brave'), findsOneWidget); // now the chip
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Bombardier'), findsOneWidget);
    expect(find.text('Doge'), findsNothing);
  });

  testWidgets('arrow keys walk the suggestions and Enter picks one', (
    tester,
  ) async {
    await pumpCards(tester);

    // Matches Acrobatic (prefix), then Brave and Leader (2 models each), then Fear and Henchman.
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown); // Acrobatic
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown); // Brave
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    // The arrows selected a row rather than moving the caret, so Enter took Brave, not Acrobatic.
    expect(find.text('Brave'), findsOneWidget); // the chip
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Bombardier'), findsOneWidget);
    expect(find.text('Doge'), findsNothing);
    // And the text it was typed from is gone, having been promoted to the chip.
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
  });

  testWidgets('Escape dismisses the suggestions without filtering', (
    tester,
  ) async {
    await pumpCards(tester);

    await tester.enterText(find.byType(TextField), 'brav');
    await tester.pump();
    expect(find.text('ability · 2'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    expect(find.text('ability · 2'), findsNothing);
    // The typed text still filters the list on its own; only the panel is gone.
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Doge'), findsNothing);
  });

  // CARNEVALEB-29: the suggestions panel used to have no touch-reachable way to dismiss it (only
  // Escape, or picking a suggestion) and could sit over the first result. Tapping outside the
  // field now drops its focus, hiding the panel with it; tapping back into the field (with the
  // same text still there) brings the same suggestions straight back, unchanged.
  testWidgets(
    'tapping outside the search field hides the suggestions; tapping back in brings them back',
    (tester) async {
      await pumpCards(tester);

      await tester.enterText(find.byType(TextField), 'brav');
      await tester.pump();
      expect(find.text('ability · 2'), findsOneWidget);

      // Well below the three-row list, inside the results area the suggestions float over —
      // reliably blank space regardless of exactly how tall the tiles render.
      await tester.tapAt(const Offset(400, 590));
      await tester.pump();
      expect(find.text('ability · 2'), findsNothing);
      // The typed text (and the filtered list) are untouched — only the panel is hidden.
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'brav',
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(find.text('ability · 2'), findsOneWidget);
    },
  );

  testWidgets('a keyword and an ability chip combine: brave leaders only', (
    tester,
  ) async {
    await pumpCards(tester);

    await tester.enterText(find.byType(TextField), 'brav');
    await tester.pump();
    await tester.tap(find.text('Brave'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'lead');
    await tester.pump();
    await tester.tap(find.text('Leader'));
    await tester.pump();

    // Bombardier is brave but a Henchman; Doge is a Leader but not brave.
    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Bombardier'), findsNothing);
    expect(find.text('Doge'), findsNothing);

    // Dropping the Brave chip widens it back out to every Leader. Its own Row is the closest Row
    // above the label, so `.first` picks that chip's close button and not the Leader chip's.
    final braveChip = find
        .ancestor(of: find.text('Brave'), matching: find.byType(Row))
        .first;
    await tester.tap(
      find.descendant(of: braveChip, matching: find.byIcon(Icons.close)),
    );
    await tester.pump();

    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Doge'), findsOneWidget);
    expect(find.text('Bombardier'), findsNothing);
  });
}
