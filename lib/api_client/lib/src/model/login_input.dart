//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/login_input_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_input.g.dart';

/// LoginInput
///
/// Properties:
/// * [user] 
@BuiltValue()
abstract class LoginInput implements Built<LoginInput, LoginInputBuilder> {
  @BuiltValueField(wireName: r'user')
  LoginInputUser get user;

  LoginInput._();

  factory LoginInput([void updates(LoginInputBuilder b)]) = _$LoginInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginInput> get serializer => _$LoginInputSerializer();
}

class _$LoginInputSerializer implements PrimitiveSerializer<LoginInput> {
  @override
  final Iterable<Type> types = const [LoginInput, _$LoginInput];

  @override
  final String wireName = r'LoginInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(LoginInputUser),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoginInputUser),
          ) as LoginInputUser;
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
  LoginInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginInputBuilder();
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

