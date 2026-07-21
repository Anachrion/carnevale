import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gang_builder_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

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
          abilities: const ['Brave'],
        ),
        fakeProfile(
          id: 2,
          name: 'Bravoes',
          faction: 'guild',
          keywords: const ['Henchman'],
          abilities: const ['Brave'],
        ),
      ], const FullType(api.Profile)),
    );
    adapter.stub(
      'GET',
      '/equipment',
      listBody<api.Equipment>([], const FullType(api.Equipment)),
    );
    adapter.stub(
      'GET',
      '/spells',
      listBody<api.Spell>([], const FullType(api.Spell)),
    );

    final gang = fakeModelList(name: 'The Rooks', entries: []);
    await tester.pumpWidget(localizedApp(home: GangBuilderScreen(gang: gang)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Hire'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  bool searchFocused(WidgetTester tester) {
    final fields = tester.widgetList<TextField>(find.byType(TextField));
    return fields.any((f) => f.focusNode?.hasFocus ?? false);
  }

  Future<void> openAndCloseCard(WidgetTester tester) async {
    await tester.tap(find.text('Bravoes'));
    await tester.pumpAndSettle();
    final closeButton = find.byIcon(Icons.close);
    expect(closeButton, findsOneWidget, reason: 'card viewer should be open');
    await tester.tap(closeButton);
    await tester.pumpAndSettle();
  }

  testWidgets('never-focused search stays unfocused after a hire card', (
    tester,
  ) async {
    await pumpHireTab(tester);
    expect(searchFocused(tester), isFalse, reason: 'baseline');

    await openAndCloseCard(tester);

    expect(searchFocused(tester), isFalse, reason: 'after returning from card');
  });

  testWidgets('search focused when opening a card is not refocused on return', (
    tester,
  ) async {
    await pumpHireTab(tester);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(searchFocused(tester), isTrue, reason: 'user focused search');

    await openAndCloseCard(tester);

    expect(searchFocused(tester), isFalse, reason: 'after returning from card');
  });

  testWidgets('search blurred before opening a card is not refocused', (
    tester,
  ) async {
    await pumpHireTab(tester);

    // Focus once, then blur by tapping outside — through the screen's real dismiss handler, not a
    // direct unfocus, so this exercises exactly what a user does.
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.tap(find.text('The Rooks'));
    await tester.pump();
    expect(searchFocused(tester), isFalse, reason: 'blurred before opening');

    await openAndCloseCard(tester);

    expect(searchFocused(tester), isFalse, reason: 'after returning from card');
  });

  testWidgets('switching to the List tab drops search focus (and keyboard)', (
    tester,
  ) async {
    await pumpHireTab(tester);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(searchFocused(tester), isTrue, reason: 'user focused search');

    // Tap the List tab; the PageView animates across before onPageChanged fires.
    await tester.tap(find.text('List'));
    await tester.pumpAndSettle();

    expect(searchFocused(tester), isFalse, reason: 'after switching to List');
  });
}
