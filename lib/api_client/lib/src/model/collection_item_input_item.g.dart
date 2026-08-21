// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_item_input_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CollectionItemInputItem extends CollectionItemInputItem {
  @override
  final int? owned;
  @override
  final int? built;
  @override
  final int? painted;

  factory _$CollectionItemInputItem([
    void Function(CollectionItemInputItemBuilder)? updates,
  ]) => (CollectionItemInputItemBuilder()..update(updates))._build();

  _$CollectionItemInputItem._({this.owned, this.built, this.painted})
    : super._();
  @override
  CollectionItemInputItem rebuild(
    void Function(CollectionItemInputItemBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CollectionItemInputItemBuilder toBuilder() =>
      CollectionItemInputItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CollectionItemInputItem &&
        owned == other.owned &&
        built == other.built &&
        painted == other.painted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, owned.hashCode);
    _$hash = $jc(_$hash, built.hashCode);
    _$hash = $jc(_$hash, painted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CollectionItemInputItem')
          ..add('owned', owned)
          ..add('built', built)
          ..add('painted', painted))
        .toString();
  }
}

class CollectionItemInputItemBuilder
    implements
        Builder<CollectionItemInputItem, CollectionItemInputItemBuilder> {
  _$CollectionItemInputItem? _$v;

  int? _owned;
  int? get owned => _$this._owned;
  set owned(int? owned) => _$this._owned = owned;

  int? _built;
  int? get built => _$this._built;
  set built(int? built) => _$this._built = built;

  int? _painted;
  int? get painted => _$this._painted;
  set painted(int? painted) => _$this._painted = painted;

  CollectionItemInputItemBuilder() {
    CollectionItemInputItem._defaults(this);
  }

  CollectionItemInputItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _owned = $v.owned;
      _built = $v.built;
      _painted = $v.painted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CollectionItemInputItem other) {
    _$v = other as _$CollectionItemInputItem;
  }

  @override
  void update(void Function(CollectionItemInputItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CollectionItemInputItem build() => _build();

  _$CollectionItemInputItem _build() {
    final _$result =
        _$v ??
        _$CollectionItemInputItem._(
          owned: owned,
          built: built,
          painted: painted,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
