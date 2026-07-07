//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'discard_agenda_input.g.dart';

/// DiscardAgendaInput
///
/// Properties:
/// * [origin] - `unachievable` is the pre-game mulligan (valid during `agenda_draw`); `special_rule`/`command_point` are in-play discards (valid while `in_progress`). 
/// * [recycle] - Whether to immediately draw a replacement card (origin `recycle`) linked back to this discard. Only honoured for in-play discards; the `unachievable` mulligan always redraws. 
@BuiltValue()
abstract class DiscardAgendaInput implements Built<DiscardAgendaInput, DiscardAgendaInputBuilder> {
  /// `unachievable` is the pre-game mulligan (valid during `agenda_draw`); `special_rule`/`command_point` are in-play discards (valid while `in_progress`). 
  @BuiltValueField(wireName: r'origin')
  DiscardAgendaInputOriginEnum get origin;
  // enum originEnum {  unachievable,  special_rule,  command_point,  };

  /// Whether to immediately draw a replacement card (origin `recycle`) linked back to this discard. Only honoured for in-play discards; the `unachievable` mulligan always redraws. 
  @BuiltValueField(wireName: r'recycle')
  bool? get recycle;

  DiscardAgendaInput._();

  factory DiscardAgendaInput([void updates(DiscardAgendaInputBuilder b)]) = _$DiscardAgendaInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DiscardAgendaInputBuilder b) => b
      ..recycle = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<DiscardAgendaInput> get serializer => _$DiscardAgendaInputSerializer();
}

class _$DiscardAgendaInputSerializer implements PrimitiveSerializer<DiscardAgendaInput> {
  @override
  final Iterable<Type> types = const [DiscardAgendaInput, _$DiscardAgendaInput];

  @override
  final String wireName = r'DiscardAgendaInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DiscardAgendaInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'origin';
    yield serializers.serialize(
      object.origin,
      specifiedType: const FullType(DiscardAgendaInputOriginEnum),
    );
    if (object.recycle != null) {
      yield r'recycle';
      yield serializers.serialize(
        object.recycle,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DiscardAgendaInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DiscardAgendaInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscardAgendaInputOriginEnum),
          ) as DiscardAgendaInputOriginEnum;
          result.origin = valueDes;
          break;
        case r'recycle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.recycle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DiscardAgendaInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DiscardAgendaInputBuilder();
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

class DiscardAgendaInputOriginEnum extends EnumClass {

  /// `unachievable` is the pre-game mulligan (valid during `agenda_draw`); `special_rule`/`command_point` are in-play discards (valid while `in_progress`). 
  @BuiltValueEnumConst(wireName: r'unachievable')
  static const DiscardAgendaInputOriginEnum unachievable = _$discardAgendaInputOriginEnum_unachievable;
  /// `unachievable` is the pre-game mulligan (valid during `agenda_draw`); `special_rule`/`command_point` are in-play discards (valid while `in_progress`). 
  @BuiltValueEnumConst(wireName: r'special_rule')
  static const DiscardAgendaInputOriginEnum specialRule = _$discardAgendaInputOriginEnum_specialRule;
  /// `unachievable` is the pre-game mulligan (valid during `agenda_draw`); `special_rule`/`command_point` are in-play discards (valid while `in_progress`). 
  @BuiltValueEnumConst(wireName: r'command_point')
  static const DiscardAgendaInputOriginEnum commandPoint = _$discardAgendaInputOriginEnum_commandPoint;

  static Serializer<DiscardAgendaInputOriginEnum> get serializer => _$discardAgendaInputOriginEnumSerializer;

  const DiscardAgendaInputOriginEnum._(String name): super(name);

  static BuiltSet<DiscardAgendaInputOriginEnum> get values => _$discardAgendaInputOriginEnumValues;
  static DiscardAgendaInputOriginEnum valueOf(String name) => _$discardAgendaInputOriginEnumValueOf(name);
}

