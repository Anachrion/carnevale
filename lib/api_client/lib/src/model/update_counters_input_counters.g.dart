// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_counters_input_counters.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCountersInputCounters extends UpdateCountersInputCounters {
  @override
  final bool? stunned;
  @override
  final bool? hidden;
  @override
  final bool? guarding;
  @override
  final bool? carryingObjective;
  @override
  final int? underwaterCounters;
  @override
  final bool? activated;

  factory _$UpdateCountersInputCounters([
    void Function(UpdateCountersInputCountersBuilder)? updates,
  ]) => (UpdateCountersInputCountersBuilder()..update(updates))._build();

  _$UpdateCountersInputCounters._({
    this.stunned,
    this.hidden,
    this.guarding,
    this.carryingObjective,
    this.underwaterCounters,
    this.activated,
  }) : super._();
  @override
  UpdateCountersInputCounters rebuild(
    void Function(UpdateCountersInputCountersBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateCountersInputCountersBuilder toBuilder() =>
      UpdateCountersInputCountersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCountersInputCounters &&
        stunned == other.stunned &&
        hidden == other.hidden &&
        guarding == other.guarding &&
        carryingObjective == other.carryingObjective &&
        underwaterCounters == other.underwaterCounters &&
        activated == other.activated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stunned.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, guarding.hashCode);
    _$hash = $jc(_$hash, carryingObjective.hashCode);
    _$hash = $jc(_$hash, underwaterCounters.hashCode);
    _$hash = $jc(_$hash, activated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateCountersInputCounters')
          ..add('stunned', stunned)
          ..add('hidden', hidden)
          ..add('guarding', guarding)
          ..add('carryingObjective', carryingObjective)
          ..add('underwaterCounters', underwaterCounters)
          ..add('activated', activated))
        .toString();
  }
}

class UpdateCountersInputCountersBuilder
    implements
        Builder<
          UpdateCountersInputCounters,
          UpdateCountersInputCountersBuilder
        > {
  _$UpdateCountersInputCounters? _$v;

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

  bool? _activated;
  bool? get activated => _$this._activated;
  set activated(bool? activated) => _$this._activated = activated;

  UpdateCountersInputCountersBuilder() {
    UpdateCountersInputCounters._defaults(this);
  }

  UpdateCountersInputCountersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stunned = $v.stunned;
      _hidden = $v.hidden;
      _guarding = $v.guarding;
      _carryingObjective = $v.carryingObjective;
      _underwaterCounters = $v.underwaterCounters;
      _activated = $v.activated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCountersInputCounters other) {
    _$v = other as _$UpdateCountersInputCounters;
  }

  @override
  void update(void Function(UpdateCountersInputCountersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCountersInputCounters build() => _build();

  _$UpdateCountersInputCounters _build() {
    final _$result =
        _$v ??
        _$UpdateCountersInputCounters._(
          stunned: stunned,
          hidden: hidden,
          guarding: guarding,
          carryingObjective: carryingObjective,
          underwaterCounters: underwaterCounters,
          activated: activated,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
