// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GameStatusEnum _$gameStatusEnum_pending = const GameStatusEnum._(
  'pending',
);
const GameStatusEnum _$gameStatusEnum_gangSelection = const GameStatusEnum._(
  'gangSelection',
);
const GameStatusEnum _$gameStatusEnum_agendaDraw = const GameStatusEnum._(
  'agendaDraw',
);
const GameStatusEnum _$gameStatusEnum_inProgress = const GameStatusEnum._(
  'inProgress',
);
const GameStatusEnum _$gameStatusEnum_completed = const GameStatusEnum._(
  'completed',
);

GameStatusEnum _$gameStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$gameStatusEnum_pending;
    case 'gangSelection':
      return _$gameStatusEnum_gangSelection;
    case 'agendaDraw':
      return _$gameStatusEnum_agendaDraw;
    case 'inProgress':
      return _$gameStatusEnum_inProgress;
    case 'completed':
      return _$gameStatusEnum_completed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GameStatusEnum> _$gameStatusEnumValues =
    BuiltSet<GameStatusEnum>(const <GameStatusEnum>[
      _$gameStatusEnum_pending,
      _$gameStatusEnum_gangSelection,
      _$gameStatusEnum_agendaDraw,
      _$gameStatusEnum_inProgress,
      _$gameStatusEnum_completed,
    ]);

const GameViewerVisibilityEnum _$gameViewerVisibilityEnum_active =
    const GameViewerVisibilityEnum._('active');
const GameViewerVisibilityEnum _$gameViewerVisibilityEnum_archived =
    const GameViewerVisibilityEnum._('archived');
const GameViewerVisibilityEnum _$gameViewerVisibilityEnum_deleted =
    const GameViewerVisibilityEnum._('deleted');

GameViewerVisibilityEnum _$gameViewerVisibilityEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$gameViewerVisibilityEnum_active;
    case 'archived':
      return _$gameViewerVisibilityEnum_archived;
    case 'deleted':
      return _$gameViewerVisibilityEnum_deleted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GameViewerVisibilityEnum> _$gameViewerVisibilityEnumValues =
    BuiltSet<GameViewerVisibilityEnum>(const <GameViewerVisibilityEnum>[
      _$gameViewerVisibilityEnum_active,
      _$gameViewerVisibilityEnum_archived,
      _$gameViewerVisibilityEnum_deleted,
    ]);

Serializer<GameStatusEnum> _$gameStatusEnumSerializer =
    _$GameStatusEnumSerializer();
Serializer<GameViewerVisibilityEnum> _$gameViewerVisibilityEnumSerializer =
    _$GameViewerVisibilityEnumSerializer();

class _$GameStatusEnumSerializer
    implements PrimitiveSerializer<GameStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'gangSelection': 'gang_selection',
    'agendaDraw': 'agenda_draw',
    'inProgress': 'in_progress',
    'completed': 'completed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'gang_selection': 'gangSelection',
    'agenda_draw': 'agendaDraw',
    'in_progress': 'inProgress',
    'completed': 'completed',
  };

  @override
  final Iterable<Type> types = const <Type>[GameStatusEnum];
  @override
  final String wireName = 'GameStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    GameStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  GameStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => GameStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$GameViewerVisibilityEnumSerializer
    implements PrimitiveSerializer<GameViewerVisibilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'archived': 'archived',
    'deleted': 'deleted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'archived': 'archived',
    'deleted': 'deleted',
  };

  @override
  final Iterable<Type> types = const <Type>[GameViewerVisibilityEnum];
  @override
  final String wireName = 'GameViewerVisibilityEnum';

  @override
  Object serialize(
    Serializers serializers,
    GameViewerVisibilityEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  GameViewerVisibilityEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => GameViewerVisibilityEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Game extends Game {
  @override
  final int id;
  @override
  final int stateVersion;
  @override
  final String name;
  @override
  final String joinCode;
  @override
  final GameStatusEnum status;
  @override
  final int ducatLimit;
  @override
  final String? boardSize;
  @override
  final Scenario scenario;
  @override
  final GameViewerVisibilityEnum viewerVisibility;
  @override
  final BuiltList<GamePlayer> players;

  factory _$Game([void Function(GameBuilder)? updates]) =>
      (GameBuilder()..update(updates))._build();

  _$Game._({
    required this.id,
    required this.stateVersion,
    required this.name,
    required this.joinCode,
    required this.status,
    required this.ducatLimit,
    this.boardSize,
    required this.scenario,
    required this.viewerVisibility,
    required this.players,
  }) : super._();
  @override
  Game rebuild(void Function(GameBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameBuilder toBuilder() => GameBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Game &&
        id == other.id &&
        stateVersion == other.stateVersion &&
        name == other.name &&
        joinCode == other.joinCode &&
        status == other.status &&
        ducatLimit == other.ducatLimit &&
        boardSize == other.boardSize &&
        scenario == other.scenario &&
        viewerVisibility == other.viewerVisibility &&
        players == other.players;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, stateVersion.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, joinCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, ducatLimit.hashCode);
    _$hash = $jc(_$hash, boardSize.hashCode);
    _$hash = $jc(_$hash, scenario.hashCode);
    _$hash = $jc(_$hash, viewerVisibility.hashCode);
    _$hash = $jc(_$hash, players.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Game')
          ..add('id', id)
          ..add('stateVersion', stateVersion)
          ..add('name', name)
          ..add('joinCode', joinCode)
          ..add('status', status)
          ..add('ducatLimit', ducatLimit)
          ..add('boardSize', boardSize)
          ..add('scenario', scenario)
          ..add('viewerVisibility', viewerVisibility)
          ..add('players', players))
        .toString();
  }
}

class GameBuilder implements Builder<Game, GameBuilder> {
  _$Game? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _stateVersion;
  int? get stateVersion => _$this._stateVersion;
  set stateVersion(int? stateVersion) => _$this._stateVersion = stateVersion;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _joinCode;
  String? get joinCode => _$this._joinCode;
  set joinCode(String? joinCode) => _$this._joinCode = joinCode;

  GameStatusEnum? _status;
  GameStatusEnum? get status => _$this._status;
  set status(GameStatusEnum? status) => _$this._status = status;

  int? _ducatLimit;
  int? get ducatLimit => _$this._ducatLimit;
  set ducatLimit(int? ducatLimit) => _$this._ducatLimit = ducatLimit;

  String? _boardSize;
  String? get boardSize => _$this._boardSize;
  set boardSize(String? boardSize) => _$this._boardSize = boardSize;

  ScenarioBuilder? _scenario;
  ScenarioBuilder get scenario => _$this._scenario ??= ScenarioBuilder();
  set scenario(ScenarioBuilder? scenario) => _$this._scenario = scenario;

  GameViewerVisibilityEnum? _viewerVisibility;
  GameViewerVisibilityEnum? get viewerVisibility => _$this._viewerVisibility;
  set viewerVisibility(GameViewerVisibilityEnum? viewerVisibility) =>
      _$this._viewerVisibility = viewerVisibility;

  ListBuilder<GamePlayer>? _players;
  ListBuilder<GamePlayer> get players =>
      _$this._players ??= ListBuilder<GamePlayer>();
  set players(ListBuilder<GamePlayer>? players) => _$this._players = players;

  GameBuilder() {
    Game._defaults(this);
  }

  GameBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _stateVersion = $v.stateVersion;
      _name = $v.name;
      _joinCode = $v.joinCode;
      _status = $v.status;
      _ducatLimit = $v.ducatLimit;
      _boardSize = $v.boardSize;
      _scenario = $v.scenario.toBuilder();
      _viewerVisibility = $v.viewerVisibility;
      _players = $v.players.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Game other) {
    _$v = other as _$Game;
  }

  @override
  void update(void Function(GameBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Game build() => _build();

  _$Game _build() {
    _$Game _$result;
    try {
      _$result =
          _$v ??
          _$Game._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Game', 'id'),
            stateVersion: BuiltValueNullFieldError.checkNotNull(
              stateVersion,
              r'Game',
              'stateVersion',
            ),
            name: BuiltValueNullFieldError.checkNotNull(name, r'Game', 'name'),
            joinCode: BuiltValueNullFieldError.checkNotNull(
              joinCode,
              r'Game',
              'joinCode',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'Game',
              'status',
            ),
            ducatLimit: BuiltValueNullFieldError.checkNotNull(
              ducatLimit,
              r'Game',
              'ducatLimit',
            ),
            boardSize: boardSize,
            scenario: scenario.build(),
            viewerVisibility: BuiltValueNullFieldError.checkNotNull(
              viewerVisibility,
              r'Game',
              'viewerVisibility',
            ),
            players: players.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scenario';
        scenario.build();

        _$failedField = 'players';
        players.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Game', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
