//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'join_game_input.g.dart';

/// JoinGameInput
///
/// Properties:
/// * [joinCode] 
@BuiltValue()
abstract class JoinGameInput implements Built<JoinGameInput, JoinGameInputBuilder> {
  @BuiltValueField(wireName: r'join_code')
  String get joinCode;

  JoinGameInput._();

  factory JoinGameInput([void updates(JoinGameInputBuilder b)]) = _$JoinGameInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JoinGameInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JoinGameInput> get serializer => _$JoinGameInputSerializer();
}

class _$JoinGameInputSerializer implements PrimitiveSerializer<JoinGameInput> {
  @override
  final Iterable<Type> types = const [JoinGameInput, _$JoinGameInput];

  @override
  final String wireName = r'JoinGameInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JoinGameInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'join_code';
    yield serializers.serialize(
      object.joinCode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    JoinGameInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JoinGameInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'join_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.joinCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JoinGameInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JoinGameInputBuilder();
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

