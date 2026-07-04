//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/agenda.dart';
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/gang_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game_player.g.dart';

/// GamePlayer
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [username] 
/// * [host] 
/// * [list] 
/// * [role] 
/// * [deploymentZone] 
/// * [ready] 
/// * [wonRoleRoll] - True for the role roll-off winner (asymmetric scenarios only). Picked at random as soon as the second player joins.
/// * [wonDeploymentRoll] - True for the deployment roll-off winner. Picked at random as soon as the second player joins.
/// * [agendas] - Only populated for the requesting player's own entry — always empty for the opponent's.
@BuiltValue()
abstract class GamePlayer implements Built<GamePlayer, GamePlayerBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'host')
  bool get host;

  @BuiltValueField(wireName: r'list')
  GangSummary? get list;

  @BuiltValueField(wireName: r'role')
  GamePlayerRoleEnum? get role;
  // enum roleEnum {  attacker,  defender,  };

  @BuiltValueField(wireName: r'deployment_zone')
  GamePlayerDeploymentZoneEnum? get deploymentZone;
  // enum deploymentZoneEnum {  A,  B,  };

  @BuiltValueField(wireName: r'ready')
  bool get ready;

  /// True for the role roll-off winner (asymmetric scenarios only). Picked at random as soon as the second player joins.
  @BuiltValueField(wireName: r'won_role_roll')
  bool get wonRoleRoll;

  /// True for the deployment roll-off winner. Picked at random as soon as the second player joins.
  @BuiltValueField(wireName: r'won_deployment_roll')
  bool get wonDeploymentRoll;

  /// Only populated for the requesting player's own entry — always empty for the opponent's.
  @BuiltValueField(wireName: r'agendas')
  BuiltList<Agenda> get agendas;

  GamePlayer._();

  factory GamePlayer([void updates(GamePlayerBuilder b)]) = _$GamePlayer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GamePlayerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GamePlayer> get serializer => _$GamePlayerSerializer();
}

class _$GamePlayerSerializer implements PrimitiveSerializer<GamePlayer> {
  @override
  final Iterable<Type> types = const [GamePlayer, _$GamePlayer];

  @override
  final String wireName = r'GamePlayer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GamePlayer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'host';
    yield serializers.serialize(
      object.host,
      specifiedType: const FullType(bool),
    );
    yield r'list';
    yield object.list == null ? null : serializers.serialize(
      object.list,
      specifiedType: const FullType.nullable(GangSummary),
    );
    yield r'role';
    yield object.role == null ? null : serializers.serialize(
      object.role,
      specifiedType: const FullType.nullable(GamePlayerRoleEnum),
    );
    yield r'deployment_zone';
    yield object.deploymentZone == null ? null : serializers.serialize(
      object.deploymentZone,
      specifiedType: const FullType.nullable(GamePlayerDeploymentZoneEnum),
    );
    yield r'ready';
    yield serializers.serialize(
      object.ready,
      specifiedType: const FullType(bool),
    );
    yield r'won_role_roll';
    yield serializers.serialize(
      object.wonRoleRoll,
      specifiedType: const FullType(bool),
    );
    yield r'won_deployment_roll';
    yield serializers.serialize(
      object.wonDeploymentRoll,
      specifiedType: const FullType(bool),
    );
    yield r'agendas';
    yield serializers.serialize(
      object.agendas,
      specifiedType: const FullType(BuiltList, [FullType(Agenda)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GamePlayer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GamePlayerBuilder result,
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
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'host':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.host = valueDes;
          break;
        case r'list':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GangSummary),
          ) as GangSummary?;
          if (valueDes == null) continue;
          result.list.replace(valueDes);
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GamePlayerRoleEnum),
          ) as GamePlayerRoleEnum?;
          if (valueDes == null) continue;
          result.role = valueDes;
          break;
        case r'deployment_zone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GamePlayerDeploymentZoneEnum),
          ) as GamePlayerDeploymentZoneEnum?;
          if (valueDes == null) continue;
          result.deploymentZone = valueDes;
          break;
        case r'ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ready = valueDes;
          break;
        case r'won_role_roll':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.wonRoleRoll = valueDes;
          break;
        case r'won_deployment_roll':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.wonDeploymentRoll = valueDes;
          break;
        case r'agendas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Agenda)]),
          ) as BuiltList<Agenda>;
          result.agendas.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GamePlayer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GamePlayerBuilder();
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

class GamePlayerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'attacker')
  static const GamePlayerRoleEnum attacker = _$gamePlayerRoleEnum_attacker;
  @BuiltValueEnumConst(wireName: r'defender')
  static const GamePlayerRoleEnum defender = _$gamePlayerRoleEnum_defender;

  static Serializer<GamePlayerRoleEnum> get serializer => _$gamePlayerRoleEnumSerializer;

  const GamePlayerRoleEnum._(String name): super(name);

  static BuiltSet<GamePlayerRoleEnum> get values => _$gamePlayerRoleEnumValues;
  static GamePlayerRoleEnum valueOf(String name) => _$gamePlayerRoleEnumValueOf(name);
}

class GamePlayerDeploymentZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'A')
  static const GamePlayerDeploymentZoneEnum A = _$gamePlayerDeploymentZoneEnum_A;
  @BuiltValueEnumConst(wireName: r'B')
  static const GamePlayerDeploymentZoneEnum B = _$gamePlayerDeploymentZoneEnum_B;

  static Serializer<GamePlayerDeploymentZoneEnum> get serializer => _$gamePlayerDeploymentZoneEnumSerializer;

  const GamePlayerDeploymentZoneEnum._(String name): super(name);

  static BuiltSet<GamePlayerDeploymentZoneEnum> get values => _$gamePlayerDeploymentZoneEnumValues;
  static GamePlayerDeploymentZoneEnum valueOf(String name) => _$gamePlayerDeploymentZoneEnumValueOf(name);
}

