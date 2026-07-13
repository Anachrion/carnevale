//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_position_input_entry.g.dart';

/// EntryPositionInputEntry
///
/// Properties:
/// * [position] 
@BuiltValue()
abstract class EntryPositionInputEntry implements Built<EntryPositionInputEntry, EntryPositionInputEntryBuilder> {
  @BuiltValueField(wireName: r'position')
  int get position;

  EntryPositionInputEntry._();

  factory EntryPositionInputEntry([void updates(EntryPositionInputEntryBuilder b)]) = _$EntryPositionInputEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryPositionInputEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryPositionInputEntry> get serializer => _$EntryPositionInputEntrySerializer();
}

class _$EntryPositionInputEntrySerializer implements PrimitiveSerializer<EntryPositionInputEntry> {
  @override
  final Iterable<Type> types = const [EntryPositionInputEntry, _$EntryPositionInputEntry];

  @override
  final String wireName = r'EntryPositionInputEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryPositionInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryPositionInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EntryPositionInputEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.position = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EntryPositionInputEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryPositionInputEntryBuilder();
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

