//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'select_gang_input.g.dart';

/// SelectGangInput
///
/// Properties:
/// * [listId]
@BuiltValue()
abstract class SelectGangInput
    implements Built<SelectGangInput, SelectGangInputBuilder> {
  @BuiltValueField(wireName: r'list_id')
  int get listId;

  SelectGangInput._();

  factory SelectGangInput([void updates(SelectGangInputBuilder b)]) =
      _$SelectGangInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SelectGangInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SelectGangInput> get serializer =>
      _$SelectGangInputSerializer();
}

class _$SelectGangInputSerializer
    implements PrimitiveSerializer<SelectGangInput> {
  @override
  final Iterable<Type> types = const [SelectGangInput, _$SelectGangInput];

  @override
  final String wireName = r'SelectGangInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SelectGangInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'list_id';
    yield serializers.serialize(
      object.listId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SelectGangInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SelectGangInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'list_id':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.listId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SelectGangInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SelectGangInputBuilder();
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
