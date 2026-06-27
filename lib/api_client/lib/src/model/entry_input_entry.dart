//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_input_entry.g.dart';

/// EntryInputEntry
///
/// Properties:
/// * [listId] 
/// * [cardReferenceId] 
@BuiltValue()
abstract class EntryInputEntry implements Built<EntryInputEntry, EntryInputEntryBuilder> {
  @BuiltValueField(wireName: r'list_id')
  int get listId;

  @BuiltValueField(wireName: r'card_reference_id')
  int get cardReferenceId;

  EntryInputEntry._();

  factory EntryInputEntry([void updates(EntryInputEntryBuilder b)]) = _$EntryInputEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryInputEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryInputEntry> get serializer => _$EntryInputEntrySerializer();
}

class _$EntryInputEntrySerializer implements PrimitiveSerializer<EntryInputEntry> {
  @override
  final Iterable<Type> types = const [EntryInputEntry, _$EntryInputEntry];

  @override
  final String wireName = r'EntryInputEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'list_id';
    yield serializers.serialize(
      object.listId,
      specifiedType: const FullType(int),
    );
    yield r'card_reference_id';
    yield serializers.serialize(
      object.cardReferenceId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EntryInputEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'list_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listId = valueDes;
          break;
        case r'card_reference_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cardReferenceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EntryInputEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryInputEntryBuilder();
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

