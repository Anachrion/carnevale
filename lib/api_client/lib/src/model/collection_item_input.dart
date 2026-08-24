//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/collection_item_input_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'collection_item_input.g.dart';

/// CollectionItemInput
///
/// Properties:
/// * [item] 
@BuiltValue()
abstract class CollectionItemInput implements Built<CollectionItemInput, CollectionItemInputBuilder> {
  @BuiltValueField(wireName: r'item')
  CollectionItemInputItem get item;

  CollectionItemInput._();

  factory CollectionItemInput([void updates(CollectionItemInputBuilder b)]) = _$CollectionItemInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CollectionItemInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CollectionItemInput> get serializer => _$CollectionItemInputSerializer();
}

class _$CollectionItemInputSerializer implements PrimitiveSerializer<CollectionItemInput> {
  @override
  final Iterable<Type> types = const [CollectionItemInput, _$CollectionItemInput];

  @override
  final String wireName = r'CollectionItemInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CollectionItemInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'item';
    yield serializers.serialize(
      object.item,
      specifiedType: const FullType(CollectionItemInputItem),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CollectionItemInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CollectionItemInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CollectionItemInputItem),
          ) as CollectionItemInputItem;
          result.item.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CollectionItemInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CollectionItemInputBuilder();
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

