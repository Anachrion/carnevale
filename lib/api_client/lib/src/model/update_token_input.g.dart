// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_token_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateTokenInput extends UpdateTokenInput {
  @override
  final Token token;

  factory _$UpdateTokenInput([
    void Function(UpdateTokenInputBuilder)? updates,
  ]) => (UpdateTokenInputBuilder()..update(updates))._build();

  _$UpdateTokenInput._({required this.token}) : super._();
  @override
  UpdateTokenInput rebuild(void Function(UpdateTokenInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateTokenInputBuilder toBuilder() =>
      UpdateTokenInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateTokenInput && token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'UpdateTokenInput',
    )..add('token', token)).toString();
  }
}

class UpdateTokenInputBuilder
    implements Builder<UpdateTokenInput, UpdateTokenInputBuilder> {
  _$UpdateTokenInput? _$v;

  TokenBuilder? _token;
  TokenBuilder get token => _$this._token ??= TokenBuilder();
  set token(TokenBuilder? token) => _$this._token = token;

  UpdateTokenInputBuilder() {
    UpdateTokenInput._defaults(this);
  }

  UpdateTokenInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateTokenInput other) {
    _$v = other as _$UpdateTokenInput;
  }

  @override
  void update(void Function(UpdateTokenInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateTokenInput build() => _build();

  _$UpdateTokenInput _build() {
    _$UpdateTokenInput _$result;
    try {
      _$result = _$v ?? _$UpdateTokenInput._(token: token.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'token';
        token.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UpdateTokenInput',
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
