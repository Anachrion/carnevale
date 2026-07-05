// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_stats_input_stats.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateStatsInputStats extends UpdateStatsInputStats {
  @override
  final int? lifePoints;
  @override
  final int? willPoints;
  @override
  final int? commandPoints;

  factory _$UpdateStatsInputStats([
    void Function(UpdateStatsInputStatsBuilder)? updates,
  ]) => (UpdateStatsInputStatsBuilder()..update(updates))._build();

  _$UpdateStatsInputStats._({
    this.lifePoints,
    this.willPoints,
    this.commandPoints,
  }) : super._();
  @override
  UpdateStatsInputStats rebuild(
    void Function(UpdateStatsInputStatsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateStatsInputStatsBuilder toBuilder() =>
      UpdateStatsInputStatsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateStatsInputStats &&
        lifePoints == other.lifePoints &&
        willPoints == other.willPoints &&
        commandPoints == other.commandPoints;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lifePoints.hashCode);
    _$hash = $jc(_$hash, willPoints.hashCode);
    _$hash = $jc(_$hash, commandPoints.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateStatsInputStats')
          ..add('lifePoints', lifePoints)
          ..add('willPoints', willPoints)
          ..add('commandPoints', commandPoints))
        .toString();
  }
}

class UpdateStatsInputStatsBuilder
    implements Builder<UpdateStatsInputStats, UpdateStatsInputStatsBuilder> {
  _$UpdateStatsInputStats? _$v;

  int? _lifePoints;
  int? get lifePoints => _$this._lifePoints;
  set lifePoints(int? lifePoints) => _$this._lifePoints = lifePoints;

  int? _willPoints;
  int? get willPoints => _$this._willPoints;
  set willPoints(int? willPoints) => _$this._willPoints = willPoints;

  int? _commandPoints;
  int? get commandPoints => _$this._commandPoints;
  set commandPoints(int? commandPoints) =>
      _$this._commandPoints = commandPoints;

  UpdateStatsInputStatsBuilder() {
    UpdateStatsInputStats._defaults(this);
  }

  UpdateStatsInputStatsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lifePoints = $v.lifePoints;
      _willPoints = $v.willPoints;
      _commandPoints = $v.commandPoints;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateStatsInputStats other) {
    _$v = other as _$UpdateStatsInputStats;
  }

  @override
  void update(void Function(UpdateStatsInputStatsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateStatsInputStats build() => _build();

  _$UpdateStatsInputStats _build() {
    final _$result =
        _$v ??
        _$UpdateStatsInputStats._(
          lifePoints: lifePoints,
          willPoints: willPoints,
          commandPoints: commandPoints,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
