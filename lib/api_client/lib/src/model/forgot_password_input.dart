//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/forgot_password_input_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'forgot_password_input.g.dart';

/// ForgotPasswordInput
///
/// Properties:
/// * [user]
@BuiltValue()
abstract class ForgotPasswordInput
    implements Built<ForgotPasswordInput, ForgotPasswordInputBuilder> {
  @BuiltValueField(wireName: r'user')
  ForgotPasswordInputUser get user;

  ForgotPasswordInput._();

  factory ForgotPasswordInput([void updates(ForgotPasswordInputBuilder b)]) =
      _$ForgotPasswordInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ForgotPasswordInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ForgotPasswordInput> get serializer =>
      _$ForgotPasswordInputSerializer();
}

class _$ForgotPasswordInputSerializer
    implements PrimitiveSerializer<ForgotPasswordInput> {
  @override
  final Iterable<Type> types = const [
    ForgotPasswordInput,
    _$ForgotPasswordInput,
  ];

  @override
  final String wireName = r'ForgotPasswordInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ForgotPasswordInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(ForgotPasswordInputUser),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ForgotPasswordInput object, {
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
    required ForgotPasswordInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(ForgotPasswordInputUser),
                  )
                  as ForgotPasswordInputUser;
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
  ForgotPasswordInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ForgotPasswordInputBuilder();
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
