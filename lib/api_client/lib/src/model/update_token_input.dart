//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/token.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_token_input.g.dart';

/// UpdateTokenInput
///
/// Properties:
/// * [token] 
@BuiltValue()
abstract class UpdateTokenInput implements Built<UpdateTokenInput, UpdateTokenInputBuilder> {
  @BuiltValueField(wireName: r'token')
  Token get token;

  UpdateTokenInput._();

  factory UpdateTokenInput([void updates(UpdateTokenInputBuilder b)]) = _$UpdateTokenInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateTokenInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateTokenInput> get serializer => _$UpdateTokenInputSerializer();
}

class _$UpdateTokenInputSerializer implements PrimitiveSerializer<UpdateTokenInput> {
  @override
  final Iterable<Type> types = const [UpdateTokenInput, _$UpdateTokenInput];

  @override
  final String wireName = r'UpdateTokenInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateTokenInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(Token),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateTokenInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateTokenInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Token),
          ) as Token;
          result.token.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateTokenInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateTokenInputBuilder();
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

