//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/entry_position_input_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_position_input.g.dart';

/// EntryPositionInput
///
/// Properties:
/// * [entry]
@BuiltValue()
abstract class EntryPositionInput
    implements Built<EntryPositionInput, EntryPositionInputBuilder> {
  @BuiltValueField(wireName: r'entry')
  EntryPositionInputEntry get entry;

  EntryPositionInput._();

  factory EntryPositionInput([void updates(EntryPositionInputBuilder b)]) =
      _$EntryPositionInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryPositionInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryPositionInput> get serializer =>
      _$EntryPositionInputSerializer();
}

class _$EntryPositionInputSerializer
    implements PrimitiveSerializer<EntryPositionInput> {
  @override
  final Iterable<Type> types = const [EntryPositionInput, _$EntryPositionInput];

  @override
  final String wireName = r'EntryPositionInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryPositionInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entry';
    yield serializers.serialize(
      object.entry,
      specifiedType: const FullType(EntryPositionInputEntry),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryPositionInput object, {
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
    required EntryPositionInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entry':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(EntryPositionInputEntry),
                  )
                  as EntryPositionInputEntry;
          result.entry.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EntryPositionInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryPositionInputBuilder();
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
