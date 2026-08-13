import 'package:built_value/serializer.dart';
import 'package:carnevale/models/game_setup.dart';
import 'package:carnevale/screens/game_home_screen.dart';
import 'package:carnevale/services/api_client.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// Sharing a game *setup* (CARNEVALEB-74). The settings travel in the link's query string, so the
/// two things worth guarding are that a link survives the round trip, and that opening one lands
/// the recipient on a form that really is filled with the sender's choices.
void main() {
  group('GameSetup', () {
    test('round-trips through a URL', () {
      const sent = GameSetup(
        scenarioName: 'Gang War',
        name: 'Canal Duel',
        ducatLimit: 200,
        boardSize: '4x4',
      );

      final back = GameSetup.fromUri(Uri.parse(sent.toUrl()))!;

      expect(back.scenarioName, 'Gang War');
      expect(back.name, 'Canal Duel');
      expect(back.ducatLimit, 200);
      expect(back.boardSize, '4x4');
    });

    test('points at the backend origin and the deep-linked path', () {
      final uri = Uri.parse(const GameSetup(ducatLimit: 150).toUrl());

      expect(uri.origin, ApiClient.origin);
      expect(uri.path, GameSetup.path);
      // Fields nobody set are absent rather than empty, so the recipient's form is only pre-filled
      // where a choice was actually made.
      expect(uri.queryParameters.keys, ['ducats']);
    });

    test('a bare /new-game carries no setup', () {
      expect(GameSetup.fromUri(Uri.parse('https://x.test/new-game')), isNull);
      // Blank values are the same thing as absent ones — a link with an empty name is not a setup.
      expect(
        GameSetup.fromUri(Uri.parse('https://x.test/new-game?name=%20')),
        isNull,
      );
    });

    test('a non-numeric Ducat limit is dropped, not guessed', () {
      final setup = GameSetup.fromUri(
        Uri.parse('https://x.test/new-game?name=Duel&ducats=lots'),
      )!;

      expect(setup.name, 'Duel');
      expect(setup.ducatLimit, isNull);
    });
  });

  group('opening a shared setup', () {
    void signIn() => AuthService().debugLogin(
      const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
    );

    /// The create sheet hints the game-name field with the selected scenario, so this reads back
    /// which scenario the sheet actually settled on.
    String? selectedScenarioName(WidgetTester tester) => tester
        .widget<TextField>(find.byType(TextField).first)
        .decoration
        ?.hintText;

    void stubHome(
      FakeApiAdapter adapter, {
      required List<api.Scenario> scenarios,
    }) {
      adapter.stub(
        'GET',
        '/games',
        listBody<api.Game>([], const FullType(api.Game)),
      );
      adapter.stub(
        'GET',
        '/scenarios',
        listBody<api.Scenario>(scenarios, const FullType(api.Scenario)),
      );
    }

    testWidgets('fills the create sheet with the shared settings', (
      tester,
    ) async {
      signIn();
      final adapter = installFakeApi();
      stubHome(
        adapter,
        scenarios: [
          fakeScenario(id: 1, name: 'Gang War'),
          fakeScenario(id: 2, name: 'The Doge\'s Gold'),
        ],
      );

      await tester.pumpWidget(
        localizedApp(
          home: const GameHomeScreen(
            initialSetup: GameSetup(
              // Lower-cased on purpose: a link that has been through a URL shortener or a chat
              // client should still match the scenario it names.
              scenarioName: 'the doge\'s gold',
              name: 'Canal Duel',
              ducatLimit: 200,
              boardSize: '4x4',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings from a shared link'), findsOneWidget);
      expect(find.text('Canal Duel'), findsOneWidget);
      // Not the scenario's own 150 Ducats: the shared limit is the whole point of the link.
      expect(find.text('200'), findsOneWidget);
      expect(find.text('4x4'), findsOneWidget);
      // Selected by name, not by id: the sending and receiving apps may talk to databases whose
      // scenario ids do not line up. The name field hints with the selected scenario, which is the
      // one place the *selection* shows through — both scenarios appear in the list either way.
      expect(selectedScenarioName(tester), 'The Doge\'s Gold');
    });

    testWidgets('falls back to the first scenario when the name is unknown', (
      tester,
    ) async {
      signIn();
      final adapter = installFakeApi();
      stubHome(adapter, scenarios: [fakeScenario(id: 1, name: 'Gang War')]);

      await tester.pumpWidget(
        localizedApp(
          home: const GameHomeScreen(
            initialSetup: GameSetup(scenarioName: 'Renamed Since'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The form is still usable — a scenario is selected, so Create is enabled.
      expect(selectedScenarioName(tester), 'Gang War');
      final create = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Create Game'),
      );
      expect(create.onPressed, isNotNull);
    });

    testWidgets('without a shared setup no sheet opens by itself', (
      tester,
    ) async {
      signIn();
      final adapter = installFakeApi();
      stubHome(adapter, scenarios: [fakeScenario(id: 1, name: 'Gang War')]);

      await tester.pumpWidget(localizedApp(home: const GameHomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Settings from a shared link'), findsNothing);
      expect(find.text('Create Game'), findsNothing);
    });
  });
}
