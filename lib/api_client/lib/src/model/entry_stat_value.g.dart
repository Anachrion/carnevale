// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_stat_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryStatValue extends EntryStatValue {
  @override
  final int current;
  @override
  final int starting;

  factory _$EntryStatValue([void Function(EntryStatValueBuilder)? updates]) =>
      (EntryStatValueBuilder()..update(updates))._build();

  _$EntryStatValue._({required this.current, required this.starting})
    : super._();
  @override
  EntryStatValue rebuild(void Function(EntryStatValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryStatValueBuilder toBuilder() => EntryStatValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryStatValue &&
        current == other.current &&
        starting == other.starting;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, starting.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EntryStatValue')
          ..add('current', current)
          ..add('starting', starting))
        .toString();
  }
}

class EntryStatValueBuilder
    implements Builder<EntryStatValue, EntryStatValueBuilder> {
  _$EntryStatValue? _$v;

  int? _current;
  int? get current => _$this._current;
  set current(int? current) => _$this._current = current;

  int? _starting;
  int? get starting => _$this._starting;
  set starting(int? starting) => _$this._starting = starting;

  EntryStatValueBuilder() {
    EntryStatValue._defaults(this);
  }

  EntryStatValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _current = $v.current;
      _starting = $v.starting;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryStatValue other) {
    _$v = other as _$EntryStatValue;
  }

  @override
  void update(void Function(EntryStatValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryStatValue build() => _build();

  _$EntryStatValue _build() {
    final _$result =
        _$v ??
        _$EntryStatValue._(
          current: BuiltValueNullFieldError.checkNotNull(
            current,
            r'EntryStatValue',
            'current',
          ),
          starting: BuiltValueNullFieldError.checkNotNull(
            starting,
            r'EntryStatValue',
            'starting',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
