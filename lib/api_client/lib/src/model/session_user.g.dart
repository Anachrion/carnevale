// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SessionUser extends SessionUser {
  @override
  final int id;
  @override
  final String email;
  @override
  final String username;
  @override
  final bool collectionEnabled;
  @override
  final bool collectionVisible;

  factory _$SessionUser([void Function(SessionUserBuilder)? updates]) =>
      (SessionUserBuilder()..update(updates))._build();

  _$SessionUser._({
    required this.id,
    required this.email,
    required this.username,
    required this.collectionEnabled,
    required this.collectionVisible,
  }) : super._();
  @override
  SessionUser rebuild(void Function(SessionUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionUserBuilder toBuilder() => SessionUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SessionUser &&
        id == other.id &&
        email == other.email &&
        username == other.username &&
        collectionEnabled == other.collectionEnabled &&
        collectionVisible == other.collectionVisible;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, collectionEnabled.hashCode);
    _$hash = $jc(_$hash, collectionVisible.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SessionUser')
          ..add('id', id)
          ..add('email', email)
          ..add('username', username)
          ..add('collectionEnabled', collectionEnabled)
          ..add('collectionVisible', collectionVisible))
        .toString();
  }
}

class SessionUserBuilder implements Builder<SessionUser, SessionUserBuilder> {
  _$SessionUser? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

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

  SessionUserBuilder() {
    SessionUser._defaults(this);
  }

  SessionUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _email = $v.email;
      _username = $v.username;
      _collectionEnabled = $v.collectionEnabled;
      _collectionVisible = $v.collectionVisible;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SessionUser other) {
    _$v = other as _$SessionUser;
  }

  @override
  void update(void Function(SessionUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SessionUser build() => _build();

  _$SessionUser _build() {
    final _$result =
        _$v ??
        _$SessionUser._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'SessionUser', 'id'),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'SessionUser',
            'email',
          ),
          username: BuiltValueNullFieldError.checkNotNull(
            username,
            r'SessionUser',
            'username',
          ),
          collectionEnabled: BuiltValueNullFieldError.checkNotNull(
            collectionEnabled,
            r'SessionUser',
            'collectionEnabled',
          ),
          collectionVisible: BuiltValueNullFieldError.checkNotNull(
            collectionVisible,
            r'SessionUser',
            'collectionVisible',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
