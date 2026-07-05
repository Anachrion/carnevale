// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_stats_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateStatsInput extends UpdateStatsInput {
  @override
  final UpdateStatsInputStats stats;

  factory _$UpdateStatsInput([
    void Function(UpdateStatsInputBuilder)? updates,
  ]) => (UpdateStatsInputBuilder()..update(updates))._build();

  _$UpdateStatsInput._({required this.stats}) : super._();
  @override
  UpdateStatsInput rebuild(void Function(UpdateStatsInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateStatsInputBuilder toBuilder() =>
      UpdateStatsInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateStatsInput && stats == other.stats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'UpdateStatsInput',
    )..add('stats', stats)).toString();
  }
}

class UpdateStatsInputBuilder
    implements Builder<UpdateStatsInput, UpdateStatsInputBuilder> {
  _$UpdateStatsInput? _$v;

  UpdateStatsInputStatsBuilder? _stats;
  UpdateStatsInputStatsBuilder get stats =>
      _$this._stats ??= UpdateStatsInputStatsBuilder();
  set stats(UpdateStatsInputStatsBuilder? stats) => _$this._stats = stats;

  UpdateStatsInputBuilder() {
    UpdateStatsInput._defaults(this);
  }

  UpdateStatsInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stats = $v.stats.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateStatsInput other) {
    _$v = other as _$UpdateStatsInput;
  }

  @override
  void update(void Function(UpdateStatsInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateStatsInput build() => _build();

  _$UpdateStatsInput _build() {
    _$UpdateStatsInput _$result;
    try {
      _$result = _$v ?? _$UpdateStatsInput._(stats: stats.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stats';
        stats.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateStatsInput',
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
