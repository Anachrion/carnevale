import 'package:carnevale/screens/card_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('CardViewerScreen renders the card pager for the given profiles', (tester) async {
    final profiles = [fakeProfile(name: 'Capodecina'), fakeProfile(id: 2, name: 'Bombardier')];

    await tester.pumpWidget(
      MaterialApp(home: CardViewerScreen(profiles: profiles, initialIndex: 0)),
    );
    await tester.pump();

    // The page indicator reflects position/count (reached via the ProfileX front/back image getters).
    expect(find.textContaining('1 / 2'), findsOneWidget);
  });
}
