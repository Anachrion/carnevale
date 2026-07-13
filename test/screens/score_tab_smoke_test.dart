import 'package:carnevale/screens/game_session_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets(
    'Score tab shows scenario, turn, score, and the hand for an in-progress game',
    (tester) async {
      AuthService().debugLogin(
        const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
      );
      final adapter = installFakeApi();

      final me = fakeGamePlayer(
        id: 1,
        userId: 1,
        username: 'tester',
        score: 2,
        currentTurn: 3,
        agendas: [fakeAgenda(id: 7, name: 'No Mercy')],
      );
      final opponent = fakeGamePlayer(
        id: 2,
        userId: 2,
        username: 'rival',
        host: false,
        score: 1,
      );
      final game = fakeGame(
        id: 1,
        status: api.GameStatusEnum.inProgress,
        scenario: fakeScenario(
          name: 'Acquisition',
          agendaRules: const [api.ScenarioAgendaRulesEnum.secret],
        ),
        players: [me, opponent],
      );

      adapter.stub('GET', '/games/1', gameBody(game));
      adapter.stub('POST', '/cable_tickets', {'ticket': 'test-ticket'});
      // The two gang tabs fetch each player's list; canned so they don't 404-noise the log.
      adapter.stub(
        'GET',
        '/games/1/players/1/list',
        modelListBody(fakeModelList()),
      );
      adapter.stub(
        'GET',
        '/games/1/players/2/list',
        modelListBody(fakeModelList()),
      );

      await tester.pumpWidget(
        const MaterialApp(home: GameSessionScreen(gameId: 1)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Score is the first (default) tab.
      expect(find.text('Acquisition'), findsWidgets);
      expect(find.text('Turn 3 of 5'), findsOneWidget);
      expect(find.text('2'), findsWidgets); // my score
      expect(
        find.text('1 - No Mercy'),
        findsOneWidget,
      ); // my hand agenda (numbered)
      expect(find.text('Secret'), findsOneWidget); // agenda-rule badge
      // Opponent's hand is hidden under the Secret rule.
      expect(
        find.text('Hidden — this scenario has the Secret rule.'),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('offers End game on the last turn and opens the per-player log', (
    tester,
  ) async {
    AuthService().debugLogin(
      const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
    );
    final adapter = installFakeApi();

    final me = fakeGamePlayer(
      id: 1,
      userId: 1,
      username: 'tester',
      score: 1,
      currentTurn: 5, // last turn of the 5-turn scenario
      agendaHistory: [
        fakeAgendaHistoryEntry(turn: 2, agendaName: 'Venetian Sniper'),
      ],
    );
    final opponent = fakeGamePlayer(
      id: 2,
      userId: 2,
      username: 'rival',
      host: false,
    );
    final game = fakeGame(
      id: 1,
      status: api.GameStatusEnum.inProgress,
      players: [me, opponent],
    );

    adapter.stub('GET', '/games/1', gameBody(game));
    adapter.stub('POST', '/cable_tickets', {'ticket': 'test-ticket'});
    adapter.stub(
      'GET',
      '/games/1/players/1/list',
      modelListBody(fakeModelList()),
    );
    adapter.stub(
      'GET',
      '/games/1/players/2/list',
      modelListBody(fakeModelList()),
    );

    await tester.pumpWidget(
      const MaterialApp(home: GameSessionScreen(gameId: 1)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Turn 5 of 5'), findsOneWidget);
    expect(find.text('End game'), findsOneWidget); // only on the last turn

    // Open my log and confirm the turn-2 score is listed under its turn.
    await tester.tap(find.text('Log').first);
    await tester.pumpAndSettle();
    expect(find.text('TURN 2'), findsOneWidget);
    expect(find.text('Venetian Sniper'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
