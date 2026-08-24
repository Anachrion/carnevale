//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/collection_bulk_input_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'collection_bulk_input.g.dart';

/// CollectionBulkInput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class CollectionBulkInput implements Built<CollectionBulkInput, CollectionBulkInputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<CollectionBulkInputItemsInner> get items;

  CollectionBulkInput._();

  factory CollectionBulkInput([void updates(CollectionBulkInputBuilder b)]) = _$CollectionBulkInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CollectionBulkInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CollectionBulkInput> get serializer => _$CollectionBulkInputSerializer();
}

class _$CollectionBulkInputSerializer implements PrimitiveSerializer<CollectionBulkInput> {
  @override
  final Iterable<Type> types = const [CollectionBulkInput, _$CollectionBulkInput];

  @override
  final String wireName = r'CollectionBulkInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CollectionBulkInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CollectionBulkInputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CollectionBulkInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CollectionBulkInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CollectionBulkInputItemsInner)]),
          ) as BuiltList<CollectionBulkInputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CollectionBulkInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CollectionBulkInputBuilder();
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

