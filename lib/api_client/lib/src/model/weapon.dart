//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'weapon.g.dart';

/// Weapon
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [damage] 
/// * [range] 
/// * [penetration] 
/// * [evasion] 
/// * [abilities] 
@BuiltValue()
abstract class Weapon implements Built<Weapon, WeaponBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'damage')
  int get damage;

  @BuiltValueField(wireName: r'range')
  int get range;

  @BuiltValueField(wireName: r'penetration')
  int get penetration;

  @BuiltValueField(wireName: r'evasion')
  int get evasion;

  @BuiltValueField(wireName: r'abilities')
  BuiltList<String> get abilities;

  Weapon._();

  factory Weapon([void updates(WeaponBuilder b)]) = _$Weapon;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WeaponBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Weapon> get serializer => _$WeaponSerializer();
}

class _$WeaponSerializer implements PrimitiveSerializer<Weapon> {
  @override
  final Iterable<Type> types = const [Weapon, _$Weapon];

  @override
  final String wireName = r'Weapon';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Weapon object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'damage';
    yield serializers.serialize(
      object.damage,
      specifiedType: const FullType(int),
    );
    yield r'range';
    yield serializers.serialize(
      object.range,
      specifiedType: const FullType(int),
    );
    yield r'penetration';
    yield serializers.serialize(
      object.penetration,
      specifiedType: const FullType(int),
    );
    yield r'evasion';
    yield serializers.serialize(
      object.evasion,
      specifiedType: const FullType(int),
    );
    yield r'abilities';
    yield serializers.serialize(
      object.abilities,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Weapon object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WeaponBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'damage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.damage = valueDes;
          break;
        case r'range':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.range = valueDes;
          break;
        case r'penetration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.penetration = valueDes;
          break;
        case r'evasion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.evasion = valueDes;
          break;
        case r'abilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.abilities.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Weapon deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WeaponBuilder();
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

