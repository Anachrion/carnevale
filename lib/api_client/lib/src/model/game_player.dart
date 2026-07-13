//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/agenda_history_entry.dart';
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
/// * [agendasConfirmed] - True once the player has confirmed their opening Agenda hand (agenda_draw phase). Both players confirming takes the game straight to in_progress.
/// * [wonRoleRoll] - True for the role roll-off winner (asymmetric scenarios only). Picked at random as soon as the second player joins.
/// * [wonDeploymentRoll] - True for the deployment roll-off winner. Picked at random as soon as the second player joins. Informational only — the deployment zone itself is chosen at the table, not in-app.
/// * [score] - Total Victory Points scored from Agendas so far (every Agenda scores a flat 1 VP). Always visible for both players.
/// * [currentTurn] - This player's own turn cursor (starts at 1). Rewindable via the turns/advance and turns/rewind endpoints; agenda events are stamped with whatever turn the player is pointed at. Independent of the opponent's.
/// * [finished] - Whether this player has ended the game from their side (see the finish/unfinish endpoints). When both players are finished the game's status derives to `completed`.
/// * [agendas] - This player's current hand. Always populated for the requesting player's own entry. For the opponent's entry it is populated too, unless the scenario has the `secret` agenda rule, in which case it is empty (the hand stays hidden until achieved).
/// * [agendaHistory] - Draw/score/discard events for this player, in turn order. Full history for the requesting player's own entry. For the opponent's entry under the `secret` rule it is trimmed to resolved events only (scored + discarded), so the hidden hand doesn't leak; otherwise it is the full history.
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

  /// True once the player has confirmed their opening Agenda hand (agenda_draw phase). Both players confirming takes the game straight to in_progress.
  @BuiltValueField(wireName: r'agendas_confirmed')
  bool get agendasConfirmed;

  /// True for the role roll-off winner (asymmetric scenarios only). Picked at random as soon as the second player joins.
  @BuiltValueField(wireName: r'won_role_roll')
  bool get wonRoleRoll;

  /// True for the deployment roll-off winner. Picked at random as soon as the second player joins. Informational only — the deployment zone itself is chosen at the table, not in-app.
  @BuiltValueField(wireName: r'won_deployment_roll')
  bool get wonDeploymentRoll;

  /// Total Victory Points scored from Agendas so far (every Agenda scores a flat 1 VP). Always visible for both players.
  @BuiltValueField(wireName: r'score')
  int get score;

  /// This player's own turn cursor (starts at 1). Rewindable via the turns/advance and turns/rewind endpoints; agenda events are stamped with whatever turn the player is pointed at. Independent of the opponent's.
  @BuiltValueField(wireName: r'current_turn')
  int get currentTurn;

  /// Whether this player has ended the game from their side (see the finish/unfinish endpoints). When both players are finished the game's status derives to `completed`.
  @BuiltValueField(wireName: r'finished')
  bool get finished;

  /// This player's current hand. Always populated for the requesting player's own entry. For the opponent's entry it is populated too, unless the scenario has the `secret` agenda rule, in which case it is empty (the hand stays hidden until achieved).
  @BuiltValueField(wireName: r'agendas')
  BuiltList<Agenda> get agendas;

  /// Draw/score/discard events for this player, in turn order. Full history for the requesting player's own entry. For the opponent's entry under the `secret` rule it is trimmed to resolved events only (scored + discarded), so the hidden hand doesn't leak; otherwise it is the full history.
  @BuiltValueField(wireName: r'agenda_history')
  BuiltList<AgendaHistoryEntry> get agendaHistory;

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
    yield r'agendas_confirmed';
    yield serializers.serialize(
      object.agendasConfirmed,
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
    yield r'score';
    yield serializers.serialize(
      object.score,
      specifiedType: const FullType(int),
    );
    yield r'current_turn';
    yield serializers.serialize(
      object.currentTurn,
      specifiedType: const FullType(int),
    );
    yield r'finished';
    yield serializers.serialize(
      object.finished,
      specifiedType: const FullType(bool),
    );
    yield r'agendas';
    yield serializers.serialize(
      object.agendas,
      specifiedType: const FullType(BuiltList, [FullType(Agenda)]),
    );
    yield r'agenda_history';
    yield serializers.serialize(
      object.agendaHistory,
      specifiedType: const FullType(BuiltList, [FullType(AgendaHistoryEntry)]),
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
        case r'agendas_confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.agendasConfirmed = valueDes;
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
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.score = valueDes;
          break;
        case r'current_turn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.currentTurn = valueDes;
          break;
        case r'finished':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.finished = valueDes;
          break;
        case r'agendas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Agenda)]),
          ) as BuiltList<Agenda>;
          result.agendas.replace(valueDes);
          break;
        case r'agenda_history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AgendaHistoryEntry)]),
          ) as BuiltList<AgendaHistoryEntry>;
          result.agendaHistory.replace(valueDes);
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

