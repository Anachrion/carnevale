//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'collection_item_input_item.g.dart';

/// Any subset of the three counts. Whatever is left out settles around what is sent. 
///
/// Properties:
/// * [owned] 
/// * [built] 
/// * [painted] 
@BuiltValue()
abstract class CollectionItemInputItem implements Built<CollectionItemInputItem, CollectionItemInputItemBuilder> {
  @BuiltValueField(wireName: r'owned')
  int? get owned;

  @BuiltValueField(wireName: r'built')
  int? get built;

  @BuiltValueField(wireName: r'painted')
  int? get painted;

  CollectionItemInputItem._();

  factory CollectionItemInputItem([void updates(CollectionItemInputItemBuilder b)]) = _$CollectionItemInputItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CollectionItemInputItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CollectionItemInputItem> get serializer => _$CollectionItemInputItemSerializer();
}

class _$CollectionItemInputItemSerializer implements PrimitiveSerializer<CollectionItemInputItem> {
  @override
  final Iterable<Type> types = const [CollectionItemInputItem, _$CollectionItemInputItem];

  @override
  final String wireName = r'CollectionItemInputItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CollectionItemInputItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    CollectionItemInputItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CollectionItemInputItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  CollectionItemInputItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CollectionItemInputItemBuilder();
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

