import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale/services/game_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_channel/stream_channel.dart';

import '../support/fake_api.dart';

void main() {
  final service = GameService();

  group('the live game snapshot', () {
    // Fake cable transports the watch opened, so tests can feed broadcasts without a real socket.
    late List<StreamChannelController<dynamic>> channels;

    setUp(() {
      channels = [];
      AuthService().debugLogin(
        const AuthUser(id: 1, email: 'a@b.c', username: 'me'),
      );
      service.debugChannelFactory = (uri) {
        final c = StreamChannelController<dynamic>();
        channels.add(c);
        return c.local;
      };
    });

    tearDown(() {
      service.stopWatching();
      service.debugChannelFactory = null;
    });

    Object gameState(api.Game game) => {
      'identifier': jsonEncode({'channel': 'GameChannel', 'game_id': 1}),
      'message': {'event': 'game_state', 'game': gameBody(game)},
    };

    test('applies a mutation response to currentGame with no broadcast (A-1)', () async {
      final adapter = installFakeApi();
      adapter.stub('POST', '/cable_tickets', {'ticket': 't'});
      adapter.stub(
        'GET',
        '/games/1',
        gameBody(
          fakeGame(
            id: 1,
            status: api.GameStatusEnum.inProgress,
            players: [fakeGamePlayer(id: 1, userId: 1, currentTurn: 1)],
          ),
        ),
      );

      await service.watch(1);
      expect(service.currentGame!.players.first.currentTurn, 1);

      // advanceTurn returns the fresh game; the acting player's UI must reflect it immediately from
      // the REST response, without waiting for (or depending on) the ActionCable echo.
      adapter.stub(
        'POST',
        '/games/1/turns/advance',
        gameBody(
          fakeGame(
            id: 1,
            status: api.GameStatusEnum.inProgress,
            players: [fakeGamePlayer(id: 1, userId: 1, currentTurn: 2)],
          ),
        ),
      );

      var notified = false;
      service.addListener(() => notified = true);
      await service.advanceTurn(1);

      expect(service.currentGame!.players.first.currentTurn, 2);
      expect(notified, isTrue);
    });

    test('ignores a broadcast for a game it is no longer watching (C-5)', () async {
      final adapter = installFakeApi();
      adapter.stub('POST', '/cable_tickets', {'ticket': 't'});
      adapter.stub(
        'GET',
        '/games/1',
        gameBody(fakeGame(id: 1, name: 'One', players: [fakeGamePlayer(userId: 1)])),
      );
      await service.watch(1);

      // A stray broadcast for a different game (e.g. a stale cable that outlived its watch) must
      // not clobber the current game.
      channels.first.foreign.sink.add(
        jsonEncode(gameState(fakeGame(id: 2, name: 'Two', players: [fakeGamePlayer(userId: 1)]))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(service.currentGame!.id, 1);

      // A broadcast for the watched game is still applied.
      channels.first.foreign.sink.add(
        jsonEncode(gameState(fakeGame(id: 1, name: 'One!', players: [fakeGamePlayer(userId: 1)]))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(service.currentGame!.name, 'One!');
    });

    test('a superseding watch wins (C-5)', () async {
      final adapter = installFakeApi();
      adapter.stub('POST', '/cable_tickets', {'ticket': 't'});
      adapter.stub('GET', '/games/1', gameBody(fakeGame(id: 1, players: [fakeGamePlayer(userId: 1)])));
      adapter.stub('GET', '/games/2', gameBody(fakeGame(id: 2, players: [fakeGamePlayer(userId: 1)])));

      await service.watch(1);
      await service.watch(2);

      expect(service.currentGame!.id, 2);
    });
  });

  group('wireEnum', () {
    test(
      'converts a multi-word enum constant to its snake_case wire value',
      () {
        expect(
          service.wireEnum(
            api.GameStatusEnum.gangSelection,
            const FullType(api.GameStatusEnum),
          ),
          'gang_selection',
        );
        expect(
          service.wireEnum(
            api.GameStatusEnum.inProgress,
            const FullType(api.GameStatusEnum),
          ),
          'in_progress',
        );
      },
    );

    test('matches the documented wire value for every status', () {
      const expected = {
        api.GameStatusEnum.pending: 'pending',
        api.GameStatusEnum.gangSelection: 'gang_selection',
        api.GameStatusEnum.agendaDraw: 'agenda_draw',
        api.GameStatusEnum.inProgress: 'in_progress',
        api.GameStatusEnum.completed: 'completed',
      };
      for (final entry in expected.entries) {
        expect(
          service.wireEnum(entry.key, const FullType(api.GameStatusEnum)),
          entry.value,
        );
      }
    });
  });
}
