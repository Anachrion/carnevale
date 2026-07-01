// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_input_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegistrationInputUser extends RegistrationInputUser {
  @override
  final String username;
  @override
  final String email;
  @override
  final String password;
  @override
  final String passwordConfirmation;

  factory _$RegistrationInputUser([
    void Function(RegistrationInputUserBuilder)? updates,
  ]) => (RegistrationInputUserBuilder()..update(updates))._build();

  _$RegistrationInputUser._({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  }) : super._();
  @override
  RegistrationInputUser rebuild(
    void Function(RegistrationInputUserBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RegistrationInputUserBuilder toBuilder() =>
      RegistrationInputUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrationInputUser &&
        username == other.username &&
        email == other.email &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordConfirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegistrationInputUser')
          ..add('username', username)
          ..add('email', email)
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation))
        .toString();
  }
}

class RegistrationInputUserBuilder
    implements Builder<RegistrationInputUser, RegistrationInputUserBuilder> {
  _$RegistrationInputUser? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _passwordConfirmation;
  String? get passwordConfirmation => _$this._passwordConfirmation;
  set passwordConfirmation(String? passwordConfirmation) =>
      _$this._passwordConfirmation = passwordConfirmation;

  RegistrationInputUserBuilder() {
    RegistrationInputUser._defaults(this);
  }

  RegistrationInputUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _email = $v.email;
      _password = $v.password;
      _passwordConfirmation = $v.passwordConfirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegistrationInputUser other) {
    _$v = other as _$RegistrationInputUser;
  }

  @override
  void update(void Function(RegistrationInputUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegistrationInputUser build() => _build();

  _$RegistrationInputUser _build() {
    final _$result =
        _$v ??
        _$RegistrationInputUser._(
          username: BuiltValueNullFieldError.checkNotNull(
            username,
            r'RegistrationInputUser',
            'username',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'RegistrationInputUser',
            'email',
          ),
          password: BuiltValueNullFieldError.checkNotNull(
            password,
            r'RegistrationInputUser',
            'password',
          ),
          passwordConfirmation: BuiltValueNullFieldError.checkNotNull(
            passwordConfirmation,
            r'RegistrationInputUser',
            'passwordConfirmation',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
