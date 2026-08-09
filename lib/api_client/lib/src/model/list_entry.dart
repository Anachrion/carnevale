//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/entry_state.dart';
import 'package:carnevale_api/src/model/granted_spell.dart';
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/spell_pool.dart';
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
/// * [keywords] - The underlying profile's printed keywords (e.g. [\"Hero\", \"Doctor\"]) — used client-side to filter Apprentice Doctor's Apprenticeship mentor candidates (\"a character with both the Doctor and Hero keywords\"). Empty for Equipment. 
/// * [flexibleLeader] - Whether this model is a \"flex\" Leader — one that drops its Leader keyword and becomes a plain Hero when the gang already contains another Leader (The Duke, Prince of Thieves, Sopracomito, La Signora). The gang builder uses it to keep offering a Leader model's \"add\" button once a Leader is present; server-side enforcement is ListValidationService. False for Equipment and for every non-flex Leader. 
/// * [demotedLeader] - Whether this flex Leader has been demoted to a plain Hero by the gang's composition (it prints Leader but has lost it). The client shows the Hero keyword and never pins it as the gang's Leader. False for the effective Leader and for non-Leaders. 
/// * [promotableLeader] - Whether this demoted flex Leader could be promoted to Leader instead — only in the ambiguous case of several unconditional flex Leaders and no forced Leader, where the player chooses. The client shows a \"promote\" action that moves it to the top. 
/// * [identifier] - Slug of the card reference this model is hired as — the same identifier the cards manifest keys downloaded images by. A profile can have several card references, each with a different illustration; this is the one currently chosen. Null for Equipment entries, which have no card. Change it via PATCH /list_entries/{id}/illustration. 
/// * [cardFront] - Front face filename of the chosen card reference (served from /cards). Null for Equipment.
/// * [cardBack] - Back face filename of the chosen card reference (served from /cards). Null for Equipment.
/// * [cost] 
/// * [summoned] - Conjured onto the board mid-game by a special rule, rather than hired during gang building. A summoned model tracks HP/counters/activation like any other, but costs the gang nothing and is exempt from the gang-building rules (ducat limit, faction consistency, unique/Leader/ratio), so a legal summon can't push a gang over its limit or flip it to invalid. It is also the only kind of model that can be removed mid-game. 
/// * [companionOfEntryId] - Id of the entry that automatically brought this one in — the Emissary of Mother Hydra that owns this Tentacle (CARNEVALEB-23). Null for a normally hired model. A companion is read-only in the builder: it can't be reordered or removed on its own, only alongside the model that brought it. 
/// * [upgradeSelected] - Whether this model's optional paid upgrade has been bought — the Emissary's +12 Ducats for a second set of Tentacles. Its Ducat cost is already included in `cost`. Toggle via PATCH /list_entries/{id}/upgrade. 
/// * [upgradeAvailable] - Whether this model offers an optional paid upgrade at all. The client shows the upgrade toggle only when true. False for models with no upgrade and for Equipment. 
/// * [upgradeDucats] - The Ducat cost of this model's optional upgrade (0 when none is offered).
/// * [transformable] - Whether this model has a second printed card it swaps between mid-game — Violent Transformation (Yune Lobravym ⇄ The Beast Within). The client offers the transform button only when true. False for every other model and for Equipment. 
/// * [transformed] - Which of its two cards this model is currently on the table as: false for the one it was hired as, true for its alternate form. Only ever true during a game — a hired gang always holds the model in its printed form. While true, `identifier`, `name`, `profile_name`, `keywords`, `card_front`, `card_back` and `mage` all describe the alternate form, but `cost` stays that of the hire, and the model keeps its one EntryState, so Life/Will/ Command Points carry across the change untouched. Toggle via PATCH /games/{id}/entries/{list_entry_id}/transform. 
/// * [alternateIdentifier] - The card identifier of this model's other form, or null when it has none. Lets the gang builder preview the other card without a round trip — in the builder the button only flips the card being shown, because the rule transforms a model in play, not at hiring. 
/// * [alternateName] - The name printed on the other form's card, or null when there is no other form.
/// * [alternateCardFront] - Front face filename of the other form's card, resolved like `card_front`. Null when there is no other form.
/// * [alternateCardBack] - Back face filename of the other form's card, resolved like `card_back`. Null when there is no other form.
/// * [state] - Present once the game has started (both players confirming their Agenda hand flips it to in_progress); null beforehand and for Catalog::Equipment entries, which have no HP/WP/CP to track.
/// * [mage] - Whether this model is a Mage and can therefore be given spells. Always false for Equipment; non-Mage models carry empty pools/granted_spells.
/// * [mentoredByEntryId] - Apprentice Doctor's Apprenticeship: the id of another ListEntry in the same list whose resolved Mage pool this model's mentor_derived pool borrows its disciplines/slot_count from. Null for every other profile, and null until a mentor is chosen. Set it via PATCH /list_entries/{id}/spells (SetEntrySpellsInput.entry.mentored_by_entry_id). 
/// * [distinctDisciplinePerCopy] - Romani's Tarot: when true, every other ListEntry of the same profile in this list must commit its first pool to a different Discipline from this one's — enforced server-side (ListValidationService), exposed here only so the picker can grey out a sibling's already-chosen Discipline with an inline reason. False for every other profile. 
/// * [pools] - This model's spell-selection pools (rulebook p24), in profile order. Empty for non-Mage models. Most profiles have exactly one; a few (Seamstress, Tarot Reader) have two, and one (Doctor of the Firmament) spans multiple Disciplines at once via a single pool's `of`. 
/// * [grantedSpells] - Spells this model always knows regardless of pool picks (e.g. Galilean Priest's Waves of Force, Blood Crone's five Cantrips) — read-only, never edited through the spells endpoint, and don't count against any pool's slot_count. 
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

  /// The underlying profile's printed keywords (e.g. [\"Hero\", \"Doctor\"]) — used client-side to filter Apprentice Doctor's Apprenticeship mentor candidates (\"a character with both the Doctor and Hero keywords\"). Empty for Equipment. 
  @BuiltValueField(wireName: r'keywords')
  BuiltList<String> get keywords;

  /// Whether this model is a \"flex\" Leader — one that drops its Leader keyword and becomes a plain Hero when the gang already contains another Leader (The Duke, Prince of Thieves, Sopracomito, La Signora). The gang builder uses it to keep offering a Leader model's \"add\" button once a Leader is present; server-side enforcement is ListValidationService. False for Equipment and for every non-flex Leader. 
  @BuiltValueField(wireName: r'flexible_leader')
  bool get flexibleLeader;

  /// Whether this flex Leader has been demoted to a plain Hero by the gang's composition (it prints Leader but has lost it). The client shows the Hero keyword and never pins it as the gang's Leader. False for the effective Leader and for non-Leaders. 
  @BuiltValueField(wireName: r'demoted_leader')
  bool get demotedLeader;

  /// Whether this demoted flex Leader could be promoted to Leader instead — only in the ambiguous case of several unconditional flex Leaders and no forced Leader, where the player chooses. The client shows a \"promote\" action that moves it to the top. 
  @BuiltValueField(wireName: r'promotable_leader')
  bool get promotableLeader;

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

  /// Id of the entry that automatically brought this one in — the Emissary of Mother Hydra that owns this Tentacle (CARNEVALEB-23). Null for a normally hired model. A companion is read-only in the builder: it can't be reordered or removed on its own, only alongside the model that brought it. 
  @BuiltValueField(wireName: r'companion_of_entry_id')
  int? get companionOfEntryId;

  /// Whether this model's optional paid upgrade has been bought — the Emissary's +12 Ducats for a second set of Tentacles. Its Ducat cost is already included in `cost`. Toggle via PATCH /list_entries/{id}/upgrade. 
  @BuiltValueField(wireName: r'upgrade_selected')
  bool get upgradeSelected;

  /// Whether this model offers an optional paid upgrade at all. The client shows the upgrade toggle only when true. False for models with no upgrade and for Equipment. 
  @BuiltValueField(wireName: r'upgrade_available')
  bool get upgradeAvailable;

  /// The Ducat cost of this model's optional upgrade (0 when none is offered).
  @BuiltValueField(wireName: r'upgrade_ducats')
  int get upgradeDucats;

  /// Whether this model has a second printed card it swaps between mid-game — Violent Transformation (Yune Lobravym ⇄ The Beast Within). The client offers the transform button only when true. False for every other model and for Equipment. 
  @BuiltValueField(wireName: r'transformable')
  bool get transformable;

  /// Which of its two cards this model is currently on the table as: false for the one it was hired as, true for its alternate form. Only ever true during a game — a hired gang always holds the model in its printed form. While true, `identifier`, `name`, `profile_name`, `keywords`, `card_front`, `card_back` and `mage` all describe the alternate form, but `cost` stays that of the hire, and the model keeps its one EntryState, so Life/Will/ Command Points carry across the change untouched. Toggle via PATCH /games/{id}/entries/{list_entry_id}/transform. 
  @BuiltValueField(wireName: r'transformed')
  bool get transformed;

  /// The card identifier of this model's other form, or null when it has none. Lets the gang builder preview the other card without a round trip — in the builder the button only flips the card being shown, because the rule transforms a model in play, not at hiring. 
  @BuiltValueField(wireName: r'alternate_identifier')
  String? get alternateIdentifier;

  /// The name printed on the other form's card, or null when there is no other form.
  @BuiltValueField(wireName: r'alternate_name')
  String? get alternateName;

  /// Front face filename of the other form's card, resolved like `card_front`. Null when there is no other form.
  @BuiltValueField(wireName: r'alternate_card_front')
  String? get alternateCardFront;

  /// Back face filename of the other form's card, resolved like `card_back`. Null when there is no other form.
  @BuiltValueField(wireName: r'alternate_card_back')
  String? get alternateCardBack;

  /// Present once the game has started (both players confirming their Agenda hand flips it to in_progress); null beforehand and for Catalog::Equipment entries, which have no HP/WP/CP to track.
  @BuiltValueField(wireName: r'state')
  EntryState? get state;

  /// Whether this model is a Mage and can therefore be given spells. Always false for Equipment; non-Mage models carry empty pools/granted_spells.
  @BuiltValueField(wireName: r'mage')
  bool get mage;

  /// Apprentice Doctor's Apprenticeship: the id of another ListEntry in the same list whose resolved Mage pool this model's mentor_derived pool borrows its disciplines/slot_count from. Null for every other profile, and null until a mentor is chosen. Set it via PATCH /list_entries/{id}/spells (SetEntrySpellsInput.entry.mentored_by_entry_id). 
  @BuiltValueField(wireName: r'mentored_by_entry_id')
  int? get mentoredByEntryId;

  /// Romani's Tarot: when true, every other ListEntry of the same profile in this list must commit its first pool to a different Discipline from this one's — enforced server-side (ListValidationService), exposed here only so the picker can grey out a sibling's already-chosen Discipline with an inline reason. False for every other profile. 
  @BuiltValueField(wireName: r'distinct_discipline_per_copy')
  bool get distinctDisciplinePerCopy;

  /// This model's spell-selection pools (rulebook p24), in profile order. Empty for non-Mage models. Most profiles have exactly one; a few (Seamstress, Tarot Reader) have two, and one (Doctor of the Firmament) spans multiple Disciplines at once via a single pool's `of`. 
  @BuiltValueField(wireName: r'pools')
  BuiltList<SpellPool> get pools;

  /// Spells this model always knows regardless of pool picks (e.g. Galilean Priest's Waves of Force, Blood Crone's five Cantrips) — read-only, never edited through the spells endpoint, and don't count against any pool's slot_count. 
  @BuiltValueField(wireName: r'granted_spells')
  BuiltList<GrantedSpell> get grantedSpells;

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
    yield r'demoted_leader';
    yield serializers.serialize(
      object.demotedLeader,
      specifiedType: const FullType(bool),
    );
    yield r'promotable_leader';
    yield serializers.serialize(
      object.promotableLeader,
      specifiedType: const FullType(bool),
    );
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
    if (object.companionOfEntryId != null) {
      yield r'companion_of_entry_id';
      yield serializers.serialize(
        object.companionOfEntryId,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'upgrade_selected';
    yield serializers.serialize(
      object.upgradeSelected,
      specifiedType: const FullType(bool),
    );
    yield r'upgrade_available';
    yield serializers.serialize(
      object.upgradeAvailable,
      specifiedType: const FullType(bool),
    );
    yield r'upgrade_ducats';
    yield serializers.serialize(
      object.upgradeDucats,
      specifiedType: const FullType(int),
    );
    yield r'transformable';
    yield serializers.serialize(
      object.transformable,
      specifiedType: const FullType(bool),
    );
    yield r'transformed';
    yield serializers.serialize(
      object.transformed,
      specifiedType: const FullType(bool),
    );
    if (object.alternateIdentifier != null) {
      yield r'alternate_identifier';
      yield serializers.serialize(
        object.alternateIdentifier,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.alternateName != null) {
      yield r'alternate_name';
      yield serializers.serialize(
        object.alternateName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.alternateCardFront != null) {
      yield r'alternate_card_front';
      yield serializers.serialize(
        object.alternateCardFront,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.alternateCardBack != null) {
      yield r'alternate_card_back';
      yield serializers.serialize(
        object.alternateCardBack,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    if (object.mentoredByEntryId != null) {
      yield r'mentored_by_entry_id';
      yield serializers.serialize(
        object.mentoredByEntryId,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'distinct_discipline_per_copy';
    yield serializers.serialize(
      object.distinctDisciplinePerCopy,
      specifiedType: const FullType(bool),
    );
    yield r'pools';
    yield serializers.serialize(
      object.pools,
      specifiedType: const FullType(BuiltList, [FullType(SpellPool)]),
    );
    yield r'granted_spells';
    yield serializers.serialize(
      object.grantedSpells,
      specifiedType: const FullType(BuiltList, [FullType(GrantedSpell)]),
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
        case r'demoted_leader':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.demotedLeader = valueDes;
          break;
        case r'promotable_leader':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.promotableLeader = valueDes;
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
        case r'companion_of_entry_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.companionOfEntryId = valueDes;
          break;
        case r'upgrade_selected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.upgradeSelected = valueDes;
          break;
        case r'upgrade_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.upgradeAvailable = valueDes;
          break;
        case r'upgrade_ducats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.upgradeDucats = valueDes;
          break;
        case r'transformable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.transformable = valueDes;
          break;
        case r'transformed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.transformed = valueDes;
          break;
        case r'alternate_identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateIdentifier = valueDes;
          break;
        case r'alternate_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateName = valueDes;
          break;
        case r'alternate_card_front':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateCardFront = valueDes;
          break;
        case r'alternate_card_back':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateCardBack = valueDes;
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
        case r'mentored_by_entry_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.mentoredByEntryId = valueDes;
          break;
        case r'distinct_discipline_per_copy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.distinctDisciplinePerCopy = valueDes;
          break;
        case r'pools':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SpellPool)]),
          ) as BuiltList<SpellPool>;
          result.pools.replace(valueDes);
          break;
        case r'granted_spells':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GrantedSpell)]),
          ) as BuiltList<GrantedSpell>;
          result.grantedSpells.replace(valueDes);
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

