//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game_player_gang.g.dart';

/// GamePlayerGang
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [faction] 
/// * [points] 
/// * [totalCost] 
@BuiltValue()
abstract class GamePlayerGang implements Built<GamePlayerGang, GamePlayerGangBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'faction')
  String get faction;

  @BuiltValueField(wireName: r'points')
  int get points;

  @BuiltValueField(wireName: r'total_cost')
  int get totalCost;

  GamePlayerGang._();

  factory GamePlayerGang([void updates(GamePlayerGangBuilder b)]) = _$GamePlayerGang;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GamePlayerGangBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GamePlayerGang> get serializer => _$GamePlayerGangSerializer();
}

class _$GamePlayerGangSerializer implements PrimitiveSerializer<GamePlayerGang> {
  @override
  final Iterable<Type> types = const [GamePlayerGang, _$GamePlayerGang];

  @override
  final String wireName = r'GamePlayerGang';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GamePlayerGang object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'faction';
    yield serializers.serialize(
      object.faction,
      specifiedType: const FullType(String),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(int),
    );
    yield r'total_cost';
    yield serializers.serialize(
      object.totalCost,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GamePlayerGang object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GamePlayerGangBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'total_cost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalCost = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GamePlayerGang deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GamePlayerGangBuilder();
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

