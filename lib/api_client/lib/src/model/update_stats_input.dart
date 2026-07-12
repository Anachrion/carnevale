//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/update_stats_input_stats.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_stats_input.g.dart';

/// UpdateStatsInput
///
/// Properties:
/// * [stats]
@BuiltValue()
abstract class UpdateStatsInput
    implements Built<UpdateStatsInput, UpdateStatsInputBuilder> {
  @BuiltValueField(wireName: r'stats')
  UpdateStatsInputStats get stats;

  UpdateStatsInput._();

  factory UpdateStatsInput([void updates(UpdateStatsInputBuilder b)]) =
      _$UpdateStatsInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateStatsInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateStatsInput> get serializer =>
      _$UpdateStatsInputSerializer();
}

class _$UpdateStatsInputSerializer
    implements PrimitiveSerializer<UpdateStatsInput> {
  @override
  final Iterable<Type> types = const [UpdateStatsInput, _$UpdateStatsInput];

  @override
  final String wireName = r'UpdateStatsInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateStatsInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stats';
    yield serializers.serialize(
      object.stats,
      specifiedType: const FullType(UpdateStatsInputStats),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateStatsInput object, {
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
    required UpdateStatsInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stats':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(UpdateStatsInputStats),
                  )
                  as UpdateStatsInputStats;
          result.stats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateStatsInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateStatsInputBuilder();
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
