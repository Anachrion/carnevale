//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'summon_model_request.g.dart';

/// SummonModelRequest
///
/// Properties:
/// * [cardReferenceId] - The Catalog::CardReference to summon (a profile's card).
@BuiltValue()
abstract class SummonModelRequest implements Built<SummonModelRequest, SummonModelRequestBuilder> {
  /// The Catalog::CardReference to summon (a profile's card).
  @BuiltValueField(wireName: r'card_reference_id')
  int get cardReferenceId;

  SummonModelRequest._();

  factory SummonModelRequest([void updates(SummonModelRequestBuilder b)]) = _$SummonModelRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SummonModelRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SummonModelRequest> get serializer => _$SummonModelRequestSerializer();
}

class _$SummonModelRequestSerializer implements PrimitiveSerializer<SummonModelRequest> {
  @override
  final Iterable<Type> types = const [SummonModelRequest, _$SummonModelRequest];

  @override
  final String wireName = r'SummonModelRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SummonModelRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'card_reference_id';
    yield serializers.serialize(
      object.cardReferenceId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SummonModelRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SummonModelRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'card_reference_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cardReferenceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SummonModelRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SummonModelRequestBuilder();
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

