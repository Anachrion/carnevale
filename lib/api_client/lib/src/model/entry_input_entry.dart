//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_input_entry.g.dart';

/// EntryInputEntry
///
/// Properties:
/// * [listId] 
/// * [entryType] 
/// * [entryId] 
@BuiltValue()
abstract class EntryInputEntry implements Built<EntryInputEntry, EntryInputEntryBuilder> {
  @BuiltValueField(wireName: r'list_id')
  int get listId;

  @BuiltValueField(wireName: r'entry_type')
  EntryInputEntryEntryTypeEnum get entryType;
  // enum entryTypeEnum {  CardReference,  Equipment,  };

  @BuiltValueField(wireName: r'entry_id')
  int get entryId;

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
    yield r'entry_type';
    yield serializers.serialize(
      object.entryType,
      specifiedType: const FullType(EntryInputEntryEntryTypeEnum),
    );
    yield r'entry_id';
    yield serializers.serialize(
      object.entryId,
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
        case r'entry_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EntryInputEntryEntryTypeEnum),
          ) as EntryInputEntryEntryTypeEnum;
          result.entryType = valueDes;
          break;
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

class EntryInputEntryEntryTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CardReference')
  static const EntryInputEntryEntryTypeEnum cardReference = _$entryInputEntryEntryTypeEnum_cardReference;
  @BuiltValueEnumConst(wireName: r'Equipment')
  static const EntryInputEntryEntryTypeEnum equipment = _$entryInputEntryEntryTypeEnum_equipment;

  static Serializer<EntryInputEntryEntryTypeEnum> get serializer => _$entryInputEntryEntryTypeEnumSerializer;

  const EntryInputEntryEntryTypeEnum._(String name): super(name);

  static BuiltSet<EntryInputEntryEntryTypeEnum> get values => _$entryInputEntryEntryTypeEnumValues;
  static EntryInputEntryEntryTypeEnum valueOf(String name) => _$entryInputEntryEntryTypeEnumValueOf(name);
}

