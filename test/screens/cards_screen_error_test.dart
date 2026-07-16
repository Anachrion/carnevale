import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/cards_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('shows a retry view when the catalog fails to load, then recovers', (
    tester,
  ) async {
    // No /profiles stub: the initial load fails (the fake adapter 404s an unstubbed route), which
    // used to leave the screen spinning forever with an unhandled exception (C-6).
    final adapter = installFakeApi();

    await tester.pumpWidget(const MaterialApp(home: CardsScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Retry'), findsOneWidget);

    // Retry once the network is back: the catalog loads and the retry view is replaced by cards.
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(name: 'Capodecina'),
      ], const FullType(api.Profile)),
    );
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Retry'), findsNothing);
    expect(find.text('Capodecina'), findsOneWidget);
  });
}
