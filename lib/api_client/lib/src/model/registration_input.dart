//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/registration_input_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'registration_input.g.dart';

/// RegistrationInput
///
/// Properties:
/// * [user] 
@BuiltValue()
abstract class RegistrationInput implements Built<RegistrationInput, RegistrationInputBuilder> {
  @BuiltValueField(wireName: r'user')
  RegistrationInputUser get user;

  RegistrationInput._();

  factory RegistrationInput([void updates(RegistrationInputBuilder b)]) = _$RegistrationInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegistrationInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegistrationInput> get serializer => _$RegistrationInputSerializer();
}

class _$RegistrationInputSerializer implements PrimitiveSerializer<RegistrationInput> {
  @override
  final Iterable<Type> types = const [RegistrationInput, _$RegistrationInput];

  @override
  final String wireName = r'RegistrationInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegistrationInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(RegistrationInputUser),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegistrationInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegistrationInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegistrationInputUser),
          ) as RegistrationInputUser;
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
  RegistrationInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegistrationInputBuilder();
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

