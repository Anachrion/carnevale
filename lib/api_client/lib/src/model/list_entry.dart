//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/entry_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/spell.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_entry.g.dart';

/// ListEntry
///
/// Properties:
/// * [id] 
/// * [position] 
/// * [entryType] 
/// * [entryId] 
/// * [name] 
/// * [profileName] - The underlying profile's name without the card-reference letter suffix (e.g. \"Beggar\" rather than \"Beggar (A)\"). Use this to label a hired model and number duplicates client-side. Null for Equipment entries. 
/// * [identifier] - Slug of the card reference this model is hired as — the same identifier the cards manifest keys downloaded images by. A profile can have several card references, each with a different illustration; this is the one currently chosen. Null for Equipment entries, which have no card. Change it via PATCH /list_entries/{id}/illustration. 
/// * [cardFront] - Front face filename of the chosen card reference (served from /cards). Null for Equipment.
/// * [cardBack] - Back face filename of the chosen card reference (served from /cards). Null for Equipment.
/// * [cost] 
/// * [summoned] - Conjured onto the board mid-game by a special rule, rather than hired during gang building. A summoned model tracks HP/counters/activation like any other, but costs the gang nothing and is exempt from the gang-building rules (ducat limit, faction consistency, unique/Leader/ratio), so a legal summon can't push a gang over its limit or flip it to invalid. It is also the only kind of model that can be removed mid-game. 
/// * [state] - Present once the game has started (both players confirming their Agenda hand flips it to in_progress); null beforehand and for Catalog::Equipment entries, which have no HP/WP/CP to track.
/// * [mage] - Whether this model is a Mage and can therefore be given spells. Always false for Equipment.
/// * [spellSlots] - Maximum number of non-Cantrip spells the model may know (Mage X + Expert Sorcerer X). 0 for non-Mages.
/// * [disciplines] - Discipline slugs the model may pick spells from, e.g. [\"blood_rites\", \"divinity\"].
/// * [spellDiscipline] - The Discipline this model has committed to, or null if none picked yet.
/// * [cantrip] - The free Cantrip the model always knows for its committed Discipline; null when no Discipline is picked. Not counted against spell_slots.
/// * [spells] - The non-free spells this model currently knows.
@BuiltValue()
abstract class ListEntry implements Built<ListEntry, ListEntryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'entry_type')
  ListEntryEntryTypeEnum get entryType;
  // enum entryTypeEnum {  Catalog::CardReference,  Catalog::Equipment,  };

  @BuiltValueField(wireName: r'entry_id')
  int get entryId;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// The underlying profile's name without the card-reference letter suffix (e.g. \"Beggar\" rather than \"Beggar (A)\"). Use this to label a hired model and number duplicates client-side. Null for Equipment entries. 
  @BuiltValueField(wireName: r'profile_name')
  String? get profileName;

  /// Slug of the card reference this model is hired as — the same identifier the cards manifest keys downloaded images by. A profile can have several card references, each with a different illustration; this is the one currently chosen. Null for Equipment entries, which have no card. Change it via PATCH /list_entries/{id}/illustration. 
  @BuiltValueField(wireName: r'identifier')
  String? get identifier;

  /// Front face filename of the chosen card reference (served from /cards). Null for Equipment.
  @BuiltValueField(wireName: r'card_front')
  String? get cardFront;

  /// Back face filename of the chosen card reference (served from /cards). Null for Equipment.
  @BuiltValueField(wireName: r'card_back')
  String? get cardBack;

  @BuiltValueField(wireName: r'cost')
  int get cost;

  /// Conjured onto the board mid-game by a special rule, rather than hired during gang building. A summoned model tracks HP/counters/activation like any other, but costs the gang nothing and is exempt from the gang-building rules (ducat limit, faction consistency, unique/Leader/ratio), so a legal summon can't push a gang over its limit or flip it to invalid. It is also the only kind of model that can be removed mid-game. 
  @BuiltValueField(wireName: r'summoned')
  bool get summoned;

  /// Present once the game has started (both players confirming their Agenda hand flips it to in_progress); null beforehand and for Catalog::Equipment entries, which have no HP/WP/CP to track.
  @BuiltValueField(wireName: r'state')
  EntryState? get state;

  /// Whether this model is a Mage and can therefore be given spells. Always false for Equipment.
  @BuiltValueField(wireName: r'mage')
  bool get mage;

  /// Maximum number of non-Cantrip spells the model may know (Mage X + Expert Sorcerer X). 0 for non-Mages.
  @BuiltValueField(wireName: r'spell_slots')
  int get spellSlots;

  /// Discipline slugs the model may pick spells from, e.g. [\"blood_rites\", \"divinity\"].
  @BuiltValueField(wireName: r'disciplines')
  BuiltList<String> get disciplines;

  /// The Discipline this model has committed to, or null if none picked yet.
  @BuiltValueField(wireName: r'spell_discipline')
  String? get spellDiscipline;

  /// The free Cantrip the model always knows for its committed Discipline; null when no Discipline is picked. Not counted against spell_slots.
  @BuiltValueField(wireName: r'cantrip')
  Spell? get cantrip;

  /// The non-free spells this model currently knows.
  @BuiltValueField(wireName: r'spells')
  BuiltList<Spell> get spells;

  ListEntry._();

  factory ListEntry([void updates(ListEntryBuilder b)]) = _$ListEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListEntry> get serializer => _$ListEntrySerializer();
}

class _$ListEntrySerializer implements PrimitiveSerializer<ListEntry> {
  @override
  final Iterable<Type> types = const [ListEntry, _$ListEntry];

  @override
  final String wireName = r'ListEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'entry_type';
    yield serializers.serialize(
      object.entryType,
      specifiedType: const FullType(ListEntryEntryTypeEnum),
    );
    yield r'entry_id';
    yield serializers.serialize(
      object.entryId,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.profileName != null) {
      yield r'profile_name';
      yield serializers.serialize(
        object.profileName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.identifier != null) {
      yield r'identifier';
      yield serializers.serialize(
        object.identifier,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cardFront != null) {
      yield r'card_front';
      yield serializers.serialize(
        object.cardFront,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cardBack != null) {
      yield r'card_back';
      yield serializers.serialize(
        object.cardBack,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'cost';
    yield serializers.serialize(
      object.cost,
      specifiedType: const FullType(int),
    );
    yield r'summoned';
    yield serializers.serialize(
      object.summoned,
      specifiedType: const FullType(bool),
    );
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType.nullable(EntryState),
      );
    }
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
    if (object.spellDiscipline != null) {
      yield r'spell_discipline';
      yield serializers.serialize(
        object.spellDiscipline,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cantrip != null) {
      yield r'cantrip';
      yield serializers.serialize(
        object.cantrip,
        specifiedType: const FullType.nullable(Spell),
      );
    }
    yield r'spells';
    yield serializers.serialize(
      object.spells,
      specifiedType: const FullType(BuiltList, [FullType(Spell)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListEntryBuilder result,
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
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.position = valueDes;
          break;
        case r'entry_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListEntryEntryTypeEnum),
          ) as ListEntryEntryTypeEnum;
          result.entryType = valueDes;
          break;
        case r'entry_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.entryId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'profile_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.profileName = valueDes;
          break;
        case r'identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.identifier = valueDes;
          break;
        case r'card_front':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cardFront = valueDes;
          break;
        case r'card_back':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cardBack = valueDes;
          break;
        case r'cost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cost = valueDes;
          break;
        case r'summoned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.summoned = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EntryState),
          ) as EntryState?;
          if (valueDes == null) continue;
          result.state.replace(valueDes);
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
        case r'spell_discipline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.spellDiscipline = valueDes;
          break;
        case r'cantrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Spell),
          ) as Spell?;
          if (valueDes == null) continue;
          result.cantrip.replace(valueDes);
          break;
        case r'spells':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Spell)]),
          ) as BuiltList<Spell>;
          result.spells.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListEntryBuilder();
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

class ListEntryEntryTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Catalog::CardReference')
  static const ListEntryEntryTypeEnum catalogColonColonCardReference = _$listEntryEntryTypeEnum_catalogColonColonCardReference;
  @BuiltValueEnumConst(wireName: r'Catalog::Equipment')
  static const ListEntryEntryTypeEnum catalogColonColonEquipment = _$listEntryEntryTypeEnum_catalogColonColonEquipment;

  static Serializer<ListEntryEntryTypeEnum> get serializer => _$listEntryEntryTypeEnumSerializer;

  const ListEntryEntryTypeEnum._(String name): super(name);

  static BuiltSet<ListEntryEntryTypeEnum> get values => _$listEntryEntryTypeEnumValues;
  static ListEntryEntryTypeEnum valueOf(String name) => _$listEntryEntryTypeEnumValueOf(name);
}

