//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_input_list.g.dart';

/// ListInputList
///
/// Properties:
/// * [name] 
/// * [faction] 
/// * [points] 
@BuiltValue()
abstract class ListInputList implements Built<ListInputList, ListInputListBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'faction')
  String get faction;

  @BuiltValueField(wireName: r'points')
  int? get points;

  ListInputList._();

  factory ListInputList([void updates(ListInputListBuilder b)]) = _$ListInputList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListInputListBuilder b) => b
      ..points = 100;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListInputList> get serializer => _$ListInputListSerializer();
}

class _$ListInputListSerializer implements PrimitiveSerializer<ListInputList> {
  @override
  final Iterable<Type> types = const [ListInputList, _$ListInputList];

  @override
  final String wireName = r'ListInputList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListInputList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'faction';
    yield serializers.serialize(
      object.faction,
      specifiedType: const FullType(String),
    );
    if (object.points != null) {
      yield r'points';
      yield serializers.serialize(
        object.points,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ListInputList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListInputListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'faction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.faction = valueDes;
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.points = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListInputList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListInputListBuilder();
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

