// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_entry_spells_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetEntrySpellsInput extends SetEntrySpellsInput {
  @override
  final SetEntrySpellsInputEntry entry;

  factory _$SetEntrySpellsInput([
    void Function(SetEntrySpellsInputBuilder)? updates,
  ]) => (SetEntrySpellsInputBuilder()..update(updates))._build();

  _$SetEntrySpellsInput._({required this.entry}) : super._();
  @override
  SetEntrySpellsInput rebuild(
    void Function(SetEntrySpellsInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SetEntrySpellsInputBuilder toBuilder() =>
      SetEntrySpellsInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetEntrySpellsInput && entry == other.entry;
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
      r'SetEntrySpellsInput',
    )..add('entry', entry)).toString();
  }
}

class SetEntrySpellsInputBuilder
    implements Builder<SetEntrySpellsInput, SetEntrySpellsInputBuilder> {
  _$SetEntrySpellsInput? _$v;

  SetEntrySpellsInputEntryBuilder? _entry;
  SetEntrySpellsInputEntryBuilder get entry =>
      _$this._entry ??= SetEntrySpellsInputEntryBuilder();
  set entry(SetEntrySpellsInputEntryBuilder? entry) => _$this._entry = entry;

  SetEntrySpellsInputBuilder() {
    SetEntrySpellsInput._defaults(this);
  }

  SetEntrySpellsInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entry = $v.entry.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetEntrySpellsInput other) {
    _$v = other as _$SetEntrySpellsInput;
  }

  @override
  void update(void Function(SetEntrySpellsInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetEntrySpellsInput build() => _build();

  _$SetEntrySpellsInput _build() {
    _$SetEntrySpellsInput _$result;
    try {
      _$result = _$v ?? _$SetEntrySpellsInput._(entry: entry.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entry';
        entry.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SetEntrySpellsInput',
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
