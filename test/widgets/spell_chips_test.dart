import 'package:carnevale/widgets/spell_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('SpellChip shows the spell name and its discipline label on tap', (tester) async {
    final spell = fakeSpell(name: 'Blood Boil');

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: SpellChip(spell: spell))),
    );
    await tester.pump();

    expect(find.text('Blood Boil'), findsOneWidget);

    await tester.tap(find.byType(SpellChip));
    await tester.pump();

    // The detail dialog renders the discipline via disciplineLabel(disciplineSlug(spell.discipline)).
    expect(find.textContaining('Blood Rites'), findsOneWidget);
  });
}
