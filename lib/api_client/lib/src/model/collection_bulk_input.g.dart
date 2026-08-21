// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_bulk_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CollectionBulkInput extends CollectionBulkInput {
  @override
  final BuiltList<CollectionBulkInputItemsInner> items;

  factory _$CollectionBulkInput([
    void Function(CollectionBulkInputBuilder)? updates,
  ]) => (CollectionBulkInputBuilder()..update(updates))._build();

  _$CollectionBulkInput._({required this.items}) : super._();
  @override
  CollectionBulkInput rebuild(
    void Function(CollectionBulkInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CollectionBulkInputBuilder toBuilder() =>
      CollectionBulkInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CollectionBulkInput && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CollectionBulkInput',
    )..add('items', items)).toString();
  }
}

class CollectionBulkInputBuilder
    implements Builder<CollectionBulkInput, CollectionBulkInputBuilder> {
  _$CollectionBulkInput? _$v;

  ListBuilder<CollectionBulkInputItemsInner>? _items;
  ListBuilder<CollectionBulkInputItemsInner> get items =>
      _$this._items ??= ListBuilder<CollectionBulkInputItemsInner>();
  set items(ListBuilder<CollectionBulkInputItemsInner>? items) =>
      _$this._items = items;

  CollectionBulkInputBuilder() {
    CollectionBulkInput._defaults(this);
  }

  CollectionBulkInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CollectionBulkInput other) {
    _$v = other as _$CollectionBulkInput;
  }

  @override
  void update(void Function(CollectionBulkInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CollectionBulkInput build() => _build();

  _$CollectionBulkInput _build() {
    _$CollectionBulkInput _$result;
    try {
      _$result = _$v ?? _$CollectionBulkInput._(items: items.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CollectionBulkInput',
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
