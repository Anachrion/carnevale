//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'spell_rule_ref.g.dart';

/// SpellRuleRef
///
/// Properties:
/// * [name] 
/// * [description] 
@BuiltValue()
abstract class SpellRuleRef implements Built<SpellRuleRef, SpellRuleRefBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String get description;

  SpellRuleRef._();

  factory SpellRuleRef([void updates(SpellRuleRefBuilder b)]) = _$SpellRuleRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SpellRuleRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SpellRuleRef> get serializer => _$SpellRuleRefSerializer();
}

class _$SpellRuleRefSerializer implements PrimitiveSerializer<SpellRuleRef> {
  @override
  final Iterable<Type> types = const [SpellRuleRef, _$SpellRuleRef];

  @override
  final String wireName = r'SpellRuleRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SpellRuleRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SpellRuleRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SpellRuleRefBuilder result,
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SpellRuleRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SpellRuleRefBuilder();
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

