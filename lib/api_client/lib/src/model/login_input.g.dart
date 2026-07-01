// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginInput extends LoginInput {
  @override
  final LoginInputUser user;

  factory _$LoginInput([void Function(LoginInputBuilder)? updates]) =>
      (LoginInputBuilder()..update(updates))._build();

  _$LoginInput._({required this.user}) : super._();
  @override
  LoginInput rebuild(void Function(LoginInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginInputBuilder toBuilder() => LoginInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginInput && user == other.user;
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
      r'LoginInput',
    )..add('user', user)).toString();
  }
}

class LoginInputBuilder implements Builder<LoginInput, LoginInputBuilder> {
  _$LoginInput? _$v;

  LoginInputUserBuilder? _user;
  LoginInputUserBuilder get user => _$this._user ??= LoginInputUserBuilder();
  set user(LoginInputUserBuilder? user) => _$this._user = user;

  LoginInputBuilder() {
    LoginInput._defaults(this);
  }

  LoginInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginInput other) {
    _$v = other as _$LoginInput;
  }

  @override
  void update(void Function(LoginInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginInput build() => _build();

  _$LoginInput _build() {
    _$LoginInput _$result;
    try {
      _$result = _$v ?? _$LoginInput._(user: user.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'LoginInput',
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
