import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/game_session_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  testWidgets('GameSessionScreen renders the lobby for a pending game', (
    tester,
  ) async {
    AuthService().debugLogin(
      const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
    );
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/games/1',
      gameBody(
        fakeGame(id: 1, joinCode: 'XYZ789', status: api.GameStatusEnum.pending),
      ),
    );
    // watch() opens an ActionCable connection, which first mints a ticket over REST.
    adapter.stub('POST', '/cable_tickets', {'ticket': 'test-ticket'});

    await tester.pumpWidget(
      const MaterialApp(home: GameSessionScreen(gameId: 1)),
    );
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
      // The agenda_draw phase also fetches the player's own gang + the spell catalog for the
      // "Your Spells" section; a Mage-less gang keeps that section collapsed (SizedBox.shrink)
      // without pulling extra widgets into these agenda-focused assertions.
      adapter.stub(
        'GET',
        '/spells',
        listBody<api.Spell>([], const FullType(api.Spell)),
      );
      adapter.stub('GET', '/games/1/players/1/list', modelListBody(fakeModelList()));

      final agendas = [fakeAgenda(id: 7, name: 'Cut Them Down')];
      final discarded = [
        fakeAgendaHistoryEntry(
          action: api.AgendaHistoryEntryActionEnum.discarded,
          origin: api.AgendaHistoryEntryOriginEnum.unachievable,
          agendaId: 9,
          agendaName: 'Watery Grave',
        ),
      ];

      // Before confirming: the review/confirm button is offered, no waiting spinner text.
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
                agendaHistory: discarded,
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

      expect(find.text("Ready"), findsOneWidget);
      expect(
        find.text('Waiting for the opponent to be ready...'),
        findsNothing,
      );
      // Mulliganed agendas live under a collapsed "Discarded (N)" header; the name is hidden until
      // the section is expanded by tapping it.
      expect(find.text('Discarded (1)'), findsOneWidget);
      expect(find.text('Watery Grave'), findsNothing);
      await tester.tap(find.text('Discarded (1)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Watery Grave'), findsOneWidget);

      // Let the "Your Spells" section's own fetches (spells catalog + player list) settle before
      // unmounting, so Dio's per-request timer is cancelled rather than left pending (B-timer).
      await tester.pump(const Duration(milliseconds: 50));

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

      expect(find.text("Ready"), findsNothing);
      expect(
        find.text('Waiting for the opponent to be ready...'),
        findsOneWidget,
      );

      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'agenda-draw phase shows a dealing placeholder before the hand arrives',
    (tester) async {
      AuthService().debugLogin(
        const AuthUser(id: 1, email: 'a@b.c', username: 'me'),
      );
      final adapter = installFakeApi();
      adapter.stub('POST', '/cable_tickets', {'ticket': 'test-ticket'});
      // The agenda_draw phase also fetches the player's own gang + the spell catalog for the
      // "Your Spells" section; a Mage-less gang keeps that section collapsed (SizedBox.shrink)
      // without pulling extra widgets into these agenda-focused assertions.
      adapter.stub(
        'GET',
        '/spells',
        listBody<api.Spell>([], const FullType(api.Spell)),
      );
      adapter.stub('GET', '/games/1/players/1/list', modelListBody(fakeModelList()));

      // In agenda_draw but the auto-dealt hand hasn't landed yet (empty agendas): the screen shows
      // a loading placeholder rather than a Draw button — there's no draw action to offer anymore.
      adapter.stub(
        'GET',
        '/games/1',
        gameBody(
          fakeGame(
            id: 1,
            status: api.GameStatusEnum.agendaDraw,
            players: [fakeGamePlayer(id: 1, userId: 1, agendas: const [])],
          ),
        ),
      );
      await tester.pumpWidget(
        const MaterialApp(home: GameSessionScreen(gameId: 1)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Dealing your Agendas'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // No draw button and nothing to confirm yet.
      expect(find.text('Draw'), findsNothing);
      expect(find.text('Ready'), findsNothing);

      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(const SizedBox());
    },
  );
}
