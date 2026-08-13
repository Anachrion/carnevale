import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/game_session_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:carnevale/models/game_setup.dart';
import 'package:carnevale/share_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

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
      localizedApp(home: const GameSessionScreen(gameId: 1)),
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
        localizedApp(home: const GameSessionScreen(gameId: 1)),
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
        localizedApp(home: const GameSessionScreen(gameId: 1)),
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
        localizedApp(home: const GameSessionScreen(gameId: 1)),
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

  // CARNEVALEB-74. The URL shape is a three-way contract: Rails routes `/join`, the Android
  // manifest claims that exact path, and main.dart reads `?code=`. Nothing else pins it, and a
  // drift to e.g. `/join/CODE` would break the link silently on every surface at once.
  testWidgets('the lobby offers the join link as a QR carrying the /join URL', (
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
    adapter.stub('POST', '/cable_tickets', {'ticket': 'test-ticket'});

    await tester.pumpWidget(
      localizedApp(home: const GameSessionScreen(gameId: 1)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Three ways out of the lobby, for the three situations: paste it anywhere, send it through
    // another app, or hold the screen up to the player opposite.
    expect(find.text('Copy link'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('QR code'), findsOneWidget);

    await tester.tap(find.text('QR code'));
    await tester.pumpAndSettle();

    expect(find.text('Scan to join'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  // The URL shape itself, asserted directly: QrImageView keeps its payload private, so the widget
  // test above can only prove a QR is shown, not what it encodes.
  test('joinUrlFor builds the path Rails routes and the manifest claims', () {
    expect(joinUrlFor('XYZ789'), '$shareSiteOrigin/join?code=XYZ789');
    expect(Uri.parse(joinUrlFor('ABC123')).path, '/join');
    expect(Uri.parse(joinUrlFor('ABC123')).queryParameters['code'], 'ABC123');
  });

  // What the emulator caught: built on ApiClient.origin, a dev build handed out
  // "http://10.0.2.2:3000/join?code=…" — an address that means something only on the phone that
  // produced it. A shared link has to be reachable from someone else's device, so it points at the
  // public site over https whatever backend this build talks to.
  test('shared links point at the public site, not at this build\'s backend', () {
    for (final url in [joinUrlFor('XYZ789'), const GameSetup(ducatLimit: 200).toUrl()]) {
      final uri = Uri.parse(url);
      expect(uri.scheme, 'https', reason: url);
      expect(uri.host, isNot(anyOf('localhost', '10.0.2.2')), reason: url);
      expect(uri.hasPort, isFalse, reason: url);
      // The hosts the Android manifest claims as App Links — anything else opens the browser.
      expect(uri.host, anyOf('carnevale-app.com', 'www.carnevale-app.com'), reason: url);
    }
  });
}
