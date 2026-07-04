//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'score_agenda_input.g.dart';

/// ScoreAgendaInput
///
/// Properties:
/// * [recycle] - If true, immediately draws a replacement card (origin `recycle`) linked back to this score.
@BuiltValue()
abstract class ScoreAgendaInput implements Built<ScoreAgendaInput, ScoreAgendaInputBuilder> {
  /// If true, immediately draws a replacement card (origin `recycle`) linked back to this score.
  @BuiltValueField(wireName: r'recycle')
  bool? get recycle;

  ScoreAgendaInput._();

  factory ScoreAgendaInput([void updates(ScoreAgendaInputBuilder b)]) = _$ScoreAgendaInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScoreAgendaInputBuilder b) => b
      ..recycle = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScoreAgendaInput> get serializer => _$ScoreAgendaInputSerializer();
}

class _$ScoreAgendaInputSerializer implements PrimitiveSerializer<ScoreAgendaInput> {
  @override
  final Iterable<Type> types = const [ScoreAgendaInput, _$ScoreAgendaInput];

  @override
  final String wireName = r'ScoreAgendaInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScoreAgendaInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    ScoreAgendaInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScoreAgendaInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  ScoreAgendaInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScoreAgendaInputBuilder();
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

