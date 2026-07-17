// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_spell_cast_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateSpellCastInput extends UpdateSpellCastInput {
  @override
  final UpdateSpellCastInputSpellCast spellCast;

  factory _$UpdateSpellCastInput([
    void Function(UpdateSpellCastInputBuilder)? updates,
  ]) => (UpdateSpellCastInputBuilder()..update(updates))._build();

  _$UpdateSpellCastInput._({required this.spellCast}) : super._();
  @override
  UpdateSpellCastInput rebuild(
    void Function(UpdateSpellCastInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateSpellCastInputBuilder toBuilder() =>
      UpdateSpellCastInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateSpellCastInput && spellCast == other.spellCast;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, spellCast.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'UpdateSpellCastInput',
    )..add('spellCast', spellCast)).toString();
  }
}

class UpdateSpellCastInputBuilder
    implements Builder<UpdateSpellCastInput, UpdateSpellCastInputBuilder> {
  _$UpdateSpellCastInput? _$v;

  UpdateSpellCastInputSpellCastBuilder? _spellCast;
  UpdateSpellCastInputSpellCastBuilder get spellCast =>
      _$this._spellCast ??= UpdateSpellCastInputSpellCastBuilder();
  set spellCast(UpdateSpellCastInputSpellCastBuilder? spellCast) =>
      _$this._spellCast = spellCast;

  UpdateSpellCastInputBuilder() {
    UpdateSpellCastInput._defaults(this);
  }

  UpdateSpellCastInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _spellCast = $v.spellCast.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateSpellCastInput other) {
    _$v = other as _$UpdateSpellCastInput;
  }

  @override
  void update(void Function(UpdateSpellCastInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateSpellCastInput build() => _build();

  _$UpdateSpellCastInput _build() {
    _$UpdateSpellCastInput _$result;
    try {
      _$result = _$v ?? _$UpdateSpellCastInput._(spellCast: spellCast.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'spellCast';
        spellCast.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateSpellCastInput',
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
