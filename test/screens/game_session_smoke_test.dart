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

  testWidgets(
    'agenda-draw phase shows a confirm button, then waits after confirming',
    (tester) async {
      AuthService().debugLogin(
        const AuthUser(id: 1, email: 'a@b.c', username: 'me'),
      );
      final adapter = installFakeApi();
      adapter.stub('POST', '/cable_tickets', {'ticket': 'test-ticket'});

      final agendas = [fakeAgenda(id: 7, name: 'Cut Them Down')];

      // Before confirming: the review/confirm button is offered, no waiting spinner text.
      adapter.stub(
        'GET',
        '/games/1',
        gameBody(
          fakeGame(
            id: 1,
            status: api.GameStatusEnum.agendaDraw,
            players: [fakeGamePlayer(id: 1, userId: 1, agendas: agendas)],
          ),
        ),
      );
      await tester.pumpWidget(
        const MaterialApp(home: GameSessionScreen(gameId: 1)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text("I've reviewed my Agendas"), findsOneWidget);
      expect(find.text('Waiting for the opponent to be ready...'), findsNothing);

      // Unmount so the second mount re-fetches (the const widget would otherwise reuse state).
      await tester.pumpWidget(const SizedBox());

      // After confirming: the button is gone, replaced by the waiting state.
      adapter.stub(
        'GET',
        '/games/1',
        gameBody(
          fakeGame(
            id: 1,
            status: api.GameStatusEnum.agendaDraw,
            players: [
              fakeGamePlayer(
                id: 1,
                userId: 1,
                agendas: agendas,
                agendasConfirmed: true,
              ),
            ],
          ),
        ),
      );
      await tester.pumpWidget(
        const MaterialApp(home: GameSessionScreen(gameId: 1)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text("I've reviewed my Agendas"), findsNothing);
      expect(
        find.text('Waiting for the opponent to be ready...'),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox());
    },
  );
}
