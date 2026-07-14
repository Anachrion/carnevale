//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_illustration_input_entry.g.dart';

/// EntryIllustrationInputEntry
///
/// Properties:
/// * [entryId] - Id of the card reference to switch this model to. Must be another card reference of the same profile (a different illustration of the same model); the request is rejected otherwise. 
@BuiltValue()
abstract class EntryIllustrationInputEntry implements Built<EntryIllustrationInputEntry, EntryIllustrationInputEntryBuilder> {
  /// Id of the card reference to switch this model to. Must be another card reference of the same profile (a different illustration of the same model); the request is rejected otherwise. 
  @BuiltValueField(wireName: r'entry_id')
  int get entryId;

  EntryIllustrationInputEntry._();

  factory EntryIllustrationInputEntry([void updates(EntryIllustrationInputEntryBuilder b)]) = _$EntryIllustrationInputEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryIllustrationInputEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryIllustrationInputEntry> get serializer => _$EntryIllustrationInputEntrySerializer();
}

class _$EntryIllustrationInputEntrySerializer implements PrimitiveSerializer<EntryIllustrationInputEntry> {
  @override
  final Iterable<Type> types = const [EntryIllustrationInputEntry, _$EntryIllustrationInputEntry];

  @override
  final String wireName = r'EntryIllustrationInputEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryIllustrationInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entry_id';
    yield serializers.serialize(
      object.entryId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryIllustrationInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EntryIllustrationInputEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entry_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.entryId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EntryIllustrationInputEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryIllustrationInputEntryBuilder();
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

