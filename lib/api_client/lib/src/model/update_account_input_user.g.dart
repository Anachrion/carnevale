// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_account_input_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateAccountInputUser extends UpdateAccountInputUser {
  @override
  final String? username;
  @override
  final bool? collectionEnabled;
  @override
  final bool? collectionVisible;

  factory _$UpdateAccountInputUser([
    void Function(UpdateAccountInputUserBuilder)? updates,
  ]) => (UpdateAccountInputUserBuilder()..update(updates))._build();

  _$UpdateAccountInputUser._({
    this.username,
    this.collectionEnabled,
    this.collectionVisible,
  }) : super._();
  @override
  UpdateAccountInputUser rebuild(
    void Function(UpdateAccountInputUserBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UpdateAccountInputUserBuilder toBuilder() =>
      UpdateAccountInputUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateAccountInputUser &&
        username == other.username &&
        collectionEnabled == other.collectionEnabled &&
        collectionVisible == other.collectionVisible;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, collectionEnabled.hashCode);
    _$hash = $jc(_$hash, collectionVisible.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateAccountInputUser')
          ..add('username', username)
          ..add('collectionEnabled', collectionEnabled)
          ..add('collectionVisible', collectionVisible))
        .toString();
  }
}

class UpdateAccountInputUserBuilder
    implements Builder<UpdateAccountInputUser, UpdateAccountInputUserBuilder> {
  _$UpdateAccountInputUser? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  bool? _collectionEnabled;
  bool? get collectionEnabled => _$this._collectionEnabled;
  set collectionEnabled(bool? collectionEnabled) =>
      _$this._collectionEnabled = collectionEnabled;

  bool? _collectionVisible;
  bool? get collectionVisible => _$this._collectionVisible;
  set collectionVisible(bool? collectionVisible) =>
      _$this._collectionVisible = collectionVisible;

  UpdateAccountInputUserBuilder() {
    UpdateAccountInputUser._defaults(this);
  }

  UpdateAccountInputUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _collectionEnabled = $v.collectionEnabled;
      _collectionVisible = $v.collectionVisible;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateAccountInputUser other) {
    _$v = other as _$UpdateAccountInputUser;
  }

  @override
  void update(void Function(UpdateAccountInputUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateAccountInputUser build() => _build();

  _$UpdateAccountInputUser _build() {
    final _$result =
        _$v ??
        _$UpdateAccountInputUser._(
          username: username,
          collectionEnabled: collectionEnabled,
          collectionVisible: collectionVisible,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
