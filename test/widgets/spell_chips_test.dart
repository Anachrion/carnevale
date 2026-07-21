import 'package:carnevale/widgets/spell_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/l10n.dart';

void main() {
  const uncast = KnownSpell(
    key: 'pool-1:5',
    name: 'Blood Boil',
    cost: 2,
    difficulty: 3,
    description: 'Boils the blood.',
    cantrip: false,
  );
  const cast = KnownSpell(
    key: 'pool-1:6',
    name: 'Ice Lock',
    cost: 1,
    difficulty: 6,
    description: 'Freezes solid.',
    cantrip: false,
    cast: true,
  );

  testWidgets("SpellsButton shows how many of the model's spells are cast", (tester) async {
    await tester.pumpWidget(
      localizedApp(home: Scaffold(body: SpellsButton(spells: [uncast, cast]))),
    );

    expect(find.text('Spells · 1/2 cast'), findsOneWidget);
  });

  testWidgets('tapping a spell row toggles it locally and calls onToggle', (tester) async {
    KnownSpell? toggled;
    await tester.pumpWidget(
      localizedApp(
        home: Scaffold(body: SpellsButton(spells: [uncast], onToggle: (s) => toggled = s)),
      ),
    );

    await tester.tap(find.byType(SpellsButton));
    await tester.pumpAndSettle();

    expect(find.text('Blood Boil'), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);

    await tester.tap(find.text('Blood Boil'));
    await tester.pump();

    expect(toggled?.key, 'pool-1:5');
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('without onToggle, rows are read-only', (tester) async {
    await tester.pumpWidget(localizedApp(home: Scaffold(body: SpellsButton(spells: [cast]))));

    await tester.tap(find.byType(SpellsButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ice Lock'));
    await tester.pump();

    // Still cast — nothing wired up to toggle it.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
