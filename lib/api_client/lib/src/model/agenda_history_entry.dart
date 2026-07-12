//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/agenda_history_entry_agenda.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'agenda_history_entry.g.dart';

/// AgendaHistoryEntry
///
/// Properties:
/// * [turn]
/// * [action]
/// * [origin] - Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding is. `unachievable` marks a pre-game mulligan discard.
/// * [causedByEventId] - Set only when origin is `recycle` — the id of the scored/discarded event (within this same list) that triggered this replacement draw.
/// * [agenda]
@BuiltValue()
abstract class AgendaHistoryEntry
    implements Built<AgendaHistoryEntry, AgendaHistoryEntryBuilder> {
  @BuiltValueField(wireName: r'turn')
  int get turn;

  @BuiltValueField(wireName: r'action')
  AgendaHistoryEntryActionEnum get action;
  // enum actionEnum {  drawn,  scored,  discarded,  };

  /// Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding is. `unachievable` marks a pre-game mulligan discard.
  @BuiltValueField(wireName: r'origin')
  AgendaHistoryEntryOriginEnum? get origin;
  // enum originEnum {  initial,  unachievable,  special_rule,  command_point,  recycle,  };

  /// Set only when origin is `recycle` — the id of the scored/discarded event (within this same list) that triggered this replacement draw.
  @BuiltValueField(wireName: r'caused_by_event_id')
  int? get causedByEventId;

  @BuiltValueField(wireName: r'agenda')
  AgendaHistoryEntryAgenda get agenda;

  AgendaHistoryEntry._();

  factory AgendaHistoryEntry([void updates(AgendaHistoryEntryBuilder b)]) =
      _$AgendaHistoryEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AgendaHistoryEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AgendaHistoryEntry> get serializer =>
      _$AgendaHistoryEntrySerializer();
}

class _$AgendaHistoryEntrySerializer
    implements PrimitiveSerializer<AgendaHistoryEntry> {
  @override
  final Iterable<Type> types = const [AgendaHistoryEntry, _$AgendaHistoryEntry];

  @override
  final String wireName = r'AgendaHistoryEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AgendaHistoryEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'turn';
    yield serializers.serialize(
      object.turn,
      specifiedType: const FullType(int),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(AgendaHistoryEntryActionEnum),
    );
    yield r'origin';
    yield object.origin == null
        ? null
        : serializers.serialize(
            object.origin,
            specifiedType: const FullType.nullable(
              AgendaHistoryEntryOriginEnum,
            ),
          );
    yield r'caused_by_event_id';
    yield object.causedByEventId == null
        ? null
        : serializers.serialize(
            object.causedByEventId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'agenda';
    yield serializers.serialize(
      object.agenda,
      specifiedType: const FullType(AgendaHistoryEntryAgenda),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AgendaHistoryEntry object, {
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
    required AgendaHistoryEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'turn':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.turn = valueDes;
          break;
        case r'action':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AgendaHistoryEntryActionEnum),
                  )
                  as AgendaHistoryEntryActionEnum;
          result.action = valueDes;
          break;
        case r'origin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AgendaHistoryEntryOriginEnum,
                    ),
                  )
                  as AgendaHistoryEntryOriginEnum?;
          if (valueDes == null) continue;
          result.origin = valueDes;
          break;
        case r'caused_by_event_id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.causedByEventId = valueDes;
          break;
        case r'agenda':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AgendaHistoryEntryAgenda),
                  )
                  as AgendaHistoryEntryAgenda;
          result.agenda.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AgendaHistoryEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AgendaHistoryEntryBuilder();
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

class AgendaHistoryEntryActionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'drawn')
  static const AgendaHistoryEntryActionEnum drawn =
      _$agendaHistoryEntryActionEnum_drawn;
  @BuiltValueEnumConst(wireName: r'scored')
  static const AgendaHistoryEntryActionEnum scored =
      _$agendaHistoryEntryActionEnum_scored;
  @BuiltValueEnumConst(wireName: r'discarded')
  static const AgendaHistoryEntryActionEnum discarded =
      _$agendaHistoryEntryActionEnum_discarded;

  static Serializer<AgendaHistoryEntryActionEnum> get serializer =>
      _$agendaHistoryEntryActionEnumSerializer;

  const AgendaHistoryEntryActionEnum._(String name) : super(name);

  static BuiltSet<AgendaHistoryEntryActionEnum> get values =>
      _$agendaHistoryEntryActionEnumValues;
  static AgendaHistoryEntryActionEnum valueOf(String name) =>
      _$agendaHistoryEntryActionEnumValueOf(name);
}

class AgendaHistoryEntryOriginEnum extends EnumClass {
  /// Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding is. `unachievable` marks a pre-game mulligan discard.
  @BuiltValueEnumConst(wireName: r'initial')
  static const AgendaHistoryEntryOriginEnum initial =
      _$agendaHistoryEntryOriginEnum_initial;

  /// Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding is. `unachievable` marks a pre-game mulligan discard.
  @BuiltValueEnumConst(wireName: r'unachievable')
  static const AgendaHistoryEntryOriginEnum unachievable =
      _$agendaHistoryEntryOriginEnum_unachievable;

  /// Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding is. `unachievable` marks a pre-game mulligan discard.
  @BuiltValueEnumConst(wireName: r'special_rule')
  static const AgendaHistoryEntryOriginEnum specialRule =
      _$agendaHistoryEntryOriginEnum_specialRule;

  /// Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding is. `unachievable` marks a pre-game mulligan discard.
  @BuiltValueEnumConst(wireName: r'command_point')
  static const AgendaHistoryEntryOriginEnum commandPoint =
      _$agendaHistoryEntryOriginEnum_commandPoint;

  /// Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding is. `unachievable` marks a pre-game mulligan discard.
  @BuiltValueEnumConst(wireName: r'recycle')
  static const AgendaHistoryEntryOriginEnum recycle =
      _$agendaHistoryEntryOriginEnum_recycle;

  static Serializer<AgendaHistoryEntryOriginEnum> get serializer =>
      _$agendaHistoryEntryOriginEnumSerializer;

  const AgendaHistoryEntryOriginEnum._(String name) : super(name);

  static BuiltSet<AgendaHistoryEntryOriginEnum> get values =>
      _$agendaHistoryEntryOriginEnumValues;
  static AgendaHistoryEntryOriginEnum valueOf(String name) =>
      _$agendaHistoryEntryOriginEnumValueOf(name);
}
