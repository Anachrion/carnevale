//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gang_text.g.dart';

/// GangText
///
/// Properties:
/// * [text] 
@BuiltValue()
abstract class GangText implements Built<GangText, GangTextBuilder> {
  @BuiltValueField(wireName: r'text')
  String get text;

  GangText._();

  factory GangText([void updates(GangTextBuilder b)]) = _$GangText;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GangTextBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GangText> get serializer => _$GangTextSerializer();
}

class _$GangTextSerializer implements PrimitiveSerializer<GangText> {
  @override
  final Iterable<Type> types = const [GangText, _$GangText];

  @override
  final String wireName = r'GangText';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GangText object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GangText object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GangTextBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GangText deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GangTextBuilder();
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

