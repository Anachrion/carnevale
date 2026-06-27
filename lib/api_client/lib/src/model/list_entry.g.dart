// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListEntry extends ListEntry {
  @override
  final int id;
  @override
  final int position;
  @override
  final int cardReferenceId;
  @override
  final String name;
  @override
  final int cost;

  factory _$ListEntry([void Function(ListEntryBuilder)? updates]) =>
      (ListEntryBuilder()..update(updates))._build();

  _$ListEntry._({
    required this.id,
    required this.position,
    required this.cardReferenceId,
    required this.name,
    required this.cost,
  }) : super._();
  @override
  ListEntry rebuild(void Function(ListEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListEntryBuilder toBuilder() => ListEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListEntry &&
        id == other.id &&
        position == other.position &&
        cardReferenceId == other.cardReferenceId &&
        name == other.name &&
        cost == other.cost;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, cardReferenceId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListEntry')
          ..add('id', id)
          ..add('position', position)
          ..add('cardReferenceId', cardReferenceId)
          ..add('name', name)
          ..add('cost', cost))
        .toString();
  }
}

class ListEntryBuilder implements Builder<ListEntry, ListEntryBuilder> {
  _$ListEntry? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  int? _cardReferenceId;
  int? get cardReferenceId => _$this._cardReferenceId;
  set cardReferenceId(int? cardReferenceId) =>
      _$this._cardReferenceId = cardReferenceId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _cost;
  int? get cost => _$this._cost;
  set cost(int? cost) => _$this._cost = cost;

  ListEntryBuilder() {
    ListEntry._defaults(this);
  }

  ListEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _position = $v.position;
      _cardReferenceId = $v.cardReferenceId;
      _name = $v.name;
      _cost = $v.cost;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListEntry other) {
    _$v = other as _$ListEntry;
  }

  @override
  void update(void Function(ListEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListEntry build() => _build();

  _$ListEntry _build() {
    final _$result =
        _$v ??
        _$ListEntry._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ListEntry', 'id'),
          position: BuiltValueNullFieldError.checkNotNull(
            position,
            r'ListEntry',
            'position',
          ),
          cardReferenceId: BuiltValueNullFieldError.checkNotNull(
            cardReferenceId,
            r'ListEntry',
            'cardReferenceId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'ListEntry',
            'name',
          ),
          cost: BuiltValueNullFieldError.checkNotNull(
            cost,
            r'ListEntry',
            'cost',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
