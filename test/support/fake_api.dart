import 'dart:convert';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:carnevale/services/api_client.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';

/// A Dio adapter that returns canned JSON per `METHOD /path`, so widget/service tests can drive the
/// real service -> generated-client -> model-mapping stack without a backend. Installed on the
/// shared ApiClient's Dio via [installFakeApi].
class FakeApiAdapter implements HttpClientAdapter {
  final Map<String, Object?> _routes = {};

  /// Registers a response body (a JSON-encodable Map/List) for a request. Build [body] with the
  /// generated serializers (see the fixtures below) so it matches the client's expected schema.
  void stub(String method, String path, Object? body) {
    _routes['$method $path'] = body;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final key = '${options.method} ${options.path}';
    final has = _routes.containsKey(key);
    final body = has ? _routes[key] : {'errors': {'base': ['not stubbed: $key']}};
    return ResponseBody.fromString(
      json.encode(body),
      has ? 200 : 404,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Installs a fresh [FakeApiAdapter] on the shared ApiClient and returns it for stubbing.
FakeApiAdapter installFakeApi() {
  final adapter = FakeApiAdapter();
  ApiClient().dio.httpClientAdapter = adapter;
  return adapter;
}

/// Serializes generated built_value objects to the primitive Map/List the adapter re-encodes,
/// guaranteeing the canned body matches the client's deserializer.
Object _serialize(Object value, FullType type) =>
    api.standardSerializers.serialize(value, specifiedType: type)!;

Object listBody<T>(Iterable<T> items, FullType itemType) =>
    _serialize(BuiltList<T>(items), FullType(BuiltList, [itemType]));

// ── Fixtures ────────────────────────────────────────────────────────────────

api.Profile fakeProfile({
  int id = 1,
  String name = 'Capodecina',
  String faction = 'guild',
  int ducats = 20,
  List<String> keywords = const ['Leader'],
  List<api.CardReference> cardReferences = const [],
}) => api.Profile(
  (b) => b
    ..id = id
    ..name = name
    ..faction = faction
    ..ducats = ducats
    ..movement = 4
    ..attack = 3
    ..dexterity = 3
    ..lifePoints = 2
    ..mind = 3
    ..willPoints = 2
    ..protection = 5
    ..actionPoints = 2
    ..commandPoints = 1
    ..size = 2
    ..version = 'v1'
    ..mage = false
    ..spellSlots = 0
    ..abilities = ListBuilder<String>()
    ..keywords = ListBuilder<String>(keywords)
    ..disciplines = ListBuilder<String>()
    ..weapons = ListBuilder<api.Weapon>()
    ..specialRules = ListBuilder<api.SpecialRule>()
    ..cardReferences = ListBuilder<api.CardReference>(
      cardReferences.isEmpty
          ? [fakeCardReference(profileName: name)]
          : cardReferences,
    ),
);

api.CardReference fakeCardReference({
  int id = 10,
  String identifier = 'guild-capodecina',
  String profileName = 'Capodecina',
}) => api.CardReference(
  (b) => b
    ..id = id
    ..identifier = identifier
    ..name = profileName
    ..cardFront = 'front.png'
    ..cardBack = 'back.png',
);
