import 'package:carnevale/models/gang.dart';
import 'package:carnevale/widgets/spell_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SpellChip shows the spell name and its discipline label on tap', (tester) async {
    const spell = Spell(
      id: 1,
      name: 'Blood Boil',
      discipline: 'blood_rites',
      cost: 2,
      difficulty: 3,
      cantrip: false,
      description: 'Boils the blood.',
    );

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpellChip(spell: spell))),
    );
    await tester.pump();

    expect(find.text('Blood Boil'), findsOneWidget);

    await tester.tap(find.byType(SpellChip));
    await tester.pump();

    // The detail dialog renders the discipline via disciplineLabel(spell.discipline).
    expect(find.textContaining('Blood Rites'), findsOneWidget);
  });
}
