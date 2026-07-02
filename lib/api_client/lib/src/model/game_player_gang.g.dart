// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_player_gang.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GamePlayerGang extends GamePlayerGang {
  @override
  final int id;
  @override
  final String? name;
  @override
  final String faction;
  @override
  final int points;
  @override
  final int totalCost;

  factory _$GamePlayerGang([void Function(GamePlayerGangBuilder)? updates]) =>
      (GamePlayerGangBuilder()..update(updates))._build();

  _$GamePlayerGang._({
    required this.id,
    this.name,
    required this.faction,
    required this.points,
    required this.totalCost,
  }) : super._();
  @override
  GamePlayerGang rebuild(void Function(GamePlayerGangBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GamePlayerGangBuilder toBuilder() => GamePlayerGangBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GamePlayerGang &&
        id == other.id &&
        name == other.name &&
        faction == other.faction &&
        points == other.points &&
        totalCost == other.totalCost;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, faction.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, totalCost.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GamePlayerGang')
          ..add('id', id)
          ..add('name', name)
          ..add('faction', faction)
          ..add('points', points)
          ..add('totalCost', totalCost))
        .toString();
  }
}

class GamePlayerGangBuilder
    implements Builder<GamePlayerGang, GamePlayerGangBuilder> {
  _$GamePlayerGang? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _faction;
  String? get faction => _$this._faction;
  set faction(String? faction) => _$this._faction = faction;

  int? _points;
  int? get points => _$this._points;
  set points(int? points) => _$this._points = points;

  int? _totalCost;
  int? get totalCost => _$this._totalCost;
  set totalCost(int? totalCost) => _$this._totalCost = totalCost;

  GamePlayerGangBuilder() {
    GamePlayerGang._defaults(this);
  }

  GamePlayerGangBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _faction = $v.faction;
      _points = $v.points;
      _totalCost = $v.totalCost;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GamePlayerGang other) {
    _$v = other as _$GamePlayerGang;
  }

  @override
  void update(void Function(GamePlayerGangBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GamePlayerGang build() => _build();

  _$GamePlayerGang _build() {
    final _$result =
        _$v ??
        _$GamePlayerGang._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'GamePlayerGang',
            'id',
          ),
          name: name,
          faction: BuiltValueNullFieldError.checkNotNull(
            faction,
            r'GamePlayerGang',
            'faction',
          ),
          points: BuiltValueNullFieldError.checkNotNull(
            points,
            r'GamePlayerGang',
            'points',
          ),
          totalCost: BuiltValueNullFieldError.checkNotNull(
            totalCost,
            r'GamePlayerGang',
            'totalCost',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
