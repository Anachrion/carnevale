//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/entry_input_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_input.g.dart';

/// EntryInput
///
/// Properties:
/// * [entry]
@BuiltValue()
abstract class EntryInput implements Built<EntryInput, EntryInputBuilder> {
  @BuiltValueField(wireName: r'entry')
  EntryInputEntry get entry;

  EntryInput._();

  factory EntryInput([void updates(EntryInputBuilder b)]) = _$EntryInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryInput> get serializer => _$EntryInputSerializer();
}

class _$EntryInputSerializer implements PrimitiveSerializer<EntryInput> {
  @override
  final Iterable<Type> types = const [EntryInput, _$EntryInput];

  @override
  final String wireName = r'EntryInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entry';
    yield serializers.serialize(
      object.entry,
      specifiedType: const FullType(EntryInputEntry),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryInput object, {
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
    required EntryInputBuilder result,
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
                    specifiedType: const FullType(EntryInputEntry),
                  )
                  as EntryInputEntry;
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
  EntryInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryInputBuilder();
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
