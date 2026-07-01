// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResetPasswordInput extends ResetPasswordInput {
  @override
  final ResetPasswordInputUser user;

  factory _$ResetPasswordInput([
    void Function(ResetPasswordInputBuilder)? updates,
  ]) => (ResetPasswordInputBuilder()..update(updates))._build();

  _$ResetPasswordInput._({required this.user}) : super._();
  @override
  ResetPasswordInput rebuild(
    void Function(ResetPasswordInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ResetPasswordInputBuilder toBuilder() =>
      ResetPasswordInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResetPasswordInput && user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ResetPasswordInput',
    )..add('user', user)).toString();
  }
}

class ResetPasswordInputBuilder
    implements Builder<ResetPasswordInput, ResetPasswordInputBuilder> {
  _$ResetPasswordInput? _$v;

  ResetPasswordInputUserBuilder? _user;
  ResetPasswordInputUserBuilder get user =>
      _$this._user ??= ResetPasswordInputUserBuilder();
  set user(ResetPasswordInputUserBuilder? user) => _$this._user = user;

  ResetPasswordInputBuilder() {
    ResetPasswordInput._defaults(this);
  }

  ResetPasswordInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResetPasswordInput other) {
    _$v = other as _$ResetPasswordInput;
  }

  @override
  void update(void Function(ResetPasswordInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResetPasswordInput build() => _build();

  _$ResetPasswordInput _build() {
    _$ResetPasswordInput _$result;
    try {
      _$result = _$v ?? _$ResetPasswordInput._(user: user.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ResetPasswordInput',
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
