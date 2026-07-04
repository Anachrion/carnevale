//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_entry.g.dart';

/// ListEntry
///
/// Properties:
/// * [id] 
/// * [position] 
/// * [entryType] 
/// * [entryId] 
/// * [name] 
/// * [cost] 
@BuiltValue()
abstract class ListEntry implements Built<ListEntry, ListEntryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'entry_type')
  ListEntryEntryTypeEnum get entryType;
  // enum entryTypeEnum {  Catalog::CardReference,  Catalog::Equipment,  };

  @BuiltValueField(wireName: r'entry_id')
  int get entryId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'cost')
  int get cost;

  ListEntry._();

  factory ListEntry([void updates(ListEntryBuilder b)]) = _$ListEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListEntry> get serializer => _$ListEntrySerializer();
}

class _$ListEntrySerializer implements PrimitiveSerializer<ListEntry> {
  @override
  final Iterable<Type> types = const [ListEntry, _$ListEntry];

  @override
  final String wireName = r'ListEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'entry_type';
    yield serializers.serialize(
      object.entryType,
      specifiedType: const FullType(ListEntryEntryTypeEnum),
    );
    yield r'entry_id';
    yield serializers.serialize(
      object.entryId,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'cost';
    yield serializers.serialize(
      object.cost,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.position = valueDes;
          break;
        case r'entry_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListEntryEntryTypeEnum),
          ) as ListEntryEntryTypeEnum;
          result.entryType = valueDes;
          break;
        case r'entry_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.entryId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'cost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cost = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListEntryBuilder();
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

class ListEntryEntryTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Catalog::CardReference')
  static const ListEntryEntryTypeEnum catalogColonColonCardReference = _$listEntryEntryTypeEnum_catalogColonColonCardReference;
  @BuiltValueEnumConst(wireName: r'Catalog::Equipment')
  static const ListEntryEntryTypeEnum catalogColonColonEquipment = _$listEntryEntryTypeEnum_catalogColonColonEquipment;

  static Serializer<ListEntryEntryTypeEnum> get serializer => _$listEntryEntryTypeEnumSerializer;

  const ListEntryEntryTypeEnum._(String name): super(name);

  static BuiltSet<ListEntryEntryTypeEnum> get values => _$listEntryEntryTypeEnumValues;
  static ListEntryEntryTypeEnum valueOf(String name) => _$listEntryEntryTypeEnumValueOf(name);
}

