//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transform_entry_input.g.dart';

/// TransformEntryInput
///
/// Properties:
/// * [transformed] - The desired form (true = the model's alternate card, false = the one it was hired as) rather than a toggle, so a retried request can't flip it back. 
@BuiltValue()
abstract class TransformEntryInput implements Built<TransformEntryInput, TransformEntryInputBuilder> {
  /// The desired form (true = the model's alternate card, false = the one it was hired as) rather than a toggle, so a retried request can't flip it back. 
  @BuiltValueField(wireName: r'transformed')
  bool get transformed;

  TransformEntryInput._();

  factory TransformEntryInput([void updates(TransformEntryInputBuilder b)]) = _$TransformEntryInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransformEntryInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransformEntryInput> get serializer => _$TransformEntryInputSerializer();
}

class _$TransformEntryInputSerializer implements PrimitiveSerializer<TransformEntryInput> {
  @override
  final Iterable<Type> types = const [TransformEntryInput, _$TransformEntryInput];

  @override
  final String wireName = r'TransformEntryInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TransformEntryInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'transformed';
    yield serializers.serialize(
      object.transformed,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TransformEntryInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TransformEntryInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'transformed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.transformed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TransformEntryInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TransformEntryInputBuilder();
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

