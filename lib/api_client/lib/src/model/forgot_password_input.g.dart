// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ForgotPasswordInput extends ForgotPasswordInput {
  @override
  final ForgotPasswordInputUser user;

  factory _$ForgotPasswordInput([
    void Function(ForgotPasswordInputBuilder)? updates,
  ]) => (ForgotPasswordInputBuilder()..update(updates))._build();

  _$ForgotPasswordInput._({required this.user}) : super._();
  @override
  ForgotPasswordInput rebuild(
    void Function(ForgotPasswordInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ForgotPasswordInputBuilder toBuilder() =>
      ForgotPasswordInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ForgotPasswordInput && user == other.user;
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
      r'ForgotPasswordInput',
    )..add('user', user)).toString();
  }
}

class ForgotPasswordInputBuilder
    implements Builder<ForgotPasswordInput, ForgotPasswordInputBuilder> {
  _$ForgotPasswordInput? _$v;

  ForgotPasswordInputUserBuilder? _user;
  ForgotPasswordInputUserBuilder get user =>
      _$this._user ??= ForgotPasswordInputUserBuilder();
  set user(ForgotPasswordInputUserBuilder? user) => _$this._user = user;

  ForgotPasswordInputBuilder() {
    ForgotPasswordInput._defaults(this);
  }

  ForgotPasswordInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ForgotPasswordInput other) {
    _$v = other as _$ForgotPasswordInput;
  }

  @override
  void update(void Function(ForgotPasswordInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ForgotPasswordInput build() => _build();

  _$ForgotPasswordInput _build() {
    _$ForgotPasswordInput _$result;
    try {
      _$result = _$v ?? _$ForgotPasswordInput._(user: user.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ForgotPasswordInput',
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
