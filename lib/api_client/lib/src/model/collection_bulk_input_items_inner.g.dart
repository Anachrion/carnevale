// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_bulk_input_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CollectionBulkInputItemsInner extends CollectionBulkInputItemsInner {
  @override
  final int profileId;
  @override
  final int? owned;
  @override
  final int? built;
  @override
  final int? painted;

  factory _$CollectionBulkInputItemsInner([
    void Function(CollectionBulkInputItemsInnerBuilder)? updates,
  ]) => (CollectionBulkInputItemsInnerBuilder()..update(updates))._build();

  _$CollectionBulkInputItemsInner._({
    required this.profileId,
    this.owned,
    this.built,
    this.painted,
  }) : super._();
  @override
  CollectionBulkInputItemsInner rebuild(
    void Function(CollectionBulkInputItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CollectionBulkInputItemsInnerBuilder toBuilder() =>
      CollectionBulkInputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CollectionBulkInputItemsInner &&
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
    return (newBuiltValueToStringHelper(r'CollectionBulkInputItemsInner')
          ..add('profileId', profileId)
          ..add('owned', owned)
          ..add('built', built)
          ..add('painted', painted))
        .toString();
  }
}

class CollectionBulkInputItemsInnerBuilder
    implements
        Builder<
          CollectionBulkInputItemsInner,
          CollectionBulkInputItemsInnerBuilder
        > {
  _$CollectionBulkInputItemsInner? _$v;

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

  CollectionBulkInputItemsInnerBuilder() {
    CollectionBulkInputItemsInner._defaults(this);
  }

  CollectionBulkInputItemsInnerBuilder get _$this {
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
  void replace(CollectionBulkInputItemsInner other) {
    _$v = other as _$CollectionBulkInputItemsInner;
  }

  @override
  void update(void Function(CollectionBulkInputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CollectionBulkInputItemsInner build() => _build();

  _$CollectionBulkInputItemsInner _build() {
    final _$result =
        _$v ??
        _$CollectionBulkInputItemsInner._(
          profileId: BuiltValueNullFieldError.checkNotNull(
            profileId,
            r'CollectionBulkInputItemsInner',
            'profileId',
          ),
          owned: owned,
          built: built,
          painted: painted,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
