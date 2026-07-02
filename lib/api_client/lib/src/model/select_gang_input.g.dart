// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_gang_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SelectGangInput extends SelectGangInput {
  @override
  final int listId;

  factory _$SelectGangInput([void Function(SelectGangInputBuilder)? updates]) =>
      (SelectGangInputBuilder()..update(updates))._build();

  _$SelectGangInput._({required this.listId}) : super._();
  @override
  SelectGangInput rebuild(void Function(SelectGangInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SelectGangInputBuilder toBuilder() => SelectGangInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SelectGangInput && listId == other.listId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'SelectGangInput',
    )..add('listId', listId)).toString();
  }
}

class SelectGangInputBuilder
    implements Builder<SelectGangInput, SelectGangInputBuilder> {
  _$SelectGangInput? _$v;

  int? _listId;
  int? get listId => _$this._listId;
  set listId(int? listId) => _$this._listId = listId;

  SelectGangInputBuilder() {
    SelectGangInput._defaults(this);
  }

  SelectGangInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listId = $v.listId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SelectGangInput other) {
    _$v = other as _$SelectGangInput;
  }

  @override
  void update(void Function(SelectGangInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SelectGangInput build() => _build();

  _$SelectGangInput _build() {
    final _$result =
        _$v ??
        _$SelectGangInput._(
          listId: BuiltValueNullFieldError.checkNotNull(
            listId,
            r'SelectGangInput',
            'listId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
