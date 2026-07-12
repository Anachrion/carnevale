//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'forgot_password_input_user.g.dart';

/// ForgotPasswordInputUser
///
/// Properties:
/// * [email]
@BuiltValue()
abstract class ForgotPasswordInputUser
    implements Built<ForgotPasswordInputUser, ForgotPasswordInputUserBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  ForgotPasswordInputUser._();

  factory ForgotPasswordInputUser([
    void updates(ForgotPasswordInputUserBuilder b),
  ]) = _$ForgotPasswordInputUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ForgotPasswordInputUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ForgotPasswordInputUser> get serializer =>
      _$ForgotPasswordInputUserSerializer();
}

class _$ForgotPasswordInputUserSerializer
    implements PrimitiveSerializer<ForgotPasswordInputUser> {
  @override
  final Iterable<Type> types = const [
    ForgotPasswordInputUser,
    _$ForgotPasswordInputUser,
  ];

  @override
  final String wireName = r'ForgotPasswordInputUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ForgotPasswordInputUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ForgotPasswordInputUser object, {
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
    required ForgotPasswordInputUserBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ForgotPasswordInputUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ForgotPasswordInputUserBuilder();
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
