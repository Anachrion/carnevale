//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reset_password_input_user.g.dart';

/// ResetPasswordInputUser
///
/// Properties:
/// * [resetPasswordToken] 
/// * [password] 
/// * [passwordConfirmation] 
@BuiltValue()
abstract class ResetPasswordInputUser implements Built<ResetPasswordInputUser, ResetPasswordInputUserBuilder> {
  @BuiltValueField(wireName: r'reset_password_token')
  String get resetPasswordToken;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'password_confirmation')
  String get passwordConfirmation;

  ResetPasswordInputUser._();

  factory ResetPasswordInputUser([void updates(ResetPasswordInputUserBuilder b)]) = _$ResetPasswordInputUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResetPasswordInputUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResetPasswordInputUser> get serializer => _$ResetPasswordInputUserSerializer();
}

class _$ResetPasswordInputUserSerializer implements PrimitiveSerializer<ResetPasswordInputUser> {
  @override
  final Iterable<Type> types = const [ResetPasswordInputUser, _$ResetPasswordInputUser];

  @override
  final String wireName = r'ResetPasswordInputUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResetPasswordInputUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reset_password_token';
    yield serializers.serialize(
      object.resetPasswordToken,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'password_confirmation';
    yield serializers.serialize(
      object.passwordConfirmation,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResetPasswordInputUser object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResetPasswordInputUserBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reset_password_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resetPasswordToken = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'password_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passwordConfirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResetPasswordInputUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResetPasswordInputUserBuilder();
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

