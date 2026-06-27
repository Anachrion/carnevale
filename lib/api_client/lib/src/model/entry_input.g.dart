// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryInput extends EntryInput {
  @override
  final EntryInputEntry entry;

  factory _$EntryInput([void Function(EntryInputBuilder)? updates]) =>
      (EntryInputBuilder()..update(updates))._build();

  _$EntryInput._({required this.entry}) : super._();
  @override
  EntryInput rebuild(void Function(EntryInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryInputBuilder toBuilder() => EntryInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryInput && entry == other.entry;
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
      r'EntryInput',
    )..add('entry', entry)).toString();
  }
}

class EntryInputBuilder implements Builder<EntryInput, EntryInputBuilder> {
  _$EntryInput? _$v;

  EntryInputEntryBuilder? _entry;
  EntryInputEntryBuilder get entry =>
      _$this._entry ??= EntryInputEntryBuilder();
  set entry(EntryInputEntryBuilder? entry) => _$this._entry = entry;

  EntryInputBuilder() {
    EntryInput._defaults(this);
  }

  EntryInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entry = $v.entry.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryInput other) {
    _$v = other as _$EntryInput;
  }

  @override
  void update(void Function(EntryInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryInput build() => _build();

  _$EntryInput _build() {
    _$EntryInput _$result;
    try {
      _$result = _$v ?? _$EntryInput._(entry: entry.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entry';
        entry.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EntryInput',
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
