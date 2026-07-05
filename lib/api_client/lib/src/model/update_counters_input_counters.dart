//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_counters_input_counters.g.dart';

/// Partial set of counters to change — omitted ones keep their current values.
///
/// Properties:
/// * [stunned] 
/// * [hidden] 
/// * [guarding] 
/// * [carryingObjective] 
/// * [underwaterCounters] 
@BuiltValue()
abstract class UpdateCountersInputCounters implements Built<UpdateCountersInputCounters, UpdateCountersInputCountersBuilder> {
  @BuiltValueField(wireName: r'stunned')
  bool? get stunned;

  @BuiltValueField(wireName: r'hidden')
  bool? get hidden;

  @BuiltValueField(wireName: r'guarding')
  bool? get guarding;

  @BuiltValueField(wireName: r'carrying_objective')
  bool? get carryingObjective;

  @BuiltValueField(wireName: r'underwater_counters')
  int? get underwaterCounters;

  UpdateCountersInputCounters._();

  factory UpdateCountersInputCounters([void updates(UpdateCountersInputCountersBuilder b)]) = _$UpdateCountersInputCounters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCountersInputCountersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCountersInputCounters> get serializer => _$UpdateCountersInputCountersSerializer();
}

class _$UpdateCountersInputCountersSerializer implements PrimitiveSerializer<UpdateCountersInputCounters> {
  @override
  final Iterable<Type> types = const [UpdateCountersInputCounters, _$UpdateCountersInputCounters];

  @override
  final String wireName = r'UpdateCountersInputCounters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCountersInputCounters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.stunned != null) {
      yield r'stunned';
      yield serializers.serialize(
        object.stunned,
        specifiedType: const FullType(bool),
      );
    }
    if (object.hidden != null) {
      yield r'hidden';
      yield serializers.serialize(
        object.hidden,
        specifiedType: const FullType(bool),
      );
    }
    if (object.guarding != null) {
      yield r'guarding';
      yield serializers.serialize(
        object.guarding,
        specifiedType: const FullType(bool),
      );
    }
    if (object.carryingObjective != null) {
      yield r'carrying_objective';
      yield serializers.serialize(
        object.carryingObjective,
        specifiedType: const FullType(bool),
      );
    }
    if (object.underwaterCounters != null) {
      yield r'underwater_counters';
      yield serializers.serialize(
        object.underwaterCounters,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCountersInputCounters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateCountersInputCountersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stunned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.stunned = valueDes;
          break;
        case r'hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hidden = valueDes;
          break;
        case r'guarding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.guarding = valueDes;
          break;
        case r'carrying_objective':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.carryingObjective = valueDes;
          break;
        case r'underwater_counters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.underwaterCounters = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateCountersInputCounters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCountersInputCountersBuilder();
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

