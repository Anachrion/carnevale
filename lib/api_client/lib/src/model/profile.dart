//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/special_rule.dart';
import 'package:carnevale_api/src/model/card_reference.dart';
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/weapon.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile.g.dart';

/// Profile
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [faction] 
/// * [ducats] 
/// * [movement] 
/// * [attack] 
/// * [dexterity] 
/// * [lifePoints] 
/// * [mind] 
/// * [willPoints] 
/// * [protection] 
/// * [actionPoints] 
/// * [commandPoints] 
/// * [size] 
/// * [abilities] 
/// * [keywords]
/// * [flexibleLeader] - Whether this Leader demotes to a plain Hero alongside another Leader (The Duke, Prince of Thieves, Sopracomito, La Signora), and may therefore be added to a gang that already has a Leader.
/// * [version]
/// * [mage] - Whether the profile has at least one spell pool and can be given spells (rulebook p24).
/// * [spellSlots] - Summary total of non-Cantrip spells across every spell pool — informational only (the catalog browse view). 0 for non-Mages and for a profile whose only pool is `unlimited`. Real per-pool limits are enforced when hiring; see ListEntry.pools for the detail a gang builder needs. 
/// * [disciplines] - Union of every pool's eligible Discipline slugs, e.g. [\"blood_rites\", \"divinity\"] — informational only, same caveat as spell_slots. Empty for a mentor_derived pool (Apprentice Doctor), which has no static Discipline list of its own. 
/// * [weapons] 
/// * [specialRules] 
/// * [cardReferences] 
@BuiltValue()
abstract class Profile implements Built<Profile, ProfileBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'faction')
  String get faction;

  @BuiltValueField(wireName: r'ducats')
  int get ducats;

  @BuiltValueField(wireName: r'movement')
  int get movement;

  @BuiltValueField(wireName: r'attack')
  int get attack;

  @BuiltValueField(wireName: r'dexterity')
  int get dexterity;

  @BuiltValueField(wireName: r'life_points')
  int get lifePoints;

  @BuiltValueField(wireName: r'mind')
  int get mind;

  @BuiltValueField(wireName: r'will_points')
  int get willPoints;

  @BuiltValueField(wireName: r'protection')
  int get protection;

  @BuiltValueField(wireName: r'action_points')
  int get actionPoints;

  @BuiltValueField(wireName: r'command_points')
  int get commandPoints;

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'abilities')
  BuiltList<String> get abilities;

  @BuiltValueField(wireName: r'keywords')
  BuiltList<String> get keywords;

  /// Whether this Leader demotes to a plain Hero alongside another Leader (The Duke, Prince of Thieves, Sopracomito, La Signora), and may therefore be added to a gang that already has a Leader.
  @BuiltValueField(wireName: r'flexible_leader')
  bool get flexibleLeader;

  @BuiltValueField(wireName: r'version')
  String get version;

  /// Whether the profile has at least one spell pool and can be given spells (rulebook p24).
  @BuiltValueField(wireName: r'mage')
  bool get mage;

  /// Summary total of non-Cantrip spells across every spell pool — informational only (the catalog browse view). 0 for non-Mages and for a profile whose only pool is `unlimited`. Real per-pool limits are enforced when hiring; see ListEntry.pools for the detail a gang builder needs. 
  @BuiltValueField(wireName: r'spell_slots')
  int get spellSlots;

  /// Union of every pool's eligible Discipline slugs, e.g. [\"blood_rites\", \"divinity\"] — informational only, same caveat as spell_slots. Empty for a mentor_derived pool (Apprentice Doctor), which has no static Discipline list of its own. 
  @BuiltValueField(wireName: r'disciplines')
  BuiltList<String> get disciplines;

  @BuiltValueField(wireName: r'weapons')
  BuiltList<Weapon> get weapons;

  @BuiltValueField(wireName: r'special_rules')
  BuiltList<SpecialRule> get specialRules;

  @BuiltValueField(wireName: r'card_references')
  BuiltList<CardReference> get cardReferences;

  Profile._();

  factory Profile([void updates(ProfileBuilder b)]) = _$Profile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Profile> get serializer => _$ProfileSerializer();
}

class _$ProfileSerializer implements PrimitiveSerializer<Profile> {
  @override
  final Iterable<Type> types = const [Profile, _$Profile];

  @override
  final String wireName = r'Profile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Profile object, {
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
    yield r'faction';
    yield serializers.serialize(
      object.faction,
      specifiedType: const FullType(String),
    );
    yield r'ducats';
    yield serializers.serialize(
      object.ducats,
      specifiedType: const FullType(int),
    );
    yield r'movement';
    yield serializers.serialize(
      object.movement,
      specifiedType: const FullType(int),
    );
    yield r'attack';
    yield serializers.serialize(
      object.attack,
      specifiedType: const FullType(int),
    );
    yield r'dexterity';
    yield serializers.serialize(
      object.dexterity,
      specifiedType: const FullType(int),
    );
    yield r'life_points';
    yield serializers.serialize(
      object.lifePoints,
      specifiedType: const FullType(int),
    );
    yield r'mind';
    yield serializers.serialize(
      object.mind,
      specifiedType: const FullType(int),
    );
    yield r'will_points';
    yield serializers.serialize(
      object.willPoints,
      specifiedType: const FullType(int),
    );
    yield r'protection';
    yield serializers.serialize(
      object.protection,
      specifiedType: const FullType(int),
    );
    yield r'action_points';
    yield serializers.serialize(
      object.actionPoints,
      specifiedType: const FullType(int),
    );
    yield r'command_points';
    yield serializers.serialize(
      object.commandPoints,
      specifiedType: const FullType(int),
    );
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
    yield r'abilities';
    yield serializers.serialize(
      object.abilities,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'keywords';
    yield serializers.serialize(
      object.keywords,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'flexible_leader';
    yield serializers.serialize(
      object.flexibleLeader,
      specifiedType: const FullType(bool),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
    yield r'mage';
    yield serializers.serialize(
      object.mage,
      specifiedType: const FullType(bool),
    );
    yield r'spell_slots';
    yield serializers.serialize(
      object.spellSlots,
      specifiedType: const FullType(int),
    );
    yield r'disciplines';
    yield serializers.serialize(
      object.disciplines,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'weapons';
    yield serializers.serialize(
      object.weapons,
      specifiedType: const FullType(BuiltList, [FullType(Weapon)]),
    );
    yield r'special_rules';
    yield serializers.serialize(
      object.specialRules,
      specifiedType: const FullType(BuiltList, [FullType(SpecialRule)]),
    );
    yield r'card_references';
    yield serializers.serialize(
      object.cardReferences,
      specifiedType: const FullType(BuiltList, [FullType(CardReference)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Profile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProfileBuilder result,
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
        case r'faction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.faction = valueDes;
          break;
        case r'ducats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ducats = valueDes;
          break;
        case r'movement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.movement = valueDes;
          break;
        case r'attack':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attack = valueDes;
          break;
        case r'dexterity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dexterity = valueDes;
          break;
        case r'life_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lifePoints = valueDes;
          break;
        case r'mind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.mind = valueDes;
          break;
        case r'will_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.willPoints = valueDes;
          break;
        case r'protection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.protection = valueDes;
          break;
        case r'action_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.actionPoints = valueDes;
          break;
        case r'command_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commandPoints = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.size = valueDes;
          break;
        case r'abilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.abilities.replace(valueDes);
          break;
        case r'keywords':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.keywords.replace(valueDes);
          break;
        case r'flexible_leader':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.flexibleLeader = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        case r'mage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mage = valueDes;
          break;
        case r'spell_slots':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.spellSlots = valueDes;
          break;
        case r'disciplines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.disciplines.replace(valueDes);
          break;
        case r'weapons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Weapon)]),
          ) as BuiltList<Weapon>;
          result.weapons.replace(valueDes);
          break;
        case r'special_rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SpecialRule)]),
          ) as BuiltList<SpecialRule>;
          result.specialRules.replace(valueDes);
          break;
        case r'card_references':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CardReference)]),
          ) as BuiltList<CardReference>;
          result.cardReferences.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Profile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileBuilder();
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

