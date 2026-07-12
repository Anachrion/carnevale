//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'spell.g.dart';

/// Spell
///
/// Properties:
/// * [id]
/// * [name]
/// * [discipline]
/// * [cost] - Will Points spent to attempt the spell.
/// * [difficulty] - Magic Roll result needed to score an Ace.
/// * [cantrip] - Whether this is the Discipline's free Cantrip (always known, doesn't count against spell_slots).
/// * [description]
@BuiltValue()
abstract class Spell implements Built<Spell, SpellBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'discipline')
  SpellDisciplineEnum get discipline;
  // enum disciplineEnum {  blood_rites,  divinity,  fateweaving,  runes_of_sovereignty,  wild_magic,  };

  /// Will Points spent to attempt the spell.
  @BuiltValueField(wireName: r'cost')
  int get cost;

  /// Magic Roll result needed to score an Ace.
  @BuiltValueField(wireName: r'difficulty')
  int get difficulty;

  /// Whether this is the Discipline's free Cantrip (always known, doesn't count against spell_slots).
  @BuiltValueField(wireName: r'cantrip')
  bool get cantrip;

  @BuiltValueField(wireName: r'description')
  String get description;

  Spell._();

  factory Spell([void updates(SpellBuilder b)]) = _$Spell;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SpellBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Spell> get serializer => _$SpellSerializer();
}

class _$SpellSerializer implements PrimitiveSerializer<Spell> {
  @override
  final Iterable<Type> types = const [Spell, _$Spell];

  @override
  final String wireName = r'Spell';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Spell object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(object.id, specifiedType: const FullType(int));
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'discipline';
    yield serializers.serialize(
      object.discipline,
      specifiedType: const FullType(SpellDisciplineEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    Spell object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SpellBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'discipline':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(SpellDisciplineEnum),
                  )
                  as SpellDisciplineEnum;
          result.discipline = valueDes;
          break;
        case r'cost':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.cost = valueDes;
          break;
        case r'difficulty':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.difficulty = valueDes;
          break;
        case r'cantrip':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.cantrip = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Spell deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SpellBuilder();
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

class SpellDisciplineEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'blood_rites')
  static const SpellDisciplineEnum bloodRites =
      _$spellDisciplineEnum_bloodRites;
  @BuiltValueEnumConst(wireName: r'divinity')
  static const SpellDisciplineEnum divinity = _$spellDisciplineEnum_divinity;
  @BuiltValueEnumConst(wireName: r'fateweaving')
  static const SpellDisciplineEnum fateweaving =
      _$spellDisciplineEnum_fateweaving;
  @BuiltValueEnumConst(wireName: r'runes_of_sovereignty')
  static const SpellDisciplineEnum runesOfSovereignty =
      _$spellDisciplineEnum_runesOfSovereignty;
  @BuiltValueEnumConst(wireName: r'wild_magic')
  static const SpellDisciplineEnum wildMagic = _$spellDisciplineEnum_wildMagic;

  static Serializer<SpellDisciplineEnum> get serializer =>
      _$spellDisciplineEnumSerializer;

  const SpellDisciplineEnum._(String name) : super(name);

  static BuiltSet<SpellDisciplineEnum> get values =>
      _$spellDisciplineEnumValues;
  static SpellDisciplineEnum valueOf(String name) =>
      _$spellDisciplineEnumValueOf(name);
}
