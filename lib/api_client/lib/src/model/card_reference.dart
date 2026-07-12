//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'card_reference.g.dart';

/// CardReference
///
/// Properties:
/// * [id]
/// * [identifier]
/// * [name]
/// * [cardFront]
/// * [cardBack]
@BuiltValue()
abstract class CardReference
    implements Built<CardReference, CardReferenceBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'identifier')
  String get identifier;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'card_front')
  String? get cardFront;

  @BuiltValueField(wireName: r'card_back')
  String? get cardBack;

  CardReference._();

  factory CardReference([void updates(CardReferenceBuilder b)]) =
      _$CardReference;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CardReferenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CardReference> get serializer =>
      _$CardReferenceSerializer();
}

class _$CardReferenceSerializer implements PrimitiveSerializer<CardReference> {
  @override
  final Iterable<Type> types = const [CardReference, _$CardReference];

  @override
  final String wireName = r'CardReference';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CardReference object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(object.id, specifiedType: const FullType(int));
    yield r'identifier';
    yield serializers.serialize(
      object.identifier,
      specifiedType: const FullType(String),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cardFront != null) {
      yield r'card_front';
      yield serializers.serialize(
        object.cardFront,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cardBack != null) {
      yield r'card_back';
      yield serializers.serialize(
        object.cardBack,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CardReference object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CardReferenceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.id = valueDes;
          break;
        case r'identifier':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.identifier = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'card_front':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cardFront = valueDes;
          break;
        case r'card_back':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cardBack = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CardReference deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CardReferenceBuilder();
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
