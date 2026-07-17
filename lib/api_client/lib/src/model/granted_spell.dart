//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/spell_rule_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'granted_spell.g.dart';

/// GrantedSpell
///
/// Properties:
/// * [key] - Identifies this spell for PATCH .../spell_casts (UpdateSpellCastInput.spell_cast.key) — pass it back verbatim, don't try to construct it from `id`.
/// * [id] - The underlying Catalog::Spell id when this grant references a real catalog spell (e.g. Galilean Priest's Waves of Force); null for a character-unique spell that has no catalog row (e.g. The Drowned Nun's Dagonite Baptism).
/// * [discipline] - Null for a character-unique, discipline-less spell.
/// * [name] 
/// * [cost] - Will Points spent to attempt the spell. Null only if the unique spell's data is incomplete.
/// * [difficulty] - Magic Roll result needed to score an Ace. Null only if the unique spell's data is incomplete.
/// * [description] 
/// * [cantrip] 
/// * [consumesSlot] - Whether this grant counts against a pool's slot_count. Every grant today is additive (false).
/// * [resetsEachRound] - Same meaning as SpellPool.resets_each_round, for this grant's own cast tracking.
/// * [rule] - The card's special rule that explains this grant (e.g. Water Affinity, Major Arcana, Dagonite Baptism, Creative Creation).
/// * [cast] - Whether this spell has been marked cast this round (see PATCH .../spell_casts). Always false outside a live game.
@BuiltValue()
abstract class GrantedSpell implements Built<GrantedSpell, GrantedSpellBuilder> {
  /// Identifies this spell for PATCH .../spell_casts (UpdateSpellCastInput.spell_cast.key) — pass it back verbatim, don't try to construct it from `id`.
  @BuiltValueField(wireName: r'key')
  String get key;

  /// The underlying Catalog::Spell id when this grant references a real catalog spell (e.g. Galilean Priest's Waves of Force); null for a character-unique spell that has no catalog row (e.g. The Drowned Nun's Dagonite Baptism).
  @BuiltValueField(wireName: r'id')
  int? get id;

  /// Null for a character-unique, discipline-less spell.
  @BuiltValueField(wireName: r'discipline')
  GrantedSpellDisciplineEnum? get discipline;
  // enum disciplineEnum {  blood_rites,  divinity,  fateweaving,  runes_of_sovereignty,  wild_magic,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Will Points spent to attempt the spell. Null only if the unique spell's data is incomplete.
  @BuiltValueField(wireName: r'cost')
  int? get cost;

  /// Magic Roll result needed to score an Ace. Null only if the unique spell's data is incomplete.
  @BuiltValueField(wireName: r'difficulty')
  int? get difficulty;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'cantrip')
  bool get cantrip;

  /// Whether this grant counts against a pool's slot_count. Every grant today is additive (false).
  @BuiltValueField(wireName: r'consumes_slot')
  bool get consumesSlot;

  /// Same meaning as SpellPool.resets_each_round, for this grant's own cast tracking.
  @BuiltValueField(wireName: r'resets_each_round')
  bool get resetsEachRound;

  /// The card's special rule that explains this grant (e.g. Water Affinity, Major Arcana, Dagonite Baptism, Creative Creation).
  @BuiltValueField(wireName: r'rule')
  SpellRuleRef? get rule;

  /// Whether this spell has been marked cast this round (see PATCH .../spell_casts). Always false outside a live game.
  @BuiltValueField(wireName: r'cast')
  bool get cast;

  GrantedSpell._();

  factory GrantedSpell([void updates(GrantedSpellBuilder b)]) = _$GrantedSpell;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GrantedSpellBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GrantedSpell> get serializer => _$GrantedSpellSerializer();
}

class _$GrantedSpellSerializer implements PrimitiveSerializer<GrantedSpell> {
  @override
  final Iterable<Type> types = const [GrantedSpell, _$GrantedSpell];

  @override
  final String wireName = r'GrantedSpell';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GrantedSpell object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield object.id == null ? null : serializers.serialize(
      object.id,
      specifiedType: const FullType.nullable(int),
    );
    yield r'discipline';
    yield object.discipline == null ? null : serializers.serialize(
      object.discipline,
      specifiedType: const FullType.nullable(GrantedSpellDisciplineEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'cost';
    yield object.cost == null ? null : serializers.serialize(
      object.cost,
      specifiedType: const FullType.nullable(int),
    );
    yield r'difficulty';
    yield object.difficulty == null ? null : serializers.serialize(
      object.difficulty,
      specifiedType: const FullType.nullable(int),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'cantrip';
    yield serializers.serialize(
      object.cantrip,
      specifiedType: const FullType(bool),
    );
    yield r'consumes_slot';
    yield serializers.serialize(
      object.consumesSlot,
      specifiedType: const FullType(bool),
    );
    yield r'resets_each_round';
    yield serializers.serialize(
      object.resetsEachRound,
      specifiedType: const FullType(bool),
    );
    yield r'rule';
    yield object.rule == null ? null : serializers.serialize(
      object.rule,
      specifiedType: const FullType.nullable(SpellRuleRef),
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
    GrantedSpell object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GrantedSpellBuilder result,
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'discipline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GrantedSpellDisciplineEnum),
          ) as GrantedSpellDisciplineEnum?;
          if (valueDes == null) continue;
          result.discipline = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'cost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.cost = valueDes;
          break;
        case r'difficulty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.difficulty = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'cantrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cantrip = valueDes;
          break;
        case r'consumes_slot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.consumesSlot = valueDes;
          break;
        case r'resets_each_round':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.resetsEachRound = valueDes;
          break;
        case r'rule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SpellRuleRef),
          ) as SpellRuleRef?;
          if (valueDes == null) continue;
          result.rule.replace(valueDes);
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
  GrantedSpell deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GrantedSpellBuilder();
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

class GrantedSpellDisciplineEnum extends EnumClass {

  /// Null for a character-unique, discipline-less spell.
  @BuiltValueEnumConst(wireName: r'blood_rites')
  static const GrantedSpellDisciplineEnum bloodRites = _$grantedSpellDisciplineEnum_bloodRites;
  /// Null for a character-unique, discipline-less spell.
  @BuiltValueEnumConst(wireName: r'divinity')
  static const GrantedSpellDisciplineEnum divinity = _$grantedSpellDisciplineEnum_divinity;
  /// Null for a character-unique, discipline-less spell.
  @BuiltValueEnumConst(wireName: r'fateweaving')
  static const GrantedSpellDisciplineEnum fateweaving = _$grantedSpellDisciplineEnum_fateweaving;
  /// Null for a character-unique, discipline-less spell.
  @BuiltValueEnumConst(wireName: r'runes_of_sovereignty')
  static const GrantedSpellDisciplineEnum runesOfSovereignty = _$grantedSpellDisciplineEnum_runesOfSovereignty;
  /// Null for a character-unique, discipline-less spell.
  @BuiltValueEnumConst(wireName: r'wild_magic')
  static const GrantedSpellDisciplineEnum wildMagic = _$grantedSpellDisciplineEnum_wildMagic;

  static Serializer<GrantedSpellDisciplineEnum> get serializer => _$grantedSpellDisciplineEnumSerializer;

  const GrantedSpellDisciplineEnum._(String name): super(name);

  static BuiltSet<GrantedSpellDisciplineEnum> get values => _$grantedSpellDisciplineEnumValues;
  static GrantedSpellDisciplineEnum valueOf(String name) => _$grantedSpellDisciplineEnumValueOf(name);
}

