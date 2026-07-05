// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_counters_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCountersInput extends UpdateCountersInput {
  @override
  final UpdateCountersInputCounters counters;

  factory _$UpdateCountersInput([
    void Function(UpdateCountersInputBuilder)? updates,
  ]) => (UpdateCountersInputBuilder()..update(updates))._build();

  _$UpdateCountersInput._({required this.counters}) : super._();
  @override
  UpdateCountersInput rebuild(
    void Function(UpdateCountersInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateCountersInputBuilder toBuilder() =>
      UpdateCountersInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCountersInput && counters == other.counters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, counters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'UpdateCountersInput',
    )..add('counters', counters)).toString();
  }
}

class UpdateCountersInputBuilder
    implements Builder<UpdateCountersInput, UpdateCountersInputBuilder> {
  _$UpdateCountersInput? _$v;

  UpdateCountersInputCountersBuilder? _counters;
  UpdateCountersInputCountersBuilder get counters =>
      _$this._counters ??= UpdateCountersInputCountersBuilder();
  set counters(UpdateCountersInputCountersBuilder? counters) =>
      _$this._counters = counters;

  UpdateCountersInputBuilder() {
    UpdateCountersInput._defaults(this);
  }

  UpdateCountersInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _counters = $v.counters.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCountersInput other) {
    _$v = other as _$UpdateCountersInput;
  }

  @override
  void update(void Function(UpdateCountersInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCountersInput build() => _build();

  _$UpdateCountersInput _build() {
    _$UpdateCountersInput _$result;
    try {
      _$result = _$v ?? _$UpdateCountersInput._(counters: counters.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counters';
        counters.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateCountersInput',
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
