// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListInput extends ListInput {
  @override
  final ListInputList list;

  factory _$ListInput([void Function(ListInputBuilder)? updates]) =>
      (ListInputBuilder()..update(updates))._build();

  _$ListInput._({required this.list}) : super._();
  @override
  ListInput rebuild(void Function(ListInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListInputBuilder toBuilder() => ListInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListInput && list == other.list;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ListInput',
    )..add('list', list)).toString();
  }
}

class ListInputBuilder implements Builder<ListInput, ListInputBuilder> {
  _$ListInput? _$v;

  ListInputListBuilder? _list;
  ListInputListBuilder get list => _$this._list ??= ListInputListBuilder();
  set list(ListInputListBuilder? list) => _$this._list = list;

  ListInputBuilder() {
    ListInput._defaults(this);
  }

  ListInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _list = $v.list.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListInput other) {
    _$v = other as _$ListInput;
  }

  @override
  void update(void Function(ListInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListInput build() => _build();

  _$ListInput _build() {
    _$ListInput _$result;
    try {
      _$result = _$v ?? _$ListInput._(list: list.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'list';
        list.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ListInput',
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
