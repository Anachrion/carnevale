// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_gang.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AvailableGang extends AvailableGang {
  @override
  final BuiltList<dynamic> list;
  @override
  final bool selectable;

  factory _$AvailableGang([void Function(AvailableGangBuilder)? updates]) =>
      (AvailableGangBuilder()..update(updates))._build();

  _$AvailableGang._({required this.list, required this.selectable}) : super._();
  @override
  AvailableGang rebuild(void Function(AvailableGangBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AvailableGangBuilder toBuilder() => AvailableGangBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AvailableGang &&
        list == other.list &&
        selectable == other.selectable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, selectable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AvailableGang')
          ..add('list', list)
          ..add('selectable', selectable))
        .toString();
  }
}

class AvailableGangBuilder
    implements Builder<AvailableGang, AvailableGangBuilder> {
  _$AvailableGang? _$v;

  ListBuilder<dynamic>? _list;
  ListBuilder<dynamic> get list => _$this._list ??= ListBuilder<dynamic>();
  set list(ListBuilder<dynamic>? list) => _$this._list = list;

  bool? _selectable;
  bool? get selectable => _$this._selectable;
  set selectable(bool? selectable) => _$this._selectable = selectable;

  AvailableGangBuilder() {
    AvailableGang._defaults(this);
  }

  AvailableGangBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _list = $v.list.toBuilder();
      _selectable = $v.selectable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AvailableGang other) {
    _$v = other as _$AvailableGang;
  }

  @override
  void update(void Function(AvailableGangBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AvailableGang build() => _build();

  _$AvailableGang _build() {
    _$AvailableGang _$result;
    try {
      _$result =
          _$v ??
          _$AvailableGang._(
            list: list.build(),
            selectable: BuiltValueNullFieldError.checkNotNull(
              selectable,
              r'AvailableGang',
              'selectable',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'list';
        list.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AvailableGang',
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
