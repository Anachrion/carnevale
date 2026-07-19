import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gang_builder_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

/// Tapping "add" on a hire tile adds the model optimistically. Regression for the build-time crash
/// where the optimistic temp entry omitted a required field (flexibleLeader) and threw on `.build()`,
/// so the "+" silently did nothing — a class of bug analyze/other tests miss because built_value only
/// checks required fields at runtime and nothing else exercises the add path.
void main() {
  testWidgets('the + button on a hire tile adds the model optimistically', (tester) async {
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(
          id: 1,
          name: 'Bravoes',
          faction: 'guild',
          keywords: const ['Henchman'],
          // A card-reference id distinct from the starter entry's, so its hired count starts at 0.
          cardReferences: [fakeCardReference(id: 99, profileName: 'Bravoes')],
        ),
      ], const FullType(api.Profile)),
    );
    adapter.stub('GET', '/equipment', listBody<api.Equipment>([], const FullType(api.Equipment)));
    adapter.stub('GET', '/spells', listBody<api.Spell>([], const FullType(api.Spell)));

    final gang = fakeModelList(name: 'The Rooks');
    // The optimistic add syncs in the background; hand back a gang so the op resolves cleanly.
    adapter.stub('POST', '/list_entries', modelListBody(gang));

    await tester.pumpWidget(MaterialApp(home: GangBuilderScreen(gang: gang)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Hire'));
    await tester.pump();
    // Let the 250ms tab-switch animation finish so the Hire tab is actually built.
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Bravoes'), findsOneWidget);
    // No copy hired yet.
    expect(find.text('×1'), findsNothing);

    // Tap the sole add (+) button — if building the optimistic entry threw, nothing would happen.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // The model was added optimistically: the hire tile shows a count badge.
    expect(find.text('×1'), findsOneWidget);

    // Let the background sync settle so no timer is left pending.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });
}
