// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegistrationInput extends RegistrationInput {
  @override
  final RegistrationInputUser user;

  factory _$RegistrationInput([
    void Function(RegistrationInputBuilder)? updates,
  ]) => (RegistrationInputBuilder()..update(updates))._build();

  _$RegistrationInput._({required this.user}) : super._();
  @override
  RegistrationInput rebuild(void Function(RegistrationInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegistrationInputBuilder toBuilder() =>
      RegistrationInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrationInput && user == other.user;
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
      r'RegistrationInput',
    )..add('user', user)).toString();
  }
}

class RegistrationInputBuilder
    implements Builder<RegistrationInput, RegistrationInputBuilder> {
  _$RegistrationInput? _$v;

  RegistrationInputUserBuilder? _user;
  RegistrationInputUserBuilder get user =>
      _$this._user ??= RegistrationInputUserBuilder();
  set user(RegistrationInputUserBuilder? user) => _$this._user = user;

  RegistrationInputBuilder() {
    RegistrationInput._defaults(this);
  }

  RegistrationInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegistrationInput other) {
    _$v = other as _$RegistrationInput;
  }

  @override
  void update(void Function(RegistrationInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegistrationInput build() => _build();

  _$RegistrationInput _build() {
    _$RegistrationInput _$result;
    try {
      _$result = _$v ?? _$RegistrationInput._(user: user.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RegistrationInput',
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
