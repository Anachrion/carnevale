// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CollectionItem extends CollectionItem {
  @override
  final int profileId;
  @override
  final int owned;
  @override
  final int built;
  @override
  final int painted;

  factory _$CollectionItem([void Function(CollectionItemBuilder)? updates]) =>
      (CollectionItemBuilder()..update(updates))._build();

  _$CollectionItem._({
    required this.profileId,
    required this.owned,
    required this.built,
    required this.painted,
  }) : super._();
  @override
  CollectionItem rebuild(void Function(CollectionItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CollectionItemBuilder toBuilder() => CollectionItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CollectionItem &&
        profileId == other.profileId &&
        owned == other.owned &&
        built == other.built &&
        painted == other.painted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, profileId.hashCode);
    _$hash = $jc(_$hash, owned.hashCode);
    _$hash = $jc(_$hash, built.hashCode);
    _$hash = $jc(_$hash, painted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CollectionItem')
          ..add('profileId', profileId)
          ..add('owned', owned)
          ..add('built', built)
          ..add('painted', painted))
        .toString();
  }
}

class CollectionItemBuilder
    implements Builder<CollectionItem, CollectionItemBuilder> {
  _$CollectionItem? _$v;

  int? _profileId;
  int? get profileId => _$this._profileId;
  set profileId(int? profileId) => _$this._profileId = profileId;

  int? _owned;
  int? get owned => _$this._owned;
  set owned(int? owned) => _$this._owned = owned;

  int? _built;
  int? get built => _$this._built;
  set built(int? built) => _$this._built = built;

  int? _painted;
  int? get painted => _$this._painted;
  set painted(int? painted) => _$this._painted = painted;

  CollectionItemBuilder() {
    CollectionItem._defaults(this);
  }

  CollectionItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _profileId = $v.profileId;
      _owned = $v.owned;
      _built = $v.built;
      _painted = $v.painted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CollectionItem other) {
    _$v = other as _$CollectionItem;
  }

  @override
  void update(void Function(CollectionItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CollectionItem build() => _build();

  _$CollectionItem _build() {
    final _$result =
        _$v ??
        _$CollectionItem._(
          profileId: BuiltValueNullFieldError.checkNotNull(
            profileId,
            r'CollectionItem',
            'profileId',
          ),
          owned: BuiltValueNullFieldError.checkNotNull(
            owned,
            r'CollectionItem',
            'owned',
          ),
          built: BuiltValueNullFieldError.checkNotNull(
            built,
            r'CollectionItem',
            'built',
          ),
          painted: BuiltValueNullFieldError.checkNotNull(
            painted,
            r'CollectionItem',
            'painted',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
