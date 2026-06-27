//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/list_input_list.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_input.g.dart';

/// ListInput
///
/// Properties:
/// * [list] 
@BuiltValue()
abstract class ListInput implements Built<ListInput, ListInputBuilder> {
  @BuiltValueField(wireName: r'list')
  ListInputList get list;

  ListInput._();

  factory ListInput([void updates(ListInputBuilder b)]) = _$ListInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListInput> get serializer => _$ListInputSerializer();
}

class _$ListInputSerializer implements PrimitiveSerializer<ListInput> {
  @override
  final Iterable<Type> types = const [ListInput, _$ListInput];

  @override
  final String wireName = r'ListInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'list';
    yield serializers.serialize(
      object.list,
      specifiedType: const FullType(ListInputList),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'list':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListInputList),
          ) as ListInputList;
          result.list.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListInputBuilder();
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

