//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pool_spell.g.dart';

/// PoolSpell
///
/// Properties:
/// * [key] - Identifies this spell for PATCH .../spell_casts (UpdateSpellCastInput.spell_cast.key) — pass it back verbatim, don't try to construct it from `id`.
/// * [id] 
/// * [name] 
/// * [discipline] 
/// * [cost] - Will Points spent to attempt the spell.
/// * [difficulty] - Magic Roll result needed to score an Ace.
/// * [cantrip] - Whether this is the Discipline's free Cantrip (always known, not counted against the pool's slot_count).
/// * [description] 
/// * [cast] - Whether this spell has been marked cast this round (see PATCH .../spell_casts). Always false outside a live game.
@BuiltValue()
abstract class PoolSpell implements Built<PoolSpell, PoolSpellBuilder> {
  /// Identifies this spell for PATCH .../spell_casts (UpdateSpellCastInput.spell_cast.key) — pass it back verbatim, don't try to construct it from `id`.
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'discipline')
  PoolSpellDisciplineEnum get discipline;
  // enum disciplineEnum {  blood_rites,  divinity,  fateweaving,  runes_of_sovereignty,  wild_magic,  };

  /// Will Points spent to attempt the spell.
  @BuiltValueField(wireName: r'cost')
  int get cost;

  /// Magic Roll result needed to score an Ace.
  @BuiltValueField(wireName: r'difficulty')
  int get difficulty;

  /// Whether this is the Discipline's free Cantrip (always known, not counted against the pool's slot_count).
  @BuiltValueField(wireName: r'cantrip')
  bool get cantrip;

  @BuiltValueField(wireName: r'description')
  String get description;

  /// Whether this spell has been marked cast this round (see PATCH .../spell_casts). Always false outside a live game.
  @BuiltValueField(wireName: r'cast')
  bool get cast;

  PoolSpell._();

  factory PoolSpell([void updates(PoolSpellBuilder b)]) = _$PoolSpell;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PoolSpellBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PoolSpell> get serializer => _$PoolSpellSerializer();
}

class _$PoolSpellSerializer implements PrimitiveSerializer<PoolSpell> {
  @override
  final Iterable<Type> types = const [PoolSpell, _$PoolSpell];

  @override
  final String wireName = r'PoolSpell';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PoolSpell object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
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
    yield r'discipline';
    yield serializers.serialize(
      object.discipline,
      specifiedType: const FullType(PoolSpellDisciplineEnum),
    );
    yield r'cost';
    yield serializers.serialize(
      object.cost,
      specifiedType: const FullType(int),
    );
    yield r'difficulty';
    yield serializers.serialize(
      object.difficulty,
      specifiedType: const FullType(int),
    );
    yield r'cantrip';
    yield serializers.serialize(
      object.cantrip,
      specifiedType: const FullType(bool),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
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
    PoolSpell object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PoolSpellBuilder result,
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
        case r'discipline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PoolSpellDisciplineEnum),
          ) as PoolSpellDisciplineEnum;
          result.discipline = valueDes;
          break;
        case r'cost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cost = valueDes;
          break;
        case r'difficulty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.difficulty = valueDes;
          break;
        case r'cantrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cantrip = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
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
  PoolSpell deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PoolSpellBuilder();
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

class PoolSpellDisciplineEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'blood_rites')
  static const PoolSpellDisciplineEnum bloodRites = _$poolSpellDisciplineEnum_bloodRites;
  @BuiltValueEnumConst(wireName: r'divinity')
  static const PoolSpellDisciplineEnum divinity = _$poolSpellDisciplineEnum_divinity;
  @BuiltValueEnumConst(wireName: r'fateweaving')
  static const PoolSpellDisciplineEnum fateweaving = _$poolSpellDisciplineEnum_fateweaving;
  @BuiltValueEnumConst(wireName: r'runes_of_sovereignty')
  static const PoolSpellDisciplineEnum runesOfSovereignty = _$poolSpellDisciplineEnum_runesOfSovereignty;
  @BuiltValueEnumConst(wireName: r'wild_magic')
  static const PoolSpellDisciplineEnum wildMagic = _$poolSpellDisciplineEnum_wildMagic;

  static Serializer<PoolSpellDisciplineEnum> get serializer => _$poolSpellDisciplineEnumSerializer;

  const PoolSpellDisciplineEnum._(String name): super(name);

  static BuiltSet<PoolSpellDisciplineEnum> get values => _$poolSpellDisciplineEnumValues;
  static PoolSpellDisciplineEnum valueOf(String name) => _$poolSpellDisciplineEnumValueOf(name);
}

