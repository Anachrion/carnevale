//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'collection_bulk_input_items_inner.g.dart';

/// CollectionBulkInputItemsInner
///
/// Properties:
/// * [profileId] 
/// * [owned] 
/// * [built] 
/// * [painted] 
@BuiltValue()
abstract class CollectionBulkInputItemsInner implements Built<CollectionBulkInputItemsInner, CollectionBulkInputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'profile_id')
  int get profileId;

  @BuiltValueField(wireName: r'owned')
  int? get owned;

  @BuiltValueField(wireName: r'built')
  int? get built;

  @BuiltValueField(wireName: r'painted')
  int? get painted;

  CollectionBulkInputItemsInner._();

  factory CollectionBulkInputItemsInner([void updates(CollectionBulkInputItemsInnerBuilder b)]) = _$CollectionBulkInputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CollectionBulkInputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CollectionBulkInputItemsInner> get serializer => _$CollectionBulkInputItemsInnerSerializer();
}

class _$CollectionBulkInputItemsInnerSerializer implements PrimitiveSerializer<CollectionBulkInputItemsInner> {
  @override
  final Iterable<Type> types = const [CollectionBulkInputItemsInner, _$CollectionBulkInputItemsInner];

  @override
  final String wireName = r'CollectionBulkInputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CollectionBulkInputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'profile_id';
    yield serializers.serialize(
      object.profileId,
      specifiedType: const FullType(int),
    );
    if (object.owned != null) {
      yield r'owned';
      yield serializers.serialize(
        object.owned,
        specifiedType: const FullType(int),
      );
    }
    if (object.built != null) {
      yield r'built';
      yield serializers.serialize(
        object.built,
        specifiedType: const FullType(int),
      );
    }
    if (object.painted != null) {
      yield r'painted';
      yield serializers.serialize(
        object.painted,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CollectionBulkInputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CollectionBulkInputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'profile_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.profileId = valueDes;
          break;
        case r'owned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.owned = valueDes;
          break;
        case r'built':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.built = valueDes;
          break;
        case r'painted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.painted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CollectionBulkInputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CollectionBulkInputItemsInnerBuilder();
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

