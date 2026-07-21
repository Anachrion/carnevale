// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_upgrade_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryUpgradeInput extends EntryUpgradeInput {
  @override
  final EntryUpgradeInputEntry entry;

  factory _$EntryUpgradeInput([
    void Function(EntryUpgradeInputBuilder)? updates,
  ]) => (EntryUpgradeInputBuilder()..update(updates))._build();

  _$EntryUpgradeInput._({required this.entry}) : super._();
  @override
  EntryUpgradeInput rebuild(void Function(EntryUpgradeInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryUpgradeInputBuilder toBuilder() =>
      EntryUpgradeInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryUpgradeInput && entry == other.entry;
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
      r'EntryUpgradeInput',
    )..add('entry', entry)).toString();
  }
}

class EntryUpgradeInputBuilder
    implements Builder<EntryUpgradeInput, EntryUpgradeInputBuilder> {
  _$EntryUpgradeInput? _$v;

  EntryUpgradeInputEntryBuilder? _entry;
  EntryUpgradeInputEntryBuilder get entry =>
      _$this._entry ??= EntryUpgradeInputEntryBuilder();
  set entry(EntryUpgradeInputEntryBuilder? entry) => _$this._entry = entry;

  EntryUpgradeInputBuilder() {
    EntryUpgradeInput._defaults(this);
  }

  EntryUpgradeInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entry = $v.entry.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryUpgradeInput other) {
    _$v = other as _$EntryUpgradeInput;
  }

  @override
  void update(void Function(EntryUpgradeInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryUpgradeInput build() => _build();

  _$EntryUpgradeInput _build() {
    _$EntryUpgradeInput _$result;
    try {
      _$result = _$v ?? _$EntryUpgradeInput._(entry: entry.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entry';
        entry.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EntryUpgradeInput',
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
