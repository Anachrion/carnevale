// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Equipment extends Equipment {
  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int cost;

  factory _$Equipment([void Function(EquipmentBuilder)? updates]) =>
      (EquipmentBuilder()..update(updates))._build();

  _$Equipment._({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
  }) : super._();
  @override
  Equipment rebuild(void Function(EquipmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EquipmentBuilder toBuilder() => EquipmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Equipment &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        cost == other.cost;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Equipment')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('cost', cost))
        .toString();
  }
}

class EquipmentBuilder implements Builder<Equipment, EquipmentBuilder> {
  _$Equipment? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _cost;
  int? get cost => _$this._cost;
  set cost(int? cost) => _$this._cost = cost;

  EquipmentBuilder() {
    Equipment._defaults(this);
  }

  EquipmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _cost = $v.cost;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Equipment other) {
    _$v = other as _$Equipment;
  }

  @override
  void update(void Function(EquipmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Equipment build() => _build();

  _$Equipment _build() {
    final _$result =
        _$v ??
        _$Equipment._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Equipment', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'Equipment',
            'name',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'Equipment',
            'description',
          ),
          cost: BuiltValueNullFieldError.checkNotNull(
            cost,
            r'Equipment',
            'cost',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
