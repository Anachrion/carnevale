import 'package:carnevale/screens/game_session_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('GameSessionScreen renders the lobby for a pending game', (tester) async {
    AuthService().debugLogin(const AuthUser(id: 1, email: 'a@b.c', username: 'tester'));
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/games/1',
      gameBody(fakeGame(id: 1, joinCode: 'XYZ789', status: api.GameStatusEnum.pending)),
    );
    // watch() opens an ActionCable connection, which first mints a ticket over REST.
    adapter.stub('POST', '/cable_tickets', {'ticket': 'test-ticket'});

    await tester.pumpWidget(const MaterialApp(home: GameSessionScreen(gameId: 1)));
    await tester.pump(); // initial snapshot resolves
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Waiting for an opponent'), findsOneWidget);
    expect(find.text('XYZ789'), findsWidgets);

    // Dispose the screen so stopWatching() cancels the cable reconnect timer before the test ends.
    await tester.pumpWidget(const SizedBox());
  });
}
