//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_entry_spells_input_entry.g.dart';

/// SetEntrySpellsInputEntry
///
/// Properties:
/// * [discipline] - The Discipline the model commits to; all known spells must belong to it. Null clears the selection.
/// * [spellIds] - The exact set of known spell ids. Replaces any previous selection.
@BuiltValue()
abstract class SetEntrySpellsInputEntry implements Built<SetEntrySpellsInputEntry, SetEntrySpellsInputEntryBuilder> {
  /// The Discipline the model commits to; all known spells must belong to it. Null clears the selection.
  @BuiltValueField(wireName: r'discipline')
  SetEntrySpellsInputEntryDisciplineEnum? get discipline;
  // enum disciplineEnum {  blood_rites,  divinity,  fateweaving,  runes_of_sovereignty,  wild_magic,  };

  /// The exact set of known spell ids. Replaces any previous selection.
  @BuiltValueField(wireName: r'spell_ids')
  BuiltList<int>? get spellIds;

  SetEntrySpellsInputEntry._();

  factory SetEntrySpellsInputEntry([void updates(SetEntrySpellsInputEntryBuilder b)]) = _$SetEntrySpellsInputEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetEntrySpellsInputEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetEntrySpellsInputEntry> get serializer => _$SetEntrySpellsInputEntrySerializer();
}

class _$SetEntrySpellsInputEntrySerializer implements PrimitiveSerializer<SetEntrySpellsInputEntry> {
  @override
  final Iterable<Type> types = const [SetEntrySpellsInputEntry, _$SetEntrySpellsInputEntry];

  @override
  final String wireName = r'SetEntrySpellsInputEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetEntrySpellsInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.discipline != null) {
      yield r'discipline';
      yield serializers.serialize(
        object.discipline,
        specifiedType: const FullType.nullable(SetEntrySpellsInputEntryDisciplineEnum),
      );
    }
    if (object.spellIds != null) {
      yield r'spell_ids';
      yield serializers.serialize(
        object.spellIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SetEntrySpellsInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetEntrySpellsInputEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'discipline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SetEntrySpellsInputEntryDisciplineEnum),
          ) as SetEntrySpellsInputEntryDisciplineEnum?;
          if (valueDes == null) continue;
          result.discipline = valueDes;
          break;
        case r'spell_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.spellIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetEntrySpellsInputEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetEntrySpellsInputEntryBuilder();
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

class SetEntrySpellsInputEntryDisciplineEnum extends EnumClass {

  /// The Discipline the model commits to; all known spells must belong to it. Null clears the selection.
  @BuiltValueEnumConst(wireName: r'blood_rites')
  static const SetEntrySpellsInputEntryDisciplineEnum bloodRites = _$setEntrySpellsInputEntryDisciplineEnum_bloodRites;
  /// The Discipline the model commits to; all known spells must belong to it. Null clears the selection.
  @BuiltValueEnumConst(wireName: r'divinity')
  static const SetEntrySpellsInputEntryDisciplineEnum divinity = _$setEntrySpellsInputEntryDisciplineEnum_divinity;
  /// The Discipline the model commits to; all known spells must belong to it. Null clears the selection.
  @BuiltValueEnumConst(wireName: r'fateweaving')
  static const SetEntrySpellsInputEntryDisciplineEnum fateweaving = _$setEntrySpellsInputEntryDisciplineEnum_fateweaving;
  /// The Discipline the model commits to; all known spells must belong to it. Null clears the selection.
  @BuiltValueEnumConst(wireName: r'runes_of_sovereignty')
  static const SetEntrySpellsInputEntryDisciplineEnum runesOfSovereignty = _$setEntrySpellsInputEntryDisciplineEnum_runesOfSovereignty;
  /// The Discipline the model commits to; all known spells must belong to it. Null clears the selection.
  @BuiltValueEnumConst(wireName: r'wild_magic')
  static const SetEntrySpellsInputEntryDisciplineEnum wildMagic = _$setEntrySpellsInputEntryDisciplineEnum_wildMagic;

  static Serializer<SetEntrySpellsInputEntryDisciplineEnum> get serializer => _$setEntrySpellsInputEntryDisciplineEnumSerializer;

  const SetEntrySpellsInputEntryDisciplineEnum._(String name): super(name);

  static BuiltSet<SetEntrySpellsInputEntryDisciplineEnum> get values => _$setEntrySpellsInputEntryDisciplineEnumValues;
  static SetEntrySpellsInputEntryDisciplineEnum valueOf(String name) => _$setEntrySpellsInputEntryDisciplineEnumValueOf(name);
}

