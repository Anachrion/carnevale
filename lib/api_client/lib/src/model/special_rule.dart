//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'special_rule.g.dart';

/// SpecialRule
///
/// Properties:
/// * [id]
/// * [name]
/// * [description]
/// * [spellName]
/// * [spellCost]
/// * [spellDifficulty]
/// * [spellDescription]
@BuiltValue()
abstract class SpecialRule implements Built<SpecialRule, SpecialRuleBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'spell_name')
  String? get spellName;

  @BuiltValueField(wireName: r'spell_cost')
  int? get spellCost;

  @BuiltValueField(wireName: r'spell_difficulty')
  int? get spellDifficulty;

  @BuiltValueField(wireName: r'spell_description')
  String? get spellDescription;

  SpecialRule._();

  factory SpecialRule([void updates(SpecialRuleBuilder b)]) = _$SpecialRule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SpecialRuleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SpecialRule> get serializer => _$SpecialRuleSerializer();
}

class _$SpecialRuleSerializer implements PrimitiveSerializer<SpecialRule> {
  @override
  final Iterable<Type> types = const [SpecialRule, _$SpecialRule];

  @override
  final String wireName = r'SpecialRule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SpecialRule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(object.id, specifiedType: const FullType(int));
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
    if (object.spellName != null) {
      yield r'spell_name';
      yield serializers.serialize(
        object.spellName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.spellCost != null) {
      yield r'spell_cost';
      yield serializers.serialize(
        object.spellCost,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.spellDifficulty != null) {
      yield r'spell_difficulty';
      yield serializers.serialize(
        object.spellDifficulty,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.spellDescription != null) {
      yield r'spell_description';
      yield serializers.serialize(
        object.spellDescription,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SpecialRule object, {
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
    required SpecialRuleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.description = valueDes;
          break;
        case r'spell_name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.spellName = valueDes;
          break;
        case r'spell_cost':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.spellCost = valueDes;
          break;
        case r'spell_difficulty':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.spellDifficulty = valueDes;
          break;
        case r'spell_description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.spellDescription = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SpecialRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SpecialRuleBuilder();
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
