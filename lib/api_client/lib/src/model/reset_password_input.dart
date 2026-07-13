//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/reset_password_input_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reset_password_input.g.dart';

/// ResetPasswordInput
///
/// Properties:
/// * [user] 
@BuiltValue()
abstract class ResetPasswordInput implements Built<ResetPasswordInput, ResetPasswordInputBuilder> {
  @BuiltValueField(wireName: r'user')
  ResetPasswordInputUser get user;

  ResetPasswordInput._();

  factory ResetPasswordInput([void updates(ResetPasswordInputBuilder b)]) = _$ResetPasswordInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResetPasswordInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResetPasswordInput> get serializer => _$ResetPasswordInputSerializer();
}

class _$ResetPasswordInputSerializer implements PrimitiveSerializer<ResetPasswordInput> {
  @override
  final Iterable<Type> types = const [ResetPasswordInput, _$ResetPasswordInput];

  @override
  final String wireName = r'ResetPasswordInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResetPasswordInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(ResetPasswordInputUser),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResetPasswordInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResetPasswordInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ResetPasswordInputUser),
          ) as ResetPasswordInputUser;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResetPasswordInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResetPasswordInputBuilder();
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

