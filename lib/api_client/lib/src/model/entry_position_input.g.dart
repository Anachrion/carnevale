// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_position_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryPositionInput extends EntryPositionInput {
  @override
  final EntryPositionInputEntry entry;

  factory _$EntryPositionInput([
    void Function(EntryPositionInputBuilder)? updates,
  ]) => (EntryPositionInputBuilder()..update(updates))._build();

  _$EntryPositionInput._({required this.entry}) : super._();
  @override
  EntryPositionInput rebuild(
    void Function(EntryPositionInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EntryPositionInputBuilder toBuilder() =>
      EntryPositionInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryPositionInput && entry == other.entry;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entry.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EntryPositionInput',
    )..add('entry', entry)).toString();
  }
}

class EntryPositionInputBuilder
    implements Builder<EntryPositionInput, EntryPositionInputBuilder> {
  _$EntryPositionInput? _$v;

  EntryPositionInputEntryBuilder? _entry;
  EntryPositionInputEntryBuilder get entry =>
      _$this._entry ??= EntryPositionInputEntryBuilder();
  set entry(EntryPositionInputEntryBuilder? entry) => _$this._entry = entry;

  EntryPositionInputBuilder() {
    EntryPositionInput._defaults(this);
  }

  EntryPositionInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entry = $v.entry.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryPositionInput other) {
    _$v = other as _$EntryPositionInput;
  }

  @override
  void update(void Function(EntryPositionInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryPositionInput build() => _build();

  _$EntryPositionInput _build() {
    _$EntryPositionInput _$result;
    try {
      _$result = _$v ?? _$EntryPositionInput._(entry: entry.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entry';
        entry.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EntryPositionInput',
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
