import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

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
  ActionCableClient(this._connectionUrlProvider);

  /// Produces the URL to connect with. Called fresh on every attempt (initial and every reconnect)
  /// because the URL carries a single-use, short-lived cable ticket that can't be reused.
  final Future<String> Function() _connectionUrlProvider;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _handlers = <String, void Function(Map<String, dynamic>)>{};
  Timer? _reconnectTimer;
  bool _disposed = false;
  bool _welcomedOnce = false;

  /// Invoked after a *reconnect* completes (not the first connection), so the owner can refetch
  /// state that may have changed while the socket was down — broadcasts during downtime are lost.
  void Function()? onReconnect;

  Future<void> connect() async {
    if (_disposed) return;

    final String url;
    try {
      url = await _connectionUrlProvider();
    } catch (_) {
      // Couldn't mint a ticket (transient network / expired session); back off and retry.
      _scheduleReconnect();
      return;
    }
    if (_disposed) return; // may have been disposed while awaiting the ticket

    _channel = WebSocketChannel.connect(Uri.parse(url));
    _subscription = _channel!.stream.listen(
      _handleFrame,
      onDone: _scheduleReconnect,
      onError: (_) => _scheduleReconnect(),
      cancelOnError: true,
    );
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

  void _send(Map<String, dynamic> payload) {
    _channel?.sink.add(jsonEncode(payload));
  }

  void _handleFrame(dynamic raw) {
    final frame = jsonDecode(raw as String) as Map<String, dynamic>;
    switch (frame['type']) {
      case 'ping':
      case 'confirm_subscription':
        return;
      case 'welcome':
        // Re-subscribe to every channel after a fresh connection (initial or reconnect).
        for (final identifier in _handlers.keys) {
          _send({'command': 'subscribe', 'identifier': identifier});
        }
        // A welcome after the first one means we just reconnected: let the owner resync state
        // that may have drifted while the socket was down.
        if (_welcomedOnce) onReconnect?.call();
        _welcomedOnce = true;
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

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), connect);
  }

  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
  }
}
