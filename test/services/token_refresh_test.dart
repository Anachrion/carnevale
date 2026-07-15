import 'dart:convert';
import 'dart:typed_data';

import 'package:carnevale/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records every request and replies from a scripted queue per `METHOD path`, so a route can return
/// 401 on its first hit and 200 afterwards — enough to exercise the refresh-and-retry interceptor,
/// which the canned-body FakeApiAdapter can't sequence.
class _ScriptedAdapter implements HttpClientAdapter {
  final Map<String, List<ResponseBody Function()>> _scripts = {};
  final List<RequestOptions> requests = [];

  void script(String method, String path, List<ResponseBody Function()> steps) {
    _scripts['$method $path'] = List.of(steps);
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final steps = _scripts['${options.method} ${options.path}'];
    if (steps == null || steps.isEmpty) {
      return ResponseBody.fromString('{}', 404);
    }
    // Repeat the last step once exhausted, so "always 200 after the first 401" needs just two entries.
    final step = steps.length == 1 ? steps.first : steps.removeAt(0);
    return step();
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, int status, {Map<String, List<String>>? headers}) =>
    ResponseBody.fromString(
      json.encode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...?headers,
      },
    );

void main() {
  late ApiClient client;
  late _ScriptedAdapter adapter;

  setUp(() {
    client = ApiClient();
    adapter = _ScriptedAdapter();
    client.dio.httpClientAdapter = adapter;
    client.authToken = 'expired-jwt';
    client.onUnauthorized = null;
    client.performRefresh = null;
  });

  test('refreshes once on 401, then replays the original request with the new token', () async {
    var refreshCalls = 0;
    client.performRefresh = () async {
      refreshCalls++;
      client.authToken = 'fresh-jwt';
      return 'fresh-jwt';
    };
    adapter.script('GET', '/lists', [
      () => _json({'errors': {}}, 401),
      () => _json([], 200),
    ]);

    final res = await client.dio.get('/lists');

    expect(res.statusCode, 200);
    expect(refreshCalls, 1);
    // The replay carried the refreshed token, not the stale one.
    final replay = adapter.requests.last;
    expect(replay.headers['Authorization'], 'Bearer fresh-jwt');
  });

  test('a single refresh serves several concurrent 401s (single-flight)', () async {
    var refreshCalls = 0;
    client.performRefresh = () async {
      refreshCalls++;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      client.authToken = 'fresh-jwt';
      return 'fresh-jwt';
    };
    for (final path in ['/lists', '/games', '/profiles']) {
      adapter.script('GET', path, [() => _json({'errors': {}}, 401), () => _json([], 200)]);
    }

    final results = await Future.wait([
      client.dio.get('/lists'),
      client.dio.get('/games'),
      client.dio.get('/profiles'),
    ]);

    expect(results.map((r) => r.statusCode), everyElement(200));
    expect(refreshCalls, 1);
  });

  test('clears the session when refresh is not possible', () async {
    var cleared = false;
    client.onUnauthorized = () => cleared = true;
    client.performRefresh = () async => null; // e.g. refresh token expired/revoked
    adapter.script('GET', '/lists', [() => _json({'errors': {}}, 401)]);

    await expectLater(client.dio.get('/lists'), throwsA(isA<DioException>()));
    expect(cleared, isTrue);
  });

  test('does not attempt a refresh when /login itself 401s', () async {
    var refreshCalls = 0;
    client.performRefresh = () async {
      refreshCalls++;
      return 'fresh-jwt';
    };
    adapter.script('POST', '/login', [() => _json({'error': 'bad'}, 401)]);

    await expectLater(client.dio.post('/login'), throwsA(isA<DioException>()));
    expect(refreshCalls, 0);
  });
}
