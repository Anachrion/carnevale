// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_game_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JoinGameInput extends JoinGameInput {
  @override
  final String joinCode;

  factory _$JoinGameInput([void Function(JoinGameInputBuilder)? updates]) =>
      (JoinGameInputBuilder()..update(updates))._build();

  _$JoinGameInput._({required this.joinCode}) : super._();
  @override
  JoinGameInput rebuild(void Function(JoinGameInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JoinGameInputBuilder toBuilder() => JoinGameInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JoinGameInput && joinCode == other.joinCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, joinCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'JoinGameInput',
    )..add('joinCode', joinCode)).toString();
  }
}

class JoinGameInputBuilder
    implements Builder<JoinGameInput, JoinGameInputBuilder> {
  _$JoinGameInput? _$v;

  String? _joinCode;
  String? get joinCode => _$this._joinCode;
  set joinCode(String? joinCode) => _$this._joinCode = joinCode;

  JoinGameInputBuilder() {
    JoinGameInput._defaults(this);
  }

  JoinGameInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _joinCode = $v.joinCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JoinGameInput other) {
    _$v = other as _$JoinGameInput;
  }

  @override
  void update(void Function(JoinGameInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JoinGameInput build() => _build();

  _$JoinGameInput _build() {
    final _$result =
        _$v ??
        _$JoinGameInput._(
          joinCode: BuiltValueNullFieldError.checkNotNull(
            joinCode,
            r'JoinGameInput',
            'joinCode',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
