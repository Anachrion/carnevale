//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_entry_spells_input_entry_pool_selections_inner.g.dart';

/// SetEntrySpellsInputEntryPoolSelectionsInner
///
/// Properties:
/// * [poolId] - Id of one of this model's pools (see ListEntry.pools[].id).
/// * [disciplines] - The discipline(s) committed for this pool — usually one, up to the pool's `of` count for a multi-discipline pool (Doctor of the Firmament). 
/// * [spellIds] - The exact set of known (non-Cantrip) spell ids for this pool.
@BuiltValue()
abstract class SetEntrySpellsInputEntryPoolSelectionsInner implements Built<SetEntrySpellsInputEntryPoolSelectionsInner, SetEntrySpellsInputEntryPoolSelectionsInnerBuilder> {
  /// Id of one of this model's pools (see ListEntry.pools[].id).
  @BuiltValueField(wireName: r'pool_id')
  int get poolId;

  /// The discipline(s) committed for this pool — usually one, up to the pool's `of` count for a multi-discipline pool (Doctor of the Firmament). 
  @BuiltValueField(wireName: r'disciplines')
  BuiltList<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>? get disciplines;
  // enum disciplinesEnum {  blood_rites,  divinity,  fateweaving,  runes_of_sovereignty,  wild_magic,  };

  /// The exact set of known (non-Cantrip) spell ids for this pool.
  @BuiltValueField(wireName: r'spell_ids')
  BuiltList<int>? get spellIds;

  SetEntrySpellsInputEntryPoolSelectionsInner._();

  factory SetEntrySpellsInputEntryPoolSelectionsInner([void updates(SetEntrySpellsInputEntryPoolSelectionsInnerBuilder b)]) = _$SetEntrySpellsInputEntryPoolSelectionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetEntrySpellsInputEntryPoolSelectionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetEntrySpellsInputEntryPoolSelectionsInner> get serializer => _$SetEntrySpellsInputEntryPoolSelectionsInnerSerializer();
}

class _$SetEntrySpellsInputEntryPoolSelectionsInnerSerializer implements PrimitiveSerializer<SetEntrySpellsInputEntryPoolSelectionsInner> {
  @override
  final Iterable<Type> types = const [SetEntrySpellsInputEntryPoolSelectionsInner, _$SetEntrySpellsInputEntryPoolSelectionsInner];

  @override
  final String wireName = r'SetEntrySpellsInputEntryPoolSelectionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetEntrySpellsInputEntryPoolSelectionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pool_id';
    yield serializers.serialize(
      object.poolId,
      specifiedType: const FullType(int),
    );
    if (object.disciplines != null) {
      yield r'disciplines';
      yield serializers.serialize(
        object.disciplines,
        specifiedType: const FullType(BuiltList, [FullType(SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum)]),
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
    SetEntrySpellsInputEntryPoolSelectionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetEntrySpellsInputEntryPoolSelectionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pool_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.poolId = valueDes;
          break;
        case r'disciplines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum)]),
          ) as BuiltList<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>;
          result.disciplines.replace(valueDes);
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
  SetEntrySpellsInputEntryPoolSelectionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetEntrySpellsInputEntryPoolSelectionsInnerBuilder();
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

class SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'blood_rites')
  static const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum bloodRites = _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_bloodRites;
  @BuiltValueEnumConst(wireName: r'divinity')
  static const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum divinity = _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_divinity;
  @BuiltValueEnumConst(wireName: r'fateweaving')
  static const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum fateweaving = _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_fateweaving;
  @BuiltValueEnumConst(wireName: r'runes_of_sovereignty')
  static const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum runesOfSovereignty = _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_runesOfSovereignty;
  @BuiltValueEnumConst(wireName: r'wild_magic')
  static const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum wildMagic = _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_wildMagic;

  static Serializer<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum> get serializer => _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnumSerializer;

  const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum._(String name): super(name);

  static BuiltSet<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum> get values => _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnumValues;
  static SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum valueOf(String name) => _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnumValueOf(name);
}

