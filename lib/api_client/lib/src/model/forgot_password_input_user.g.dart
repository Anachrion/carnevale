// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_input_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ForgotPasswordInputUser extends ForgotPasswordInputUser {
  @override
  final String email;

  factory _$ForgotPasswordInputUser([
    void Function(ForgotPasswordInputUserBuilder)? updates,
  ]) => (ForgotPasswordInputUserBuilder()..update(updates))._build();

  _$ForgotPasswordInputUser._({required this.email}) : super._();
  @override
  ForgotPasswordInputUser rebuild(
    void Function(ForgotPasswordInputUserBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ForgotPasswordInputUserBuilder toBuilder() =>
      ForgotPasswordInputUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ForgotPasswordInputUser && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ForgotPasswordInputUser',
    )..add('email', email)).toString();
  }
}

class ForgotPasswordInputUserBuilder
    implements
        Builder<ForgotPasswordInputUser, ForgotPasswordInputUserBuilder> {
  _$ForgotPasswordInputUser? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ForgotPasswordInputUserBuilder() {
    ForgotPasswordInputUser._defaults(this);
  }

  ForgotPasswordInputUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ForgotPasswordInputUser other) {
    _$v = other as _$ForgotPasswordInputUser;
  }

  @override
  void update(void Function(ForgotPasswordInputUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ForgotPasswordInputUser build() => _build();

  _$ForgotPasswordInputUser _build() {
    final _$result =
        _$v ??
        _$ForgotPasswordInputUser._(
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'ForgotPasswordInputUser',
            'email',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
