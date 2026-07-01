// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_input_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResetPasswordInputUser extends ResetPasswordInputUser {
  @override
  final String resetPasswordToken;
  @override
  final String password;
  @override
  final String passwordConfirmation;

  factory _$ResetPasswordInputUser([
    void Function(ResetPasswordInputUserBuilder)? updates,
  ]) => (ResetPasswordInputUserBuilder()..update(updates))._build();

  _$ResetPasswordInputUser._({
    required this.resetPasswordToken,
    required this.password,
    required this.passwordConfirmation,
  }) : super._();
  @override
  ResetPasswordInputUser rebuild(
    void Function(ResetPasswordInputUserBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ResetPasswordInputUserBuilder toBuilder() =>
      ResetPasswordInputUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResetPasswordInputUser &&
        resetPasswordToken == other.resetPasswordToken &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, resetPasswordToken.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordConfirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResetPasswordInputUser')
          ..add('resetPasswordToken', resetPasswordToken)
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation))
        .toString();
  }
}

class ResetPasswordInputUserBuilder
    implements Builder<ResetPasswordInputUser, ResetPasswordInputUserBuilder> {
  _$ResetPasswordInputUser? _$v;

  String? _resetPasswordToken;
  String? get resetPasswordToken => _$this._resetPasswordToken;
  set resetPasswordToken(String? resetPasswordToken) =>
      _$this._resetPasswordToken = resetPasswordToken;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _passwordConfirmation;
  String? get passwordConfirmation => _$this._passwordConfirmation;
  set passwordConfirmation(String? passwordConfirmation) =>
      _$this._passwordConfirmation = passwordConfirmation;

  ResetPasswordInputUserBuilder() {
    ResetPasswordInputUser._defaults(this);
  }

  ResetPasswordInputUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _resetPasswordToken = $v.resetPasswordToken;
      _password = $v.password;
      _passwordConfirmation = $v.passwordConfirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResetPasswordInputUser other) {
    _$v = other as _$ResetPasswordInputUser;
  }

  @override
  void update(void Function(ResetPasswordInputUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResetPasswordInputUser build() => _build();

  _$ResetPasswordInputUser _build() {
    final _$result =
        _$v ??
        _$ResetPasswordInputUser._(
          resetPasswordToken: BuiltValueNullFieldError.checkNotNull(
            resetPasswordToken,
            r'ResetPasswordInputUser',
            'resetPasswordToken',
          ),
          password: BuiltValueNullFieldError.checkNotNull(
            password,
            r'ResetPasswordInputUser',
            'password',
          ),
          passwordConfirmation: BuiltValueNullFieldError.checkNotNull(
            passwordConfirmation,
            r'ResetPasswordInputUser',
            'passwordConfirmation',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
