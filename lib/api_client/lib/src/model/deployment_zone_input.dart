//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'deployment_zone_input.g.dart';

/// DeploymentZoneInput
///
/// Properties:
/// * [zone] 
@BuiltValue()
abstract class DeploymentZoneInput implements Built<DeploymentZoneInput, DeploymentZoneInputBuilder> {
  @BuiltValueField(wireName: r'zone')
  DeploymentZoneInputZoneEnum get zone;
  // enum zoneEnum {  A,  B,  };

  DeploymentZoneInput._();

  factory DeploymentZoneInput([void updates(DeploymentZoneInputBuilder b)]) = _$DeploymentZoneInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeploymentZoneInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeploymentZoneInput> get serializer => _$DeploymentZoneInputSerializer();
}

class _$DeploymentZoneInputSerializer implements PrimitiveSerializer<DeploymentZoneInput> {
  @override
  final Iterable<Type> types = const [DeploymentZoneInput, _$DeploymentZoneInput];

  @override
  final String wireName = r'DeploymentZoneInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeploymentZoneInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'zone';
    yield serializers.serialize(
      object.zone,
      specifiedType: const FullType(DeploymentZoneInputZoneEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeploymentZoneInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeploymentZoneInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'zone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeploymentZoneInputZoneEnum),
          ) as DeploymentZoneInputZoneEnum;
          result.zone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeploymentZoneInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeploymentZoneInputBuilder();
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

class DeploymentZoneInputZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'A')
  static const DeploymentZoneInputZoneEnum A = _$deploymentZoneInputZoneEnum_A;
  @BuiltValueEnumConst(wireName: r'B')
  static const DeploymentZoneInputZoneEnum B = _$deploymentZoneInputZoneEnum_B;

  static Serializer<DeploymentZoneInputZoneEnum> get serializer => _$deploymentZoneInputZoneEnumSerializer;

  const DeploymentZoneInputZoneEnum._(String name): super(name);

  static BuiltSet<DeploymentZoneInputZoneEnum> get values => _$deploymentZoneInputZoneEnumValues;
  static DeploymentZoneInputZoneEnum valueOf(String name) => _$deploymentZoneInputZoneEnumValueOf(name);
}

