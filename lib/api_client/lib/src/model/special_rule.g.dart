// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SpecialRule extends SpecialRule {
  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? spellName;
  @override
  final int? spellCost;
  @override
  final int? spellDifficulty;
  @override
  final String? spellDescription;

  factory _$SpecialRule([void Function(SpecialRuleBuilder)? updates]) =>
      (SpecialRuleBuilder()..update(updates))._build();

  _$SpecialRule._({
    required this.id,
    required this.name,
    required this.description,
    this.spellName,
    this.spellCost,
    this.spellDifficulty,
    this.spellDescription,
  }) : super._();
  @override
  SpecialRule rebuild(void Function(SpecialRuleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SpecialRuleBuilder toBuilder() => SpecialRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SpecialRule &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        spellName == other.spellName &&
        spellCost == other.spellCost &&
        spellDifficulty == other.spellDifficulty &&
        spellDescription == other.spellDescription;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, spellName.hashCode);
    _$hash = $jc(_$hash, spellCost.hashCode);
    _$hash = $jc(_$hash, spellDifficulty.hashCode);
    _$hash = $jc(_$hash, spellDescription.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SpecialRule')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('spellName', spellName)
          ..add('spellCost', spellCost)
          ..add('spellDifficulty', spellDifficulty)
          ..add('spellDescription', spellDescription))
        .toString();
  }
}

class SpecialRuleBuilder implements Builder<SpecialRule, SpecialRuleBuilder> {
  _$SpecialRule? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _spellName;
  String? get spellName => _$this._spellName;
  set spellName(String? spellName) => _$this._spellName = spellName;

  int? _spellCost;
  int? get spellCost => _$this._spellCost;
  set spellCost(int? spellCost) => _$this._spellCost = spellCost;

  int? _spellDifficulty;
  int? get spellDifficulty => _$this._spellDifficulty;
  set spellDifficulty(int? spellDifficulty) =>
      _$this._spellDifficulty = spellDifficulty;

  String? _spellDescription;
  String? get spellDescription => _$this._spellDescription;
  set spellDescription(String? spellDescription) =>
      _$this._spellDescription = spellDescription;

  SpecialRuleBuilder() {
    SpecialRule._defaults(this);
  }

  SpecialRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _spellName = $v.spellName;
      _spellCost = $v.spellCost;
      _spellDifficulty = $v.spellDifficulty;
      _spellDescription = $v.spellDescription;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SpecialRule other) {
    _$v = other as _$SpecialRule;
  }

  @override
  void update(void Function(SpecialRuleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SpecialRule build() => _build();

  _$SpecialRule _build() {
    final _$result =
        _$v ??
        _$SpecialRule._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'SpecialRule', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'SpecialRule',
            'name',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'SpecialRule',
            'description',
          ),
          spellName: spellName,
          spellCost: spellCost,
          spellDifficulty: spellDifficulty,
          spellDescription: spellDescription,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
