// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weapon.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Weapon extends Weapon {
  @override
  final int id;
  @override
  final String name;
  @override
  final int damage;
  @override
  final int range;
  @override
  final int penetration;
  @override
  final int evasion;
  @override
  final BuiltList<String> abilities;

  factory _$Weapon([void Function(WeaponBuilder)? updates]) =>
      (WeaponBuilder()..update(updates))._build();

  _$Weapon._({
    required this.id,
    required this.name,
    required this.damage,
    required this.range,
    required this.penetration,
    required this.evasion,
    required this.abilities,
  }) : super._();
  @override
  Weapon rebuild(void Function(WeaponBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WeaponBuilder toBuilder() => WeaponBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Weapon &&
        id == other.id &&
        name == other.name &&
        damage == other.damage &&
        range == other.range &&
        penetration == other.penetration &&
        evasion == other.evasion &&
        abilities == other.abilities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, damage.hashCode);
    _$hash = $jc(_$hash, range.hashCode);
    _$hash = $jc(_$hash, penetration.hashCode);
    _$hash = $jc(_$hash, evasion.hashCode);
    _$hash = $jc(_$hash, abilities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Weapon')
          ..add('id', id)
          ..add('name', name)
          ..add('damage', damage)
          ..add('range', range)
          ..add('penetration', penetration)
          ..add('evasion', evasion)
          ..add('abilities', abilities))
        .toString();
  }
}

class WeaponBuilder implements Builder<Weapon, WeaponBuilder> {
  _$Weapon? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _damage;
  int? get damage => _$this._damage;
  set damage(int? damage) => _$this._damage = damage;

  int? _range;
  int? get range => _$this._range;
  set range(int? range) => _$this._range = range;

  int? _penetration;
  int? get penetration => _$this._penetration;
  set penetration(int? penetration) => _$this._penetration = penetration;

  int? _evasion;
  int? get evasion => _$this._evasion;
  set evasion(int? evasion) => _$this._evasion = evasion;

  ListBuilder<String>? _abilities;
  ListBuilder<String> get abilities =>
      _$this._abilities ??= ListBuilder<String>();
  set abilities(ListBuilder<String>? abilities) =>
      _$this._abilities = abilities;

  WeaponBuilder() {
    Weapon._defaults(this);
  }

  WeaponBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _damage = $v.damage;
      _range = $v.range;
      _penetration = $v.penetration;
      _evasion = $v.evasion;
      _abilities = $v.abilities.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Weapon other) {
    _$v = other as _$Weapon;
  }

  @override
  void update(void Function(WeaponBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Weapon build() => _build();

  _$Weapon _build() {
    _$Weapon _$result;
    try {
      _$result =
          _$v ??
          _$Weapon._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Weapon', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'Weapon',
              'name',
            ),
            damage: BuiltValueNullFieldError.checkNotNull(
              damage,
              r'Weapon',
              'damage',
            ),
            range: BuiltValueNullFieldError.checkNotNull(
              range,
              r'Weapon',
              'range',
            ),
            penetration: BuiltValueNullFieldError.checkNotNull(
              penetration,
              r'Weapon',
              'penetration',
            ),
            evasion: BuiltValueNullFieldError.checkNotNull(
              evasion,
              r'Weapon',
              'evasion',
            ),
            abilities: abilities.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'abilities';
        abilities.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Weapon',
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
