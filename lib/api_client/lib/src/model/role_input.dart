//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_input.g.dart';

/// RoleInput
///
/// Properties:
/// * [role] 
@BuiltValue()
abstract class RoleInput implements Built<RoleInput, RoleInputBuilder> {
  @BuiltValueField(wireName: r'role')
  RoleInputRoleEnum get role;
  // enum roleEnum {  attacker,  defender,  };

  RoleInput._();

  factory RoleInput([void updates(RoleInputBuilder b)]) = _$RoleInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoleInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoleInput> get serializer => _$RoleInputSerializer();
}

class _$RoleInputSerializer implements PrimitiveSerializer<RoleInput> {
  @override
  final Iterable<Type> types = const [RoleInput, _$RoleInput];

  @override
  final String wireName = r'RoleInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoleInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(RoleInputRoleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoleInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RoleInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RoleInputRoleEnum),
          ) as RoleInputRoleEnum;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoleInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoleInputBuilder();
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

class RoleInputRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'attacker')
  static const RoleInputRoleEnum attacker = _$roleInputRoleEnum_attacker;
  @BuiltValueEnumConst(wireName: r'defender')
  static const RoleInputRoleEnum defender = _$roleInputRoleEnum_defender;

  static Serializer<RoleInputRoleEnum> get serializer => _$roleInputRoleEnumSerializer;

  const RoleInputRoleEnum._(String name): super(name);

  static BuiltSet<RoleInputRoleEnum> get values => _$roleInputRoleEnumValues;
  static RoleInputRoleEnum valueOf(String name) => _$roleInputRoleEnumValueOf(name);
}

