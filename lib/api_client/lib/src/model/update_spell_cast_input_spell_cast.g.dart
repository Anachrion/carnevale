// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_spell_cast_input_spell_cast.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateSpellCastInputSpellCast extends UpdateSpellCastInputSpellCast {
  @override
  final String key;
  @override
  final bool cast;

  factory _$UpdateSpellCastInputSpellCast([
    void Function(UpdateSpellCastInputSpellCastBuilder)? updates,
  ]) => (UpdateSpellCastInputSpellCastBuilder()..update(updates))._build();

  _$UpdateSpellCastInputSpellCast._({required this.key, required this.cast})
    : super._();
  @override
  UpdateSpellCastInputSpellCast rebuild(
    void Function(UpdateSpellCastInputSpellCastBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateSpellCastInputSpellCastBuilder toBuilder() =>
      UpdateSpellCastInputSpellCastBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateSpellCastInputSpellCast &&
        key == other.key &&
        cast == other.cast;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, cast.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateSpellCastInputSpellCast')
          ..add('key', key)
          ..add('cast', cast))
        .toString();
  }
}

class UpdateSpellCastInputSpellCastBuilder
    implements
        Builder<
          UpdateSpellCastInputSpellCast,
          UpdateSpellCastInputSpellCastBuilder
        > {
  _$UpdateSpellCastInputSpellCast? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  bool? _cast;
  bool? get cast => _$this._cast;
  set cast(bool? cast) => _$this._cast = cast;

  UpdateSpellCastInputSpellCastBuilder() {
    UpdateSpellCastInputSpellCast._defaults(this);
  }

  UpdateSpellCastInputSpellCastBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _cast = $v.cast;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateSpellCastInputSpellCast other) {
    _$v = other as _$UpdateSpellCastInputSpellCast;
  }

  @override
  void update(void Function(UpdateSpellCastInputSpellCastBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateSpellCastInputSpellCast build() => _build();

  _$UpdateSpellCastInputSpellCast _build() {
    final _$result =
        _$v ??
        _$UpdateSpellCastInputSpellCast._(
          key: BuiltValueNullFieldError.checkNotNull(
            key,
            r'UpdateSpellCastInputSpellCast',
            'key',
          ),
          cast: BuiltValueNullFieldError.checkNotNull(
            cast,
            r'UpdateSpellCastInputSpellCast',
            'cast',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
