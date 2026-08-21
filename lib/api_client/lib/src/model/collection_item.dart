//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'collection_item.g.dart';

/// How many miniatures of one catalog profile a player has, and how far along they are. The counts nest: every painted miniature is also built, and every built one is also owned. 
///
/// Properties:
/// * [profileId] 
/// * [owned] 
/// * [built] 
/// * [painted] 
@BuiltValue()
abstract class CollectionItem implements Built<CollectionItem, CollectionItemBuilder> {
  @BuiltValueField(wireName: r'profile_id')
  int get profileId;

  @BuiltValueField(wireName: r'owned')
  int get owned;

  @BuiltValueField(wireName: r'built')
  int get built;

  @BuiltValueField(wireName: r'painted')
  int get painted;

  CollectionItem._();

  factory CollectionItem([void updates(CollectionItemBuilder b)]) = _$CollectionItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CollectionItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CollectionItem> get serializer => _$CollectionItemSerializer();
}

class _$CollectionItemSerializer implements PrimitiveSerializer<CollectionItem> {
  @override
  final Iterable<Type> types = const [CollectionItem, _$CollectionItem];

  @override
  final String wireName = r'CollectionItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CollectionItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'profile_id';
    yield serializers.serialize(
      object.profileId,
      specifiedType: const FullType(int),
    );
    yield r'owned';
    yield serializers.serialize(
      object.owned,
      specifiedType: const FullType(int),
    );
    yield r'built';
    yield serializers.serialize(
      object.built,
      specifiedType: const FullType(int),
    );
    yield r'painted';
    yield serializers.serialize(
      object.painted,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CollectionItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CollectionItemBuilder result,
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
  CollectionItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CollectionItemBuilder();
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

