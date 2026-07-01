// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_account_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateAccountInput extends UpdateAccountInput {
  @override
  final UpdateAccountInputUser user;

  factory _$UpdateAccountInput([
    void Function(UpdateAccountInputBuilder)? updates,
  ]) => (UpdateAccountInputBuilder()..update(updates))._build();

  _$UpdateAccountInput._({required this.user}) : super._();
  @override
  UpdateAccountInput rebuild(
    void Function(UpdateAccountInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateAccountInputBuilder toBuilder() =>
      UpdateAccountInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateAccountInput && user == other.user;
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
      r'UpdateAccountInput',
    )..add('user', user)).toString();
  }
}

class UpdateAccountInputBuilder
    implements Builder<UpdateAccountInput, UpdateAccountInputBuilder> {
  _$UpdateAccountInput? _$v;

  UpdateAccountInputUserBuilder? _user;
  UpdateAccountInputUserBuilder get user =>
      _$this._user ??= UpdateAccountInputUserBuilder();
  set user(UpdateAccountInputUserBuilder? user) => _$this._user = user;

  UpdateAccountInputBuilder() {
    UpdateAccountInput._defaults(this);
  }

  UpdateAccountInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateAccountInput other) {
    _$v = other as _$UpdateAccountInput;
  }

  @override
  void update(void Function(UpdateAccountInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateAccountInput build() => _build();

  _$UpdateAccountInput _build() {
    _$UpdateAccountInput _$result;
    try {
      _$result = _$v ?? _$UpdateAccountInput._(user: user.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateAccountInput',
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
