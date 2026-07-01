// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_input_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginInputUser extends LoginInputUser {
  @override
  final String email;
  @override
  final String password;

  factory _$LoginInputUser([void Function(LoginInputUserBuilder)? updates]) =>
      (LoginInputUserBuilder()..update(updates))._build();

  _$LoginInputUser._({required this.email, required this.password}) : super._();
  @override
  LoginInputUser rebuild(void Function(LoginInputUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginInputUserBuilder toBuilder() => LoginInputUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginInputUser &&
        email == other.email &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginInputUser')
          ..add('email', email)
          ..add('password', password))
        .toString();
  }
}

class LoginInputUserBuilder
    implements Builder<LoginInputUser, LoginInputUserBuilder> {
  _$LoginInputUser? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  LoginInputUserBuilder() {
    LoginInputUser._defaults(this);
  }

  LoginInputUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginInputUser other) {
    _$v = other as _$LoginInputUser;
  }

  @override
  void update(void Function(LoginInputUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginInputUser build() => _build();

  _$LoginInputUser _build() {
    final _$result =
        _$v ??
        _$LoginInputUser._(
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'LoginInputUser',
            'email',
          ),
          password: BuiltValueNullFieldError.checkNotNull(
            password,
            r'LoginInputUser',
            'password',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
