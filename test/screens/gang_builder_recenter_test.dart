import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/card_viewer_screen.dart';
import 'package:carnevale/screens/gang_builder_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('Returning from the card viewer centres the card you ended on', (tester) async {
    // Enough profiles that the hire list scrolls and the target starts well off-screen. All are
    // rank-and-file guild so the default role sort leaves them in name order, and there is no
    // mercenaries section to offset the list.
    final profiles = [
      for (var i = 0; i < 30; i++)
        fakeProfile(
          id: i + 1,
          name: 'Profile ${i.toString().padLeft(2, '0')}',
          faction: 'guild',
          ducats: 10 + i,
          keywords: const [],
        ),
    ];

    final adapter = installFakeApi();
    adapter.stub('GET', '/profiles', listBody<api.Profile>(profiles, const FullType(api.Profile)));
    adapter.stub('GET', '/equipment', listBody<api.Equipment>([], const FullType(api.Equipment)));
    adapter.stub('GET', '/spells', listBody<api.Spell>([], const FullType(api.Spell)));

    await tester.pumpWidget(MaterialApp(home: GangBuilderScreen(gang: fakeModelList())));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Hire'));
    await tester.pumpAndSettle();

    // Profile 12 is far enough down the list that it is not built yet.
    expect(find.text('Profile 12'), findsNothing);

    // Open the first card, then page down to Profile 12 (the viewer's arrow keys drive the same
    // PageView as an up/down swipe).
    await tester.tap(find.text('Profile 00'));
    await tester.pumpAndSettle();
    expect(find.byType(CardViewerScreen), findsOneWidget);

    for (var i = 0; i < 12; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
    }
    expect(find.textContaining('13 / 30'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Back on the hire tab, the card we ended on is built and sits mid-viewport.
    final tile = find.text('Profile 12');
    expect(tile, findsOneWidget);

    final viewport = tester.getRect(find.byType(CustomScrollView));
    expect(tester.getCenter(tile).dy, closeTo(viewport.center.dy, 30));
  });
}
