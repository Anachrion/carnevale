import 'dart:convert';

import 'package:carnevale/services/action_cable_client.dart';
import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_channel/stream_channel.dart';

void main() {
  group('ActionCableClient', () {
    // The channels the client opened, newest last. The client drives `.local`; a test feeds frames
    // to the client via `.foreign.sink` and reads the client's outgoing frames via `.foreign.stream`.
    late List<StreamChannelController<dynamic>> channels;

    ChannelFactory recordingFactory() => (uri) {
      final controller = StreamChannelController<dynamic>();
      channels.add(controller);
      return controller.local;
    };

    setUp(() => channels = []);

    DioException unauthorized() => DioException(
      requestOptions: RequestOptions(path: '/cable_tickets'),
      response: Response(
        requestOptions: RequestOptions(path: '/cable_tickets'),
        statusCode: 401,
      ),
    );

    test('reconnects after the liveness window elapses with no frames', () {
      fakeAsync((async) {
        final client = ActionCableClient(
          () async => 'ws://test/cable',
          channelFactory: recordingFactory(),
        );
        client.connect();
        async.flushMicrotasks();
        expect(channels, hasLength(1)); // connected once

        // No frame at all for the liveness window: the socket is silently dead, so the watchdog
        // must fire (onDone/onError never do here) and a backoff reconnect must open a new channel.
        async.elapse(const Duration(seconds: 11)); // watchdog (10s) fires
        async.elapse(const Duration(seconds: 3)); // first backoff (~1-2s) reconnects
        expect(channels.length, greaterThanOrEqualTo(2));

        client.dispose();
      });
    });

    test('a steady stream of pings keeps the connection alive', () {
      fakeAsync((async) {
        final client = ActionCableClient(
          () async => 'ws://test/cable',
          channelFactory: recordingFactory(),
        );
        client.connect();
        async.flushMicrotasks();
        expect(channels, hasLength(1));

        // A ping every 3s (< the 10s window) re-arms the watchdog each time, so it never fires.
        for (var i = 0; i < 5; i++) {
          channels.first.foreign.sink.add(jsonEncode({'type': 'ping'}));
          async.flushMicrotasks();
          async.elapse(const Duration(seconds: 3));
        }
        expect(channels, hasLength(1)); // still the original connection

        client.dispose();
      });
    });

    test('stops and reports an auth failure on a 401 ticket error', () {
      fakeAsync((async) {
        var authFailures = 0;
        final client = ActionCableClient(
          () async => throw unauthorized(),
          channelFactory: recordingFactory(),
        )..onAuthFailure = () => authFailures++;

        client.connect();
        async.flushMicrotasks();
        expect(authFailures, 1);
        expect(channels, isEmpty); // never opened a socket

        // No reconnect scheduled: time passing changes nothing (the loop the old code had is gone).
        async.elapse(const Duration(seconds: 60));
        expect(authFailures, 1);
        expect(channels, isEmpty);

        client.dispose();
      });
    });

    test('schedules a reconnect on a transient (non-401) ticket failure', () {
      fakeAsync((async) {
        var attempts = 0;
        final client = ActionCableClient(() async {
          attempts++;
          if (attempts == 1) throw Exception('network down');
          return 'ws://test/cable';
        }, channelFactory: recordingFactory());

        client.connect();
        async.flushMicrotasks();
        expect(attempts, 1);
        expect(channels, isEmpty); // first attempt couldn't mint a ticket

        async.elapse(const Duration(seconds: 3)); // backoff window
        expect(attempts, 2);
        expect(channels, hasLength(1)); // second attempt connected

        client.dispose();
      });
    });

    test('resubscribes on welcome and routes broadcasts to the handler', () {
      fakeAsync((async) {
        final client = ActionCableClient(
          () async => 'ws://test/cable',
          channelFactory: recordingFactory(),
        );
        client.connect();
        async.flushMicrotasks();

        // Capture what the client sends before it sends anything.
        final sent = <Map<String, dynamic>>[];
        channels.first.foreign.stream.listen(
          (raw) => sent.add(jsonDecode(raw as String) as Map<String, dynamic>),
        );

        final params = {'channel': 'GameChannel', 'game_id': 1};
        final received = <Map<String, dynamic>>[];
        client.subscribe(params, received.add);
        async.flushMicrotasks();

        // A welcome (as after a reconnect) makes the client re-subscribe every channel.
        channels.first.foreign.sink.add(jsonEncode({'type': 'welcome'}));
        async.flushMicrotasks();

        final id = jsonEncode(params);
        final subscribes = sent.where(
          (f) => f['command'] == 'subscribe' && f['identifier'] == id,
        );
        expect(subscribes.length, greaterThanOrEqualTo(2)); // initial + on welcome

        // A broadcast for that identifier reaches the registered handler.
        channels.first.foreign.sink.add(
          jsonEncode({
            'identifier': id,
            'message': {'event': 'game_state', 'x': 1},
          }),
        );
        async.flushMicrotasks();
        expect(received, hasLength(1));
        expect(received.first['event'], 'game_state');

        client.dispose();
      });
    });

    test('reconnectNow tears down and opens a fresh connection immediately', () {
      fakeAsync((async) {
        final client = ActionCableClient(
          () async => 'ws://test/cable',
          channelFactory: recordingFactory(),
        );
        client.connect();
        async.flushMicrotasks();
        expect(channels, hasLength(1));

        client.reconnectNow();
        async.flushMicrotasks();
        expect(channels, hasLength(2)); // reconnected without waiting for the watchdog/backoff

        client.dispose();
      });
    });
  });
}
