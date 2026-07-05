//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/update_counters_input_counters.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_counters_input.g.dart';

/// UpdateCountersInput
///
/// Properties:
/// * [counters] 
@BuiltValue()
abstract class UpdateCountersInput implements Built<UpdateCountersInput, UpdateCountersInputBuilder> {
  @BuiltValueField(wireName: r'counters')
  UpdateCountersInputCounters get counters;

  UpdateCountersInput._();

  factory UpdateCountersInput([void updates(UpdateCountersInputBuilder b)]) = _$UpdateCountersInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCountersInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCountersInput> get serializer => _$UpdateCountersInputSerializer();
}

class _$UpdateCountersInputSerializer implements PrimitiveSerializer<UpdateCountersInput> {
  @override
  final Iterable<Type> types = const [UpdateCountersInput, _$UpdateCountersInput];

  @override
  final String wireName = r'UpdateCountersInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCountersInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'counters';
    yield serializers.serialize(
      object.counters,
      specifiedType: const FullType(UpdateCountersInputCounters),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCountersInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateCountersInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'counters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateCountersInputCounters),
          ) as UpdateCountersInputCounters;
          result.counters.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateCountersInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCountersInputBuilder();
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

