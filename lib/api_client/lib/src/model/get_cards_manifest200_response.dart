//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/card_manifest_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_cards_manifest200_response.g.dart';

/// GetCardsManifest200Response
///
/// Properties:
/// * [cards] 
@BuiltValue()
abstract class GetCardsManifest200Response implements Built<GetCardsManifest200Response, GetCardsManifest200ResponseBuilder> {
  @BuiltValueField(wireName: r'cards')
  BuiltList<CardManifestEntry> get cards;

  GetCardsManifest200Response._();

  factory GetCardsManifest200Response([void updates(GetCardsManifest200ResponseBuilder b)]) = _$GetCardsManifest200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCardsManifest200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCardsManifest200Response> get serializer => _$GetCardsManifest200ResponseSerializer();
}

class _$GetCardsManifest200ResponseSerializer implements PrimitiveSerializer<GetCardsManifest200Response> {
  @override
  final Iterable<Type> types = const [GetCardsManifest200Response, _$GetCardsManifest200Response];

  @override
  final String wireName = r'GetCardsManifest200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCardsManifest200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cards';
    yield serializers.serialize(
      object.cards,
      specifiedType: const FullType(BuiltList, [FullType(CardManifestEntry)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetCardsManifest200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetCardsManifest200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cards':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CardManifestEntry)]),
          ) as BuiltList<CardManifestEntry>;
          result.cards.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetCardsManifest200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCardsManifest200ResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

