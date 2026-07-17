//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/pool_spell.dart';
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/spell_rule_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'spell_pool.g.dart';

/// SpellPool
///
/// Properties:
/// * [id] 
/// * [of_] - How many Disciplines this pool's chosen_disciplines may span at once (1 for almost every profile; 2 for Doctor of the Firmament).
/// * [slotCount] - Non-Cantrip spells this pool grants, shared across every chosen Discipline when of > 1. Irrelevant when unlimited.
/// * [mageSlotCount] - The Mage(X)-only portion of slot_count, excluding any Expert Sorcerer(Y) bonus rolled into the same pool — equal to slot_count when there's no separate Expert Sorcerer ability. Relevant only when reading a *mentor candidate's* own pool: Apprentice Doctor's Apprenticeship copies the Mage ability alone, so her mentor_derived pool's resolved slot_count above already reflects the mentor's mage_slot_count, not their full slot_count — this field is what lets the picker preview that before saving, from the mentor's ListEntry in the same gang. 
/// * [unlimited] - When true, this model automatically knows every spell of its chosen Discipline(s) — spells/cantrips are pre-filled and there is nothing to pick.
/// * [grantsCantrip] - Whether committing a Discipline in this pool grants that Discipline's free Cantrip (not counted against slot_count).
/// * [mentorDerived] - Apprentice Doctor's Apprenticeship: when true, eligible_disciplines/of/slot_count are resolved from the mentor entry named by the parent ListEntry's mentored_by_entry_id (null/empty until a mentor is chosen), not static per-profile data. chosen_disciplines and spells are still this model's own picks. 
/// * [distinctFromOtherPools] - Tarot Reader's Minor Arcana: when true, this pool's chosen_disciplines must not overlap with any other pool's on the same model (\"1 additional Cantrip... from a different available Discipline\") — enforced server-side, exposed here so the picker can grey out a Discipline already committed by another of this model's pools. 
/// * [resetsEachRound] - Whether a spell cast through this pool becomes available again on the next round (true, the default — \"each character may only attempt to cast each spell once per round\") or stays cast for the rest of the game once marked (false — Adventuring Noble's Arcane Totem pool only, \"once per game\"). Applies to every PoolSpell in cantrips/spells. 
/// * [rule] - The card's special rule that explains this pool's shape (e.g. Aetheric Gaze, Entwined Magics, Apprenticeship, Arcane Totem), or null for the standard Mage(X) case.
/// * [eligibleDisciplines] - Discipline slugs this pool may pick from, e.g. [\"blood_rites\", \"divinity\"].
/// * [chosenDisciplines] - The subset of eligible_disciplines this model has actually committed to (size ≤ of).
/// * [cantrips] - The free Cantrip(s) for each committed Discipline (only present once grants_cantrip and a Discipline is chosen). Not counted against slot_count.
/// * [spells] - The non-free spells this model currently knows through this pool.
@BuiltValue()
abstract class SpellPool implements Built<SpellPool, SpellPoolBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  /// How many Disciplines this pool's chosen_disciplines may span at once (1 for almost every profile; 2 for Doctor of the Firmament).
  @BuiltValueField(wireName: r'of')
  int get of_;

  /// Non-Cantrip spells this pool grants, shared across every chosen Discipline when of > 1. Irrelevant when unlimited.
  @BuiltValueField(wireName: r'slot_count')
  int get slotCount;

  /// The Mage(X)-only portion of slot_count, excluding any Expert Sorcerer(Y) bonus rolled into the same pool — equal to slot_count when there's no separate Expert Sorcerer ability. Relevant only when reading a *mentor candidate's* own pool: Apprentice Doctor's Apprenticeship copies the Mage ability alone, so her mentor_derived pool's resolved slot_count above already reflects the mentor's mage_slot_count, not their full slot_count — this field is what lets the picker preview that before saving, from the mentor's ListEntry in the same gang. 
  @BuiltValueField(wireName: r'mage_slot_count')
  int get mageSlotCount;

  /// When true, this model automatically knows every spell of its chosen Discipline(s) — spells/cantrips are pre-filled and there is nothing to pick.
  @BuiltValueField(wireName: r'unlimited')
  bool get unlimited;

  /// Whether committing a Discipline in this pool grants that Discipline's free Cantrip (not counted against slot_count).
  @BuiltValueField(wireName: r'grants_cantrip')
  bool get grantsCantrip;

  /// Apprentice Doctor's Apprenticeship: when true, eligible_disciplines/of/slot_count are resolved from the mentor entry named by the parent ListEntry's mentored_by_entry_id (null/empty until a mentor is chosen), not static per-profile data. chosen_disciplines and spells are still this model's own picks. 
  @BuiltValueField(wireName: r'mentor_derived')
  bool get mentorDerived;

  /// Tarot Reader's Minor Arcana: when true, this pool's chosen_disciplines must not overlap with any other pool's on the same model (\"1 additional Cantrip... from a different available Discipline\") — enforced server-side, exposed here so the picker can grey out a Discipline already committed by another of this model's pools. 
  @BuiltValueField(wireName: r'distinct_from_other_pools')
  bool get distinctFromOtherPools;

  /// Whether a spell cast through this pool becomes available again on the next round (true, the default — \"each character may only attempt to cast each spell once per round\") or stays cast for the rest of the game once marked (false — Adventuring Noble's Arcane Totem pool only, \"once per game\"). Applies to every PoolSpell in cantrips/spells. 
  @BuiltValueField(wireName: r'resets_each_round')
  bool get resetsEachRound;

  /// The card's special rule that explains this pool's shape (e.g. Aetheric Gaze, Entwined Magics, Apprenticeship, Arcane Totem), or null for the standard Mage(X) case.
  @BuiltValueField(wireName: r'rule')
  SpellRuleRef? get rule;

  /// Discipline slugs this pool may pick from, e.g. [\"blood_rites\", \"divinity\"].
  @BuiltValueField(wireName: r'eligible_disciplines')
  BuiltList<String> get eligibleDisciplines;

  /// The subset of eligible_disciplines this model has actually committed to (size ≤ of).
  @BuiltValueField(wireName: r'chosen_disciplines')
  BuiltList<String> get chosenDisciplines;

  /// The free Cantrip(s) for each committed Discipline (only present once grants_cantrip and a Discipline is chosen). Not counted against slot_count.
  @BuiltValueField(wireName: r'cantrips')
  BuiltList<PoolSpell> get cantrips;

  /// The non-free spells this model currently knows through this pool.
  @BuiltValueField(wireName: r'spells')
  BuiltList<PoolSpell> get spells;

  SpellPool._();

  factory SpellPool([void updates(SpellPoolBuilder b)]) = _$SpellPool;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SpellPoolBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SpellPool> get serializer => _$SpellPoolSerializer();
}

class _$SpellPoolSerializer implements PrimitiveSerializer<SpellPool> {
  @override
  final Iterable<Type> types = const [SpellPool, _$SpellPool];

  @override
  final String wireName = r'SpellPool';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SpellPool object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'of';
    yield serializers.serialize(
      object.of_,
      specifiedType: const FullType(int),
    );
    yield r'slot_count';
    yield serializers.serialize(
      object.slotCount,
      specifiedType: const FullType(int),
    );
    yield r'mage_slot_count';
    yield serializers.serialize(
      object.mageSlotCount,
      specifiedType: const FullType(int),
    );
    yield r'unlimited';
    yield serializers.serialize(
      object.unlimited,
      specifiedType: const FullType(bool),
    );
    yield r'grants_cantrip';
    yield serializers.serialize(
      object.grantsCantrip,
      specifiedType: const FullType(bool),
    );
    yield r'mentor_derived';
    yield serializers.serialize(
      object.mentorDerived,
      specifiedType: const FullType(bool),
    );
    yield r'distinct_from_other_pools';
    yield serializers.serialize(
      object.distinctFromOtherPools,
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
    yield r'eligible_disciplines';
    yield serializers.serialize(
      object.eligibleDisciplines,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'chosen_disciplines';
    yield serializers.serialize(
      object.chosenDisciplines,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'cantrips';
    yield serializers.serialize(
      object.cantrips,
      specifiedType: const FullType(BuiltList, [FullType(PoolSpell)]),
    );
    yield r'spells';
    yield serializers.serialize(
      object.spells,
      specifiedType: const FullType(BuiltList, [FullType(PoolSpell)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SpellPool object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SpellPoolBuilder result,
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
        case r'of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.of_ = valueDes;
          break;
        case r'slot_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.slotCount = valueDes;
          break;
        case r'mage_slot_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.mageSlotCount = valueDes;
          break;
        case r'unlimited':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.unlimited = valueDes;
          break;
        case r'grants_cantrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.grantsCantrip = valueDes;
          break;
        case r'mentor_derived':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mentorDerived = valueDes;
          break;
        case r'distinct_from_other_pools':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.distinctFromOtherPools = valueDes;
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
        case r'eligible_disciplines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.eligibleDisciplines.replace(valueDes);
          break;
        case r'chosen_disciplines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.chosenDisciplines.replace(valueDes);
          break;
        case r'cantrips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PoolSpell)]),
          ) as BuiltList<PoolSpell>;
          result.cantrips.replace(valueDes);
          break;
        case r'spells':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PoolSpell)]),
          ) as BuiltList<PoolSpell>;
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
  SpellPool deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SpellPoolBuilder();
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

