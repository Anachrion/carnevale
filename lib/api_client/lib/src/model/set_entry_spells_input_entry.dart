//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/set_entry_spells_input_entry_pool_selections_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_entry_spells_input_entry.g.dart';

/// SetEntrySpellsInputEntry
///
/// Properties:
/// * [mentoredByEntryId] - Apprentice Doctor's Apprenticeship only: id of another ListEntry in the same list to copy Mage disciplines/slot_count from (see ListEntry.mentored_by_entry_id), or null to clear it. Omit entirely to leave the current mentor untouched — unlike pool_selections, this field is not wholesale-replaced on every call. 
/// * [poolSelections] - One entry per pool (almost always one pool; a two-pool model like Seamstress or Doctor of the Firmament needs one entry per pool). Replaces this model's *entire* spell selection wholesale across every pool — a pool omitted here loses its selection, it isn't left untouched — so always submit every pool the model has, not just the one that changed. 
@BuiltValue()
abstract class SetEntrySpellsInputEntry implements Built<SetEntrySpellsInputEntry, SetEntrySpellsInputEntryBuilder> {
  /// Apprentice Doctor's Apprenticeship only: id of another ListEntry in the same list to copy Mage disciplines/slot_count from (see ListEntry.mentored_by_entry_id), or null to clear it. Omit entirely to leave the current mentor untouched — unlike pool_selections, this field is not wholesale-replaced on every call. 
  @BuiltValueField(wireName: r'mentored_by_entry_id')
  int? get mentoredByEntryId;

  /// One entry per pool (almost always one pool; a two-pool model like Seamstress or Doctor of the Firmament needs one entry per pool). Replaces this model's *entire* spell selection wholesale across every pool — a pool omitted here loses its selection, it isn't left untouched — so always submit every pool the model has, not just the one that changed. 
  @BuiltValueField(wireName: r'pool_selections')
  BuiltList<SetEntrySpellsInputEntryPoolSelectionsInner>? get poolSelections;

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
    if (object.mentoredByEntryId != null) {
      yield r'mentored_by_entry_id';
      yield serializers.serialize(
        object.mentoredByEntryId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.poolSelections != null) {
      yield r'pool_selections';
      yield serializers.serialize(
        object.poolSelections,
        specifiedType: const FullType(BuiltList, [FullType(SetEntrySpellsInputEntryPoolSelectionsInner)]),
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
        case r'mentored_by_entry_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.mentoredByEntryId = valueDes;
          break;
        case r'pool_selections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SetEntrySpellsInputEntryPoolSelectionsInner)]),
          ) as BuiltList<SetEntrySpellsInputEntryPoolSelectionsInner>;
          result.poolSelections.replace(valueDes);
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

