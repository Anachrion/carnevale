import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Builds the transport for a connection attempt. Defaults to a real [WebSocketChannel]; tests
/// inject a fake so the reconnect/liveness logic can be driven without a socket.
typedef ChannelFactory = StreamChannel<dynamic> Function(Uri url);

/// A minimal Action Cable client: subscribes to a channel with parameters and
/// hands off each broadcast `message` payload for that channel to a callback.
///
/// Action Cable's wire protocol is plain JSON over a WebSocket:
/// `{"command": "subscribe", "identifier": "{...json...}"}` to subscribe, and
/// incoming frames are either protocol frames (`welcome`, `ping`,
/// `confirm_subscription`, `disconnect`) or `{"identifier": ..., "message": ...}`
/// broadcasts. There's no official Dart client for this, and the protocol is
/// simple enough that hand-rolling it avoids depending on an unmaintained package.
class ActionCableClient {
  ActionCableClient(this._connectionUrlProvider, {ChannelFactory? channelFactory})
    : _channelFactory = channelFactory ?? ((url) => WebSocketChannel.connect(url));

  /// Produces the URL to connect with. Called fresh on every attempt (initial and every reconnect)
  /// because the URL carries a single-use, short-lived cable ticket that can't be reused.
  final Future<String> Function() _connectionUrlProvider;
  final ChannelFactory _channelFactory;

  StreamChannel<dynamic>? _channel;
  StreamSubscription? _subscription;
  final _handlers = <String, void Function(Map<String, dynamic>)>{};
  Timer? _reconnectTimer;
  Timer? _watchdog;
  int _reconnectAttempts = 0;
  bool _disposed = false;
  final _random = Random();

  /// Invoked when minting a cable ticket fails with 401 — the session has expired, so no amount of
  /// reconnecting will help. The owner should tear the connection down and route to re-auth rather
  /// than let attempts spin on a dead credential.
  void Function()? onAuthFailure;

  // No frame at all — not even a keep-alive ping — within this window means the socket is dead
  // (typically half-open after a NAT timeout or an OS suspend), even though `onDone`/`onError`
  // never fired. The server pings every 3s, so 10s is three missed pings.
  static const _livenessTimeout = Duration(seconds: 10);
  static const _maxBackoff = Duration(seconds: 30);

  Future<void> connect() async {
    if (_disposed) return;

    final String url;
    try {
      url = await _connectionUrlProvider();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Expired session — reconnecting can't recover it. Hand off and stop.
        onAuthFailure?.call();
        return;
      }
      _scheduleReconnect();
      return;
    } catch (_) {
      // Transient failure minting a ticket (network blip); back off and retry.
      _scheduleReconnect();
      return;
    }
    if (_disposed) return; // may have been disposed while awaiting the ticket

    _channel = _channelFactory(Uri.parse(url));
    _subscription = _channel!.stream.listen(
      _handleFrame,
      onDone: _handleDrop,
      onError: (_) => _handleDrop(),
      cancelOnError: true,
    );
    _armWatchdog();
  }

  /// Subscribes to a channel identified by [params] (e.g. `{'channel': 'GameChannel', 'game_id': 1}`),
  /// invoking [onMessage] for every broadcast/transmit this connection receives for it.
  void subscribe(Map<String, dynamic> params, void Function(Map<String, dynamic> message) onMessage) {
    final identifier = jsonEncode(params);
    _handlers[identifier] = onMessage;
    _send({'command': 'subscribe', 'identifier': identifier});
  }

  void unsubscribe(Map<String, dynamic> params) {
    final identifier = jsonEncode(params);
    _handlers.remove(identifier);
    _send({'command': 'unsubscribe', 'identifier': identifier});
  }

  /// Forces an immediate reconnect, bypassing the backoff schedule. Called when the app returns to
  /// the foreground: a socket that died while suspended may not have surfaced an error yet, so we
  /// don't wait for the watchdog — we tear down and reconnect now, and the resubscribe transmits a
  /// fresh snapshot.
  void reconnectNow() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _teardownSocket();
    _reconnectAttempts = 0;
    connect();
  }

  void _send(Map<String, dynamic> payload) {
    _channel?.sink.add(jsonEncode(payload));
  }

  void _handleFrame(dynamic raw) {
    // Any frame — including a keep-alive ping — proves the socket is still alive.
    _armWatchdog();

    final Map<String, dynamic> frame;
    try {
      frame = jsonDecode(raw as String) as Map<String, dynamic>;
    } catch (_) {
      // A malformed or binary frame must not escape this callback (there's no onError for it) and
      // kill the stream — ignore it and keep listening.
      return;
    }

    switch (frame['type']) {
      case 'ping':
      case 'confirm_subscription':
        return;
      case 'welcome':
        // A live connection resets the backoff schedule.
        _reconnectAttempts = 0;
        // Re-subscribe to every channel after a fresh connection (initial or reconnect). The server
        // transmits a full snapshot on subscribe, so this doubles as the reconnect resync — no
        // separate REST refetch needed (which could otherwise race the broadcast, A-3).
        for (final identifier in _handlers.keys) {
          _send({'command': 'subscribe', 'identifier': identifier});
        }
        return;
      case 'disconnect':
      case 'reject_subscription':
        return;
    }
    final identifier = frame['identifier'] as String?;
    final message = frame['message'];
    if (identifier != null && message is Map) {
      _handlers[identifier]?.call(message.cast<String, dynamic>());
    }
  }

  void _armWatchdog() {
    _watchdog?.cancel();
    if (_disposed) return;
    _watchdog = Timer(_livenessTimeout, _handleDrop);
  }

  // A dropped or silently-dead socket: tear it down and schedule a reconnect. Reachable from
  // onDone, onError, and the liveness watchdog; idempotent, so overlapping triggers are harmless.
  void _handleDrop() {
    if (_disposed) return;
    _teardownSocket();
    _scheduleReconnect();
  }

  void _teardownSocket() {
    _watchdog?.cancel();
    _watchdog = null;
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_backoffDelay(), connect);
    _reconnectAttempts++;
  }

  // Exponential backoff with jitter, capped: a quick first retry, then easing off so a downed
  // backend isn't hammered every few seconds by every open session (battery drain, and a
  // thundering herd the moment it recovers). Jitter spreads clients across the window.
  Duration _backoffDelay() {
    final seconds = min(1 << _reconnectAttempts.clamp(0, 5), _maxBackoff.inSeconds);
    return Duration(seconds: seconds, milliseconds: _random.nextInt(1000));
  }

  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _teardownSocket();
  }
}
