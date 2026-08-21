// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_item_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CollectionItemInput extends CollectionItemInput {
  @override
  final CollectionItemInputItem item;

  factory _$CollectionItemInput([
    void Function(CollectionItemInputBuilder)? updates,
  ]) => (CollectionItemInputBuilder()..update(updates))._build();

  _$CollectionItemInput._({required this.item}) : super._();
  @override
  CollectionItemInput rebuild(
    void Function(CollectionItemInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CollectionItemInputBuilder toBuilder() =>
      CollectionItemInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CollectionItemInput && item == other.item;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CollectionItemInput',
    )..add('item', item)).toString();
  }
}

class CollectionItemInputBuilder
    implements Builder<CollectionItemInput, CollectionItemInputBuilder> {
  _$CollectionItemInput? _$v;

  CollectionItemInputItemBuilder? _item;
  CollectionItemInputItemBuilder get item =>
      _$this._item ??= CollectionItemInputItemBuilder();
  set item(CollectionItemInputItemBuilder? item) => _$this._item = item;

  CollectionItemInputBuilder() {
    CollectionItemInput._defaults(this);
  }

  CollectionItemInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CollectionItemInput other) {
    _$v = other as _$CollectionItemInput;
  }

  @override
  void update(void Function(CollectionItemInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CollectionItemInput build() => _build();

  _$CollectionItemInput _build() {
    _$CollectionItemInput _$result;
    try {
      _$result = _$v ?? _$CollectionItemInput._(item: item.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        item.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CollectionItemInput',
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
