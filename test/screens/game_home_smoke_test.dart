import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/game_home_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('GameHomeScreen renders the current user\'s games from the API', (
    tester,
  ) async {
    AuthService().debugLogin(
      const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
    );
    final adapter = installFakeApi();
    // getGames is called for both 'active' and 'archived' (same path, differing query); the fake
    // adapter matches on path, so both resolve to this stub.
    adapter.stub(
      'GET',
      '/games',
      listBody<api.Game>([
        fakeGame(name: 'Midnight Duel'),
      ], const FullType(api.Game)),
    );

    await tester.pumpWidget(const MaterialApp(home: GameHomeScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Midnight Duel'), findsWidgets);
  });
}
