//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_spell_cast_input_spell_cast.g.dart';

/// UpdateSpellCastInputSpellCast
///
/// Properties:
/// * [key] - Identifies the spell within this model — copy it verbatim from the `key` field of the PoolSpell/GrantedSpell being marked (see ListEntry.pools[].spells[]/cantrips[] and ListEntry.granted_spells[]). Opaque; don't try to construct it client-side. 
/// * [cast] - The desired state (true = mark cast, false = clear it) rather than a toggle.
@BuiltValue()
abstract class UpdateSpellCastInputSpellCast implements Built<UpdateSpellCastInputSpellCast, UpdateSpellCastInputSpellCastBuilder> {
  /// Identifies the spell within this model — copy it verbatim from the `key` field of the PoolSpell/GrantedSpell being marked (see ListEntry.pools[].spells[]/cantrips[] and ListEntry.granted_spells[]). Opaque; don't try to construct it client-side. 
  @BuiltValueField(wireName: r'key')
  String get key;

  /// The desired state (true = mark cast, false = clear it) rather than a toggle.
  @BuiltValueField(wireName: r'cast')
  bool get cast;

  UpdateSpellCastInputSpellCast._();

  factory UpdateSpellCastInputSpellCast([void updates(UpdateSpellCastInputSpellCastBuilder b)]) = _$UpdateSpellCastInputSpellCast;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateSpellCastInputSpellCastBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateSpellCastInputSpellCast> get serializer => _$UpdateSpellCastInputSpellCastSerializer();
}

class _$UpdateSpellCastInputSpellCastSerializer implements PrimitiveSerializer<UpdateSpellCastInputSpellCast> {
  @override
  final Iterable<Type> types = const [UpdateSpellCastInputSpellCast, _$UpdateSpellCastInputSpellCast];

  @override
  final String wireName = r'UpdateSpellCastInputSpellCast';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateSpellCastInputSpellCast object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'cast';
    yield serializers.serialize(
      object.cast,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateSpellCastInputSpellCast object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateSpellCastInputSpellCastBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'cast':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cast = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateSpellCastInputSpellCast deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateSpellCastInputSpellCastBuilder();
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

