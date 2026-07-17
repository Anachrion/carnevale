//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/update_spell_cast_input_spell_cast.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_spell_cast_input.g.dart';

/// UpdateSpellCastInput
///
/// Properties:
/// * [spellCast] 
@BuiltValue()
abstract class UpdateSpellCastInput implements Built<UpdateSpellCastInput, UpdateSpellCastInputBuilder> {
  @BuiltValueField(wireName: r'spell_cast')
  UpdateSpellCastInputSpellCast get spellCast;

  UpdateSpellCastInput._();

  factory UpdateSpellCastInput([void updates(UpdateSpellCastInputBuilder b)]) = _$UpdateSpellCastInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateSpellCastInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateSpellCastInput> get serializer => _$UpdateSpellCastInputSerializer();
}

class _$UpdateSpellCastInputSerializer implements PrimitiveSerializer<UpdateSpellCastInput> {
  @override
  final Iterable<Type> types = const [UpdateSpellCastInput, _$UpdateSpellCastInput];

  @override
  final String wireName = r'UpdateSpellCastInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateSpellCastInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'spell_cast';
    yield serializers.serialize(
      object.spellCast,
      specifiedType: const FullType(UpdateSpellCastInputSpellCast),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateSpellCastInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateSpellCastInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'spell_cast':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateSpellCastInputSpellCast),
          ) as UpdateSpellCastInputSpellCast;
          result.spellCast.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateSpellCastInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateSpellCastInputBuilder();
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

