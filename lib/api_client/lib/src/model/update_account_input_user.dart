//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_account_input_user.g.dart';

/// UpdateAccountInputUser
///
/// Properties:
/// * [username]
@BuiltValue()
abstract class UpdateAccountInputUser
    implements Built<UpdateAccountInputUser, UpdateAccountInputUserBuilder> {
  @BuiltValueField(wireName: r'username')
  String get username;

  UpdateAccountInputUser._();

  factory UpdateAccountInputUser([
    void updates(UpdateAccountInputUserBuilder b),
  ]) = _$UpdateAccountInputUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateAccountInputUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateAccountInputUser> get serializer =>
      _$UpdateAccountInputUserSerializer();
}

class _$UpdateAccountInputUserSerializer
    implements PrimitiveSerializer<UpdateAccountInputUser> {
  @override
  final Iterable<Type> types = const [
    UpdateAccountInputUser,
    _$UpdateAccountInputUser,
  ];

  @override
  final String wireName = r'UpdateAccountInputUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateAccountInputUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateAccountInputUser object, {
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
    required UpdateAccountInputUserBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'username':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.username = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateAccountInputUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateAccountInputUserBuilder();
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
