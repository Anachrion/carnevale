//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/game_player.dart';
import 'package:carnevale_api/src/model/scenario.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game.g.dart';

/// Game
///
/// Properties:
/// * [id] 
/// * [stateVersion] - Monotonic counter for this game, bumped every time its state is broadcast. Present on every `Game` the API returns — broadcasts, mutation responses and GET /games/{id} alike.  Neither Action Cable delivery nor HTTP responses guarantee ordering, so a client must apply a snapshot only when this is greater than the one it is currently displaying, and drop it otherwise. Without that, a mutation response serialized before the opponent's change committed can land after the broadcast carrying it and silently revert the screen. Only comparable within one game — it is not a global clock. 
/// * [name] 
/// * [joinCode] 
/// * [status] - `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes.
/// * [ducatLimit] 
/// * [boardSize] 
/// * [scenario] 
/// * [viewerVisibility] - The requesting user's own archive/delete state for this game — never reflects the opponent's.
/// * [players] 
@BuiltValue()
abstract class Game implements Built<Game, GameBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  /// Monotonic counter for this game, bumped every time its state is broadcast. Present on every `Game` the API returns — broadcasts, mutation responses and GET /games/{id} alike.  Neither Action Cable delivery nor HTTP responses guarantee ordering, so a client must apply a snapshot only when this is greater than the one it is currently displaying, and drop it otherwise. Without that, a mutation response serialized before the opponent's change committed can land after the broadcast carrying it and silently revert the screen. Only comparable within one game — it is not a global clock. 
  @BuiltValueField(wireName: r'state_version')
  int get stateVersion;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'join_code')
  String get joinCode;

  /// `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes.
  @BuiltValueField(wireName: r'status')
  GameStatusEnum get status;
  // enum statusEnum {  pending,  gang_selection,  agenda_draw,  in_progress,  completed,  };

  @BuiltValueField(wireName: r'ducat_limit')
  int get ducatLimit;

  @BuiltValueField(wireName: r'board_size')
  String? get boardSize;

  @BuiltValueField(wireName: r'scenario')
  Scenario get scenario;

  /// The requesting user's own archive/delete state for this game — never reflects the opponent's.
  @BuiltValueField(wireName: r'viewer_visibility')
  GameViewerVisibilityEnum get viewerVisibility;
  // enum viewerVisibilityEnum {  active,  archived,  deleted,  };

  @BuiltValueField(wireName: r'players')
  BuiltList<GamePlayer> get players;

  Game._();

  factory Game([void updates(GameBuilder b)]) = _$Game;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GameBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Game> get serializer => _$GameSerializer();
}

class _$GameSerializer implements PrimitiveSerializer<Game> {
  @override
  final Iterable<Type> types = const [Game, _$Game];

  @override
  final String wireName = r'Game';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Game object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'state_version';
    yield serializers.serialize(
      object.stateVersion,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'join_code';
    yield serializers.serialize(
      object.joinCode,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(GameStatusEnum),
    );
    yield r'ducat_limit';
    yield serializers.serialize(
      object.ducatLimit,
      specifiedType: const FullType(int),
    );
    yield r'board_size';
    yield object.boardSize == null ? null : serializers.serialize(
      object.boardSize,
      specifiedType: const FullType.nullable(String),
    );
    yield r'scenario';
    yield serializers.serialize(
      object.scenario,
      specifiedType: const FullType(Scenario),
    );
    yield r'viewer_visibility';
    yield serializers.serialize(
      object.viewerVisibility,
      specifiedType: const FullType(GameViewerVisibilityEnum),
    );
    yield r'players';
    yield serializers.serialize(
      object.players,
      specifiedType: const FullType(BuiltList, [FullType(GamePlayer)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Game object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GameBuilder result,
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
        case r'state_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stateVersion = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'join_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.joinCode = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GameStatusEnum),
          ) as GameStatusEnum;
          result.status = valueDes;
          break;
        case r'ducat_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
        case r'scenario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Scenario),
          ) as Scenario;
          result.scenario.replace(valueDes);
          break;
        case r'viewer_visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GameViewerVisibilityEnum),
          ) as GameViewerVisibilityEnum;
          result.viewerVisibility = valueDes;
          break;
        case r'players':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GamePlayer)]),
          ) as BuiltList<GamePlayer>;
          result.players.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Game deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GameBuilder();
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

class GameStatusEnum extends EnumClass {

  /// `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes.
  @BuiltValueEnumConst(wireName: r'pending')
  static const GameStatusEnum pending = _$gameStatusEnum_pending;
  /// `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes.
  @BuiltValueEnumConst(wireName: r'gang_selection')
  static const GameStatusEnum gangSelection = _$gameStatusEnum_gangSelection;
  /// `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes.
  @BuiltValueEnumConst(wireName: r'agenda_draw')
  static const GameStatusEnum agendaDraw = _$gameStatusEnum_agendaDraw;
  /// `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes.
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const GameStatusEnum inProgress = _$gameStatusEnum_inProgress;
  /// `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes.
  @BuiltValueEnumConst(wireName: r'completed')
  static const GameStatusEnum completed = _$gameStatusEnum_completed;

  static Serializer<GameStatusEnum> get serializer => _$gameStatusEnumSerializer;

  const GameStatusEnum._(String name): super(name);

  static BuiltSet<GameStatusEnum> get values => _$gameStatusEnumValues;
  static GameStatusEnum valueOf(String name) => _$gameStatusEnumValueOf(name);
}

class GameViewerVisibilityEnum extends EnumClass {

  /// The requesting user's own archive/delete state for this game — never reflects the opponent's.
  @BuiltValueEnumConst(wireName: r'active')
  static const GameViewerVisibilityEnum active = _$gameViewerVisibilityEnum_active;
  /// The requesting user's own archive/delete state for this game — never reflects the opponent's.
  @BuiltValueEnumConst(wireName: r'archived')
  static const GameViewerVisibilityEnum archived = _$gameViewerVisibilityEnum_archived;
  /// The requesting user's own archive/delete state for this game — never reflects the opponent's.
  @BuiltValueEnumConst(wireName: r'deleted')
  static const GameViewerVisibilityEnum deleted = _$gameViewerVisibilityEnum_deleted;

  static Serializer<GameViewerVisibilityEnum> get serializer => _$gameViewerVisibilityEnumSerializer;

  const GameViewerVisibilityEnum._(String name): super(name);

  static BuiltSet<GameViewerVisibilityEnum> get values => _$gameViewerVisibilityEnumValues;
  static GameViewerVisibilityEnum valueOf(String name) => _$gameViewerVisibilityEnumValueOf(name);
}

