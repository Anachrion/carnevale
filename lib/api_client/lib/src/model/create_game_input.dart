//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_game_input.g.dart';

/// CreateGameInput
///
/// Properties:
/// * [scenarioId] 
/// * [name] - Defaults to the scenario's name if omitted.
/// * [ducatLimit] - Defaults to the scenario's ducats if omitted.
/// * [boardSize] 
@BuiltValue()
abstract class CreateGameInput implements Built<CreateGameInput, CreateGameInputBuilder> {
  @BuiltValueField(wireName: r'scenario_id')
  int get scenarioId;

  /// Defaults to the scenario's name if omitted.
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Defaults to the scenario's ducats if omitted.
  @BuiltValueField(wireName: r'ducat_limit')
  int? get ducatLimit;

  @BuiltValueField(wireName: r'board_size')
  String? get boardSize;

  CreateGameInput._();

  factory CreateGameInput([void updates(CreateGameInputBuilder b)]) = _$CreateGameInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateGameInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateGameInput> get serializer => _$CreateGameInputSerializer();
}

class _$CreateGameInputSerializer implements PrimitiveSerializer<CreateGameInput> {
  @override
  final Iterable<Type> types = const [CreateGameInput, _$CreateGameInput];

  @override
  final String wireName = r'CreateGameInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateGameInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scenario_id';
    yield serializers.serialize(
      object.scenarioId,
      specifiedType: const FullType(int),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.ducatLimit != null) {
      yield r'ducat_limit';
      yield serializers.serialize(
        object.ducatLimit,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.boardSize != null) {
      yield r'board_size';
      yield serializers.serialize(
        object.boardSize,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateGameInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateGameInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scenario_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.scenarioId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'ducat_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ducatLimit = valueDes;
          break;
        case r'board_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.boardSize = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateGameInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateGameInputBuilder();
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

