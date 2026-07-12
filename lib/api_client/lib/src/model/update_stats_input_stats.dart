//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_stats_input_stats.g.dart';

/// Partial set of current stat values to change — omitted ones keep their current values. Absolute values, not deltas.
///
/// Properties:
/// * [lifePoints]
/// * [willPoints]
/// * [commandPoints]
@BuiltValue()
abstract class UpdateStatsInputStats
    implements Built<UpdateStatsInputStats, UpdateStatsInputStatsBuilder> {
  @BuiltValueField(wireName: r'life_points')
  int? get lifePoints;

  @BuiltValueField(wireName: r'will_points')
  int? get willPoints;

  @BuiltValueField(wireName: r'command_points')
  int? get commandPoints;

  UpdateStatsInputStats._();

  factory UpdateStatsInputStats([
    void updates(UpdateStatsInputStatsBuilder b),
  ]) = _$UpdateStatsInputStats;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateStatsInputStatsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateStatsInputStats> get serializer =>
      _$UpdateStatsInputStatsSerializer();
}

class _$UpdateStatsInputStatsSerializer
    implements PrimitiveSerializer<UpdateStatsInputStats> {
  @override
  final Iterable<Type> types = const [
    UpdateStatsInputStats,
    _$UpdateStatsInputStats,
  ];

  @override
  final String wireName = r'UpdateStatsInputStats';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateStatsInputStats object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.lifePoints != null) {
      yield r'life_points';
      yield serializers.serialize(
        object.lifePoints,
        specifiedType: const FullType(int),
      );
    }
    if (object.willPoints != null) {
      yield r'will_points';
      yield serializers.serialize(
        object.willPoints,
        specifiedType: const FullType(int),
      );
    }
    if (object.commandPoints != null) {
      yield r'command_points';
      yield serializers.serialize(
        object.commandPoints,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateStatsInputStats object, {
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
    required UpdateStatsInputStatsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'life_points':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.lifePoints = valueDes;
          break;
        case r'will_points':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.willPoints = valueDes;
          break;
        case r'command_points':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.commandPoints = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateStatsInputStats deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateStatsInputStatsBuilder();
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
