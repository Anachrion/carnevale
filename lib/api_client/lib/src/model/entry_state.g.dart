// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryState extends EntryState {
  @override
  final EntryStatValue lifePoints;
  @override
  final EntryStatValue willPoints;
  @override
  final EntryStatValue commandPoints;
  @override
  final bool stunned;
  @override
  final bool hidden;
  @override
  final bool guarding;
  @override
  final bool carryingObjective;
  @override
  final int underwaterCounters;

  factory _$EntryState([void Function(EntryStateBuilder)? updates]) =>
      (EntryStateBuilder()..update(updates))._build();

  _$EntryState._({
    required this.lifePoints,
    required this.willPoints,
    required this.commandPoints,
    required this.stunned,
    required this.hidden,
    required this.guarding,
    required this.carryingObjective,
    required this.underwaterCounters,
  }) : super._();
  @override
  EntryState rebuild(void Function(EntryStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryStateBuilder toBuilder() => EntryStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryState &&
        lifePoints == other.lifePoints &&
        willPoints == other.willPoints &&
        commandPoints == other.commandPoints &&
        stunned == other.stunned &&
        hidden == other.hidden &&
        guarding == other.guarding &&
        carryingObjective == other.carryingObjective &&
        underwaterCounters == other.underwaterCounters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lifePoints.hashCode);
    _$hash = $jc(_$hash, willPoints.hashCode);
    _$hash = $jc(_$hash, commandPoints.hashCode);
    _$hash = $jc(_$hash, stunned.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, guarding.hashCode);
    _$hash = $jc(_$hash, carryingObjective.hashCode);
    _$hash = $jc(_$hash, underwaterCounters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EntryState')
          ..add('lifePoints', lifePoints)
          ..add('willPoints', willPoints)
          ..add('commandPoints', commandPoints)
          ..add('stunned', stunned)
          ..add('hidden', hidden)
          ..add('guarding', guarding)
          ..add('carryingObjective', carryingObjective)
          ..add('underwaterCounters', underwaterCounters))
        .toString();
  }
}

class EntryStateBuilder implements Builder<EntryState, EntryStateBuilder> {
  _$EntryState? _$v;

  EntryStatValueBuilder? _lifePoints;
  EntryStatValueBuilder get lifePoints =>
      _$this._lifePoints ??= EntryStatValueBuilder();
  set lifePoints(EntryStatValueBuilder? lifePoints) =>
      _$this._lifePoints = lifePoints;

  EntryStatValueBuilder? _willPoints;
  EntryStatValueBuilder get willPoints =>
      _$this._willPoints ??= EntryStatValueBuilder();
  set willPoints(EntryStatValueBuilder? willPoints) =>
      _$this._willPoints = willPoints;

  EntryStatValueBuilder? _commandPoints;
  EntryStatValueBuilder get commandPoints =>
      _$this._commandPoints ??= EntryStatValueBuilder();
  set commandPoints(EntryStatValueBuilder? commandPoints) =>
      _$this._commandPoints = commandPoints;

  bool? _stunned;
  bool? get stunned => _$this._stunned;
  set stunned(bool? stunned) => _$this._stunned = stunned;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

  bool? _guarding;
  bool? get guarding => _$this._guarding;
  set guarding(bool? guarding) => _$this._guarding = guarding;

  bool? _carryingObjective;
  bool? get carryingObjective => _$this._carryingObjective;
  set carryingObjective(bool? carryingObjective) =>
      _$this._carryingObjective = carryingObjective;

  int? _underwaterCounters;
  int? get underwaterCounters => _$this._underwaterCounters;
  set underwaterCounters(int? underwaterCounters) =>
      _$this._underwaterCounters = underwaterCounters;

  EntryStateBuilder() {
    EntryState._defaults(this);
  }

  EntryStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lifePoints = $v.lifePoints.toBuilder();
      _willPoints = $v.willPoints.toBuilder();
      _commandPoints = $v.commandPoints.toBuilder();
      _stunned = $v.stunned;
      _hidden = $v.hidden;
      _guarding = $v.guarding;
      _carryingObjective = $v.carryingObjective;
      _underwaterCounters = $v.underwaterCounters;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryState other) {
    _$v = other as _$EntryState;
  }

  @override
  void update(void Function(EntryStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryState build() => _build();

  _$EntryState _build() {
    _$EntryState _$result;
    try {
      _$result =
          _$v ??
          _$EntryState._(
            lifePoints: lifePoints.build(),
            willPoints: willPoints.build(),
            commandPoints: commandPoints.build(),
            stunned: BuiltValueNullFieldError.checkNotNull(
              stunned,
              r'EntryState',
              'stunned',
            ),
            hidden: BuiltValueNullFieldError.checkNotNull(
              hidden,
              r'EntryState',
              'hidden',
            ),
            guarding: BuiltValueNullFieldError.checkNotNull(
              guarding,
              r'EntryState',
              'guarding',
            ),
            carryingObjective: BuiltValueNullFieldError.checkNotNull(
              carryingObjective,
              r'EntryState',
              'carryingObjective',
            ),
            underwaterCounters: BuiltValueNullFieldError.checkNotNull(
              underwaterCounters,
              r'EntryState',
              'underwaterCounters',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lifePoints';
        lifePoints.build();
        _$failedField = 'willPoints';
        willPoints.build();
        _$failedField = 'commandPoints';
        commandPoints.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EntryState',
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
