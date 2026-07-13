//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_stat_value.g.dart';

/// EntryStatValue
///
/// Properties:
/// * [current] 
/// * [starting] 
@BuiltValue()
abstract class EntryStatValue implements Built<EntryStatValue, EntryStatValueBuilder> {
  @BuiltValueField(wireName: r'current')
  int get current;

  @BuiltValueField(wireName: r'starting')
  int get starting;

  EntryStatValue._();

  factory EntryStatValue([void updates(EntryStatValueBuilder b)]) = _$EntryStatValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryStatValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryStatValue> get serializer => _$EntryStatValueSerializer();
}

class _$EntryStatValueSerializer implements PrimitiveSerializer<EntryStatValue> {
  @override
  final Iterable<Type> types = const [EntryStatValue, _$EntryStatValue];

  @override
  final String wireName = r'EntryStatValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryStatValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(int),
    );
    yield r'starting';
    yield serializers.serialize(
      object.starting,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryStatValue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EntryStatValueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.current = valueDes;
          break;
        case r'starting':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.starting = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EntryStatValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryStatValueBuilder();
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

