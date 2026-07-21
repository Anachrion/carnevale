import 'dart:convert';
import 'dart:typed_data';

import 'package:carnevale/screens/gang_builder_screen.dart';
import 'package:carnevale/services/api_client.dart';
import 'package:built_value/serializer.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// Reproduces CARNEVALEB-36 (review B-5): a hire that commits server-side but loses its response on
/// a flaky network. The builder's optimistic sync queue can't tell "never arrived" from "arrived,
/// response lost" — both surface as a DioException with no HTTP status — so it re-sends the op.
///
/// This adapter is a faithful little server: it appends one entry per *distinct* Idempotency-Key and
/// replays the current list for a key it has already applied, and it drops the response of the first
/// POST (after committing it). Before the fix, the client minted a new key per attempt, so the retry
/// looked like a fresh hire and the model was hired twice; with the fix the op reuses its key, so the
/// server replays and the gang holds exactly one.
class _FlakyServerAdapter implements HttpClientAdapter {
  _FlakyServerAdapter(this._buildList);

  final Map<String, Object?> _canned = {};

  /// Builds the ModelList body the "server" returns, given how many Bravoes it currently holds.
  final api.ModelList Function(int bravoesCommitted) _buildList;

  final List<String?> seenKeys = [];
  final Set<String> _appliedKeys = {};
  int bravoesCommitted = 0;
  bool _firstResponseDropped = false;

  void stub(String method, String path, Object? body) =>
      _canned['$method $path'] = body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.method == 'POST' && options.path == '/list_entries') {
      final key = options.headers['Idempotency-Key'] as String?;
      seenKeys.add(key);

      final alreadyApplied = key != null && _appliedKeys.contains(key);
      if (!alreadyApplied) {
        // The server commits the hire...
        if (key != null) _appliedKeys.add(key);
        bravoesCommitted += 1;
        if (!_firstResponseDropped) {
          // ...but the client never receives the response (connection dropped post-commit).
          _firstResponseDropped = true;
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'response dropped after commit',
          );
        }
      }
      return _ok(modelListBody(_buildList(bravoesCommitted)));
    }

    final body = _canned['${options.method} ${options.path}'];
    return _ok(
      body ??
          {
            'errors': {
              'base': ['not stubbed: ${options.method} ${options.path}'],
            },
          },
      status: body == null ? 404 : 200,
    );
  }

  ResponseBody _ok(Object? body, {int status = 200}) => ResponseBody.fromString(
    json.encode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  testWidgets(
    'a hire whose response is lost is retried with the same key and not duplicated',
    (tester) async {
      // The server's list: the starter Capodecina plus however many Bravoes have been committed.
      api.ModelList serverList(int bravoes) => fakeModelList(
        name: 'The Rooks',
        entries: [
          fakeListEntry(id: 1, position: 1, name: 'Capodecina', entryId: 10),
          for (var i = 0; i < bravoes; i++)
            fakeListEntry(
              id: 100 + i,
              position: 2 + i,
              name: 'Bravoes',
              entryId: 99,
              keywords: const ['Henchman'],
            ),
        ],
      );

      SharedPreferences.setMockInitialValues({});
      final adapter = _FlakyServerAdapter(serverList);
      ApiClient().dio.httpClientAdapter = adapter;

      adapter.stub(
        'GET',
        '/profiles',
        listBody<api.Profile>([
          fakeProfile(
            id: 1,
            name: 'Bravoes',
            faction: 'guild',
            keywords: const ['Henchman'],
            cardReferences: [fakeCardReference(id: 99, profileName: 'Bravoes')],
          ),
        ], const FullType(api.Profile)),
      );
      adapter.stub(
        'GET',
        '/equipment',
        listBody<api.Equipment>([], const FullType(api.Equipment)),
      );
      adapter.stub(
        'GET',
        '/spells',
        listBody<api.Spell>([], const FullType(api.Spell)),
      );

      await tester.pumpWidget(
        localizedApp(home: GangBuilderScreen(gang: serverList(0))),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.text('Hire'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Hire the Bravoes: optimistic add fires the first POST, whose response the server drops.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // The queue backs off 2s on a network blip, then retries the same op.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // The server committed the hire exactly once — the retry replayed instead of hiring again.
      expect(adapter.bravoesCommitted, 1);
      // Two physical POSTs, carrying the *same* non-null key — the reuse is what makes the replay work.
      expect(adapter.seenKeys.length, 2);
      expect(adapter.seenKeys.first, isNotNull);
      expect(adapter.seenKeys[0], adapter.seenKeys[1]);
      // And the gang shows a single copy, not two.
      expect(find.text('×1'), findsOneWidget);
      expect(find.text('×2'), findsNothing);
    },
  );
}
