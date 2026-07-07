// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_player.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GamePlayerRoleEnum _$gamePlayerRoleEnum_attacker =
    const GamePlayerRoleEnum._('attacker');
const GamePlayerRoleEnum _$gamePlayerRoleEnum_defender =
    const GamePlayerRoleEnum._('defender');

GamePlayerRoleEnum _$gamePlayerRoleEnumValueOf(String name) {
  switch (name) {
    case 'attacker':
      return _$gamePlayerRoleEnum_attacker;
    case 'defender':
      return _$gamePlayerRoleEnum_defender;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GamePlayerRoleEnum> _$gamePlayerRoleEnumValues =
    BuiltSet<GamePlayerRoleEnum>(const <GamePlayerRoleEnum>[
      _$gamePlayerRoleEnum_attacker,
      _$gamePlayerRoleEnum_defender,
    ]);

Serializer<GamePlayerRoleEnum> _$gamePlayerRoleEnumSerializer =
    _$GamePlayerRoleEnumSerializer();

class _$GamePlayerRoleEnumSerializer
    implements PrimitiveSerializer<GamePlayerRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'attacker': 'attacker',
    'defender': 'defender',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'attacker': 'attacker',
    'defender': 'defender',
  };

  @override
  final Iterable<Type> types = const <Type>[GamePlayerRoleEnum];
  @override
  final String wireName = 'GamePlayerRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    GamePlayerRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  GamePlayerRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => GamePlayerRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$GamePlayer extends GamePlayer {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String username;
  @override
  final bool host;
  @override
  final GangSummary? list;
  @override
  final GamePlayerRoleEnum? role;
  @override
  final bool agendasConfirmed;
  @override
  final bool wonRoleRoll;
  @override
  final bool wonDeploymentRoll;
  @override
  final int score;
  @override
  final int currentTurn;
  @override
  final bool finished;
  @override
  final BuiltList<Agenda> agendas;
  @override
  final BuiltList<AgendaHistoryEntry> agendaHistory;

  factory _$GamePlayer([void Function(GamePlayerBuilder)? updates]) =>
      (GamePlayerBuilder()..update(updates))._build();

  _$GamePlayer._({
    required this.id,
    required this.userId,
    required this.username,
    required this.host,
    this.list,
    this.role,
    required this.agendasConfirmed,
    required this.wonRoleRoll,
    required this.wonDeploymentRoll,
    required this.score,
    required this.currentTurn,
    required this.finished,
    required this.agendas,
    required this.agendaHistory,
  }) : super._();
  @override
  GamePlayer rebuild(void Function(GamePlayerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GamePlayerBuilder toBuilder() => GamePlayerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GamePlayer &&
        id == other.id &&
        userId == other.userId &&
        username == other.username &&
        host == other.host &&
        list == other.list &&
        role == other.role &&
        agendasConfirmed == other.agendasConfirmed &&
        wonRoleRoll == other.wonRoleRoll &&
        wonDeploymentRoll == other.wonDeploymentRoll &&
        score == other.score &&
        currentTurn == other.currentTurn &&
        finished == other.finished &&
        agendas == other.agendas &&
        agendaHistory == other.agendaHistory;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, host.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, agendasConfirmed.hashCode);
    _$hash = $jc(_$hash, wonRoleRoll.hashCode);
    _$hash = $jc(_$hash, wonDeploymentRoll.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, currentTurn.hashCode);
    _$hash = $jc(_$hash, finished.hashCode);
    _$hash = $jc(_$hash, agendas.hashCode);
    _$hash = $jc(_$hash, agendaHistory.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GamePlayer')
          ..add('id', id)
          ..add('userId', userId)
          ..add('username', username)
          ..add('host', host)
          ..add('list', list)
          ..add('role', role)
          ..add('agendasConfirmed', agendasConfirmed)
          ..add('wonRoleRoll', wonRoleRoll)
          ..add('wonDeploymentRoll', wonDeploymentRoll)
          ..add('score', score)
          ..add('currentTurn', currentTurn)
          ..add('finished', finished)
          ..add('agendas', agendas)
          ..add('agendaHistory', agendaHistory))
        .toString();
  }
}

class GamePlayerBuilder implements Builder<GamePlayer, GamePlayerBuilder> {
  _$GamePlayer? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  bool? _host;
  bool? get host => _$this._host;
  set host(bool? host) => _$this._host = host;

  GangSummaryBuilder? _list;
  GangSummaryBuilder get list => _$this._list ??= GangSummaryBuilder();
  set list(GangSummaryBuilder? list) => _$this._list = list;

  GamePlayerRoleEnum? _role;
  GamePlayerRoleEnum? get role => _$this._role;
  set role(GamePlayerRoleEnum? role) => _$this._role = role;

  bool? _agendasConfirmed;
  bool? get agendasConfirmed => _$this._agendasConfirmed;
  set agendasConfirmed(bool? agendasConfirmed) =>
      _$this._agendasConfirmed = agendasConfirmed;

  bool? _wonRoleRoll;
  bool? get wonRoleRoll => _$this._wonRoleRoll;
  set wonRoleRoll(bool? wonRoleRoll) => _$this._wonRoleRoll = wonRoleRoll;

  bool? _wonDeploymentRoll;
  bool? get wonDeploymentRoll => _$this._wonDeploymentRoll;
  set wonDeploymentRoll(bool? wonDeploymentRoll) =>
      _$this._wonDeploymentRoll = wonDeploymentRoll;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  int? _currentTurn;
  int? get currentTurn => _$this._currentTurn;
  set currentTurn(int? currentTurn) => _$this._currentTurn = currentTurn;

  bool? _finished;
  bool? get finished => _$this._finished;
  set finished(bool? finished) => _$this._finished = finished;

  ListBuilder<Agenda>? _agendas;
  ListBuilder<Agenda> get agendas => _$this._agendas ??= ListBuilder<Agenda>();
  set agendas(ListBuilder<Agenda>? agendas) => _$this._agendas = agendas;

  ListBuilder<AgendaHistoryEntry>? _agendaHistory;
  ListBuilder<AgendaHistoryEntry> get agendaHistory =>
      _$this._agendaHistory ??= ListBuilder<AgendaHistoryEntry>();
  set agendaHistory(ListBuilder<AgendaHistoryEntry>? agendaHistory) =>
      _$this._agendaHistory = agendaHistory;

  GamePlayerBuilder() {
    GamePlayer._defaults(this);
  }

  GamePlayerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _username = $v.username;
      _host = $v.host;
      _list = $v.list?.toBuilder();
      _role = $v.role;
      _agendasConfirmed = $v.agendasConfirmed;
      _wonRoleRoll = $v.wonRoleRoll;
      _wonDeploymentRoll = $v.wonDeploymentRoll;
      _score = $v.score;
      _currentTurn = $v.currentTurn;
      _finished = $v.finished;
      _agendas = $v.agendas.toBuilder();
      _agendaHistory = $v.agendaHistory.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GamePlayer other) {
    _$v = other as _$GamePlayer;
  }

  @override
  void update(void Function(GamePlayerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GamePlayer build() => _build();

  _$GamePlayer _build() {
    _$GamePlayer _$result;
    try {
      _$result =
          _$v ??
          _$GamePlayer._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'GamePlayer', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
              userId,
              r'GamePlayer',
              'userId',
            ),
            username: BuiltValueNullFieldError.checkNotNull(
              username,
              r'GamePlayer',
              'username',
            ),
            host: BuiltValueNullFieldError.checkNotNull(
              host,
              r'GamePlayer',
              'host',
            ),
            list: _list?.build(),
            role: role,
            agendasConfirmed: BuiltValueNullFieldError.checkNotNull(
              agendasConfirmed,
              r'GamePlayer',
              'agendasConfirmed',
            ),
            wonRoleRoll: BuiltValueNullFieldError.checkNotNull(
              wonRoleRoll,
              r'GamePlayer',
              'wonRoleRoll',
            ),
            wonDeploymentRoll: BuiltValueNullFieldError.checkNotNull(
              wonDeploymentRoll,
              r'GamePlayer',
              'wonDeploymentRoll',
            ),
            score: BuiltValueNullFieldError.checkNotNull(
              score,
              r'GamePlayer',
              'score',
            ),
            currentTurn: BuiltValueNullFieldError.checkNotNull(
              currentTurn,
              r'GamePlayer',
              'currentTurn',
            ),
            finished: BuiltValueNullFieldError.checkNotNull(
              finished,
              r'GamePlayer',
              'finished',
            ),
            agendas: agendas.build(),
            agendaHistory: agendaHistory.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'list';
        _list?.build();

        _$failedField = 'agendas';
        agendas.build();
        _$failedField = 'agendaHistory';
        agendaHistory.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GamePlayer',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
