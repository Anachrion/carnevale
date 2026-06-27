// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_input_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListInputList extends ListInputList {
  @override
  final String? name;
  @override
  final String faction;
  @override
  final int? points;

  factory _$ListInputList([void Function(ListInputListBuilder)? updates]) =>
      (ListInputListBuilder()..update(updates))._build();

  _$ListInputList._({this.name, required this.faction, this.points})
    : super._();
  @override
  ListInputList rebuild(void Function(ListInputListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListInputListBuilder toBuilder() => ListInputListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListInputList &&
        name == other.name &&
        faction == other.faction &&
        points == other.points;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, faction.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListInputList')
          ..add('name', name)
          ..add('faction', faction)
          ..add('points', points))
        .toString();
  }
}

class ListInputListBuilder
    implements Builder<ListInputList, ListInputListBuilder> {
  _$ListInputList? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _faction;
  String? get faction => _$this._faction;
  set faction(String? faction) => _$this._faction = faction;

  int? _points;
  int? get points => _$this._points;
  set points(int? points) => _$this._points = points;

  ListInputListBuilder() {
    ListInputList._defaults(this);
  }

  ListInputListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _faction = $v.faction;
      _points = $v.points;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListInputList other) {
    _$v = other as _$ListInputList;
  }

  @override
  void update(void Function(ListInputListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListInputList build() => _build();

  _$ListInputList _build() {
    final _$result =
        _$v ??
        _$ListInputList._(
          name: name,
          faction: BuiltValueNullFieldError.checkNotNull(
            faction,
            r'ListInputList',
            'faction',
          ),
          points: points,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
