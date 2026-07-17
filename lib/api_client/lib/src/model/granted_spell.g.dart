// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'granted_spell.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GrantedSpellDisciplineEnum _$grantedSpellDisciplineEnum_bloodRites =
    const GrantedSpellDisciplineEnum._('bloodRites');
const GrantedSpellDisciplineEnum _$grantedSpellDisciplineEnum_divinity =
    const GrantedSpellDisciplineEnum._('divinity');
const GrantedSpellDisciplineEnum _$grantedSpellDisciplineEnum_fateweaving =
    const GrantedSpellDisciplineEnum._('fateweaving');
const GrantedSpellDisciplineEnum
_$grantedSpellDisciplineEnum_runesOfSovereignty =
    const GrantedSpellDisciplineEnum._('runesOfSovereignty');
const GrantedSpellDisciplineEnum _$grantedSpellDisciplineEnum_wildMagic =
    const GrantedSpellDisciplineEnum._('wildMagic');

GrantedSpellDisciplineEnum _$grantedSpellDisciplineEnumValueOf(String name) {
  switch (name) {
    case 'bloodRites':
      return _$grantedSpellDisciplineEnum_bloodRites;
    case 'divinity':
      return _$grantedSpellDisciplineEnum_divinity;
    case 'fateweaving':
      return _$grantedSpellDisciplineEnum_fateweaving;
    case 'runesOfSovereignty':
      return _$grantedSpellDisciplineEnum_runesOfSovereignty;
    case 'wildMagic':
      return _$grantedSpellDisciplineEnum_wildMagic;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GrantedSpellDisciplineEnum> _$grantedSpellDisciplineEnumValues =
    BuiltSet<GrantedSpellDisciplineEnum>(const <GrantedSpellDisciplineEnum>[
      _$grantedSpellDisciplineEnum_bloodRites,
      _$grantedSpellDisciplineEnum_divinity,
      _$grantedSpellDisciplineEnum_fateweaving,
      _$grantedSpellDisciplineEnum_runesOfSovereignty,
      _$grantedSpellDisciplineEnum_wildMagic,
    ]);

Serializer<GrantedSpellDisciplineEnum> _$grantedSpellDisciplineEnumSerializer =
    _$GrantedSpellDisciplineEnumSerializer();

class _$GrantedSpellDisciplineEnumSerializer
    implements PrimitiveSerializer<GrantedSpellDisciplineEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bloodRites': 'blood_rites',
    'divinity': 'divinity',
    'fateweaving': 'fateweaving',
    'runesOfSovereignty': 'runes_of_sovereignty',
    'wildMagic': 'wild_magic',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'blood_rites': 'bloodRites',
    'divinity': 'divinity',
    'fateweaving': 'fateweaving',
    'runes_of_sovereignty': 'runesOfSovereignty',
    'wild_magic': 'wildMagic',
  };

  @override
  final Iterable<Type> types = const <Type>[GrantedSpellDisciplineEnum];
  @override
  final String wireName = 'GrantedSpellDisciplineEnum';

  @override
  Object serialize(
    Serializers serializers,
    GrantedSpellDisciplineEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  GrantedSpellDisciplineEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => GrantedSpellDisciplineEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$GrantedSpell extends GrantedSpell {
  @override
  final String key;
  @override
  final int? id;
  @override
  final GrantedSpellDisciplineEnum? discipline;
  @override
  final String name;
  @override
  final int? cost;
  @override
  final int? difficulty;
  @override
  final String? description;
  @override
  final bool cantrip;
  @override
  final bool consumesSlot;
  @override
  final bool resetsEachRound;
  @override
  final SpellRuleRef? rule;
  @override
  final bool cast;

  factory _$GrantedSpell([void Function(GrantedSpellBuilder)? updates]) =>
      (GrantedSpellBuilder()..update(updates))._build();

  _$GrantedSpell._({
    required this.key,
    this.id,
    this.discipline,
    required this.name,
    this.cost,
    this.difficulty,
    this.description,
    required this.cantrip,
    required this.consumesSlot,
    required this.resetsEachRound,
    this.rule,
    required this.cast,
  }) : super._();
  @override
  GrantedSpell rebuild(void Function(GrantedSpellBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GrantedSpellBuilder toBuilder() => GrantedSpellBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GrantedSpell &&
        key == other.key &&
        id == other.id &&
        discipline == other.discipline &&
        name == other.name &&
        cost == other.cost &&
        difficulty == other.difficulty &&
        description == other.description &&
        cantrip == other.cantrip &&
        consumesSlot == other.consumesSlot &&
        resetsEachRound == other.resetsEachRound &&
        rule == other.rule &&
        cast == other.cast;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, discipline.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, difficulty.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, cantrip.hashCode);
    _$hash = $jc(_$hash, consumesSlot.hashCode);
    _$hash = $jc(_$hash, resetsEachRound.hashCode);
    _$hash = $jc(_$hash, rule.hashCode);
    _$hash = $jc(_$hash, cast.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GrantedSpell')
          ..add('key', key)
          ..add('id', id)
          ..add('discipline', discipline)
          ..add('name', name)
          ..add('cost', cost)
          ..add('difficulty', difficulty)
          ..add('description', description)
          ..add('cantrip', cantrip)
          ..add('consumesSlot', consumesSlot)
          ..add('resetsEachRound', resetsEachRound)
          ..add('rule', rule)
          ..add('cast', cast))
        .toString();
  }
}

class GrantedSpellBuilder
    implements Builder<GrantedSpell, GrantedSpellBuilder> {
  _$GrantedSpell? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  GrantedSpellDisciplineEnum? _discipline;
  GrantedSpellDisciplineEnum? get discipline => _$this._discipline;
  set discipline(GrantedSpellDisciplineEnum? discipline) =>
      _$this._discipline = discipline;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _cost;
  int? get cost => _$this._cost;
  set cost(int? cost) => _$this._cost = cost;

  int? _difficulty;
  int? get difficulty => _$this._difficulty;
  set difficulty(int? difficulty) => _$this._difficulty = difficulty;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _cantrip;
  bool? get cantrip => _$this._cantrip;
  set cantrip(bool? cantrip) => _$this._cantrip = cantrip;

  bool? _consumesSlot;
  bool? get consumesSlot => _$this._consumesSlot;
  set consumesSlot(bool? consumesSlot) => _$this._consumesSlot = consumesSlot;

  bool? _resetsEachRound;
  bool? get resetsEachRound => _$this._resetsEachRound;
  set resetsEachRound(bool? resetsEachRound) =>
      _$this._resetsEachRound = resetsEachRound;

  SpellRuleRefBuilder? _rule;
  SpellRuleRefBuilder get rule => _$this._rule ??= SpellRuleRefBuilder();
  set rule(SpellRuleRefBuilder? rule) => _$this._rule = rule;

  bool? _cast;
  bool? get cast => _$this._cast;
  set cast(bool? cast) => _$this._cast = cast;

  GrantedSpellBuilder() {
    GrantedSpell._defaults(this);
  }

  GrantedSpellBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _id = $v.id;
      _discipline = $v.discipline;
      _name = $v.name;
      _cost = $v.cost;
      _difficulty = $v.difficulty;
      _description = $v.description;
      _cantrip = $v.cantrip;
      _consumesSlot = $v.consumesSlot;
      _resetsEachRound = $v.resetsEachRound;
      _rule = $v.rule?.toBuilder();
      _cast = $v.cast;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GrantedSpell other) {
    _$v = other as _$GrantedSpell;
  }

  @override
  void update(void Function(GrantedSpellBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GrantedSpell build() => _build();

  _$GrantedSpell _build() {
    _$GrantedSpell _$result;
    try {
      _$result =
          _$v ??
          _$GrantedSpell._(
            key: BuiltValueNullFieldError.checkNotNull(
              key,
              r'GrantedSpell',
              'key',
            ),
            id: id,
            discipline: discipline,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'GrantedSpell',
              'name',
            ),
            cost: cost,
            difficulty: difficulty,
            description: description,
            cantrip: BuiltValueNullFieldError.checkNotNull(
              cantrip,
              r'GrantedSpell',
              'cantrip',
            ),
            consumesSlot: BuiltValueNullFieldError.checkNotNull(
              consumesSlot,
              r'GrantedSpell',
              'consumesSlot',
            ),
            resetsEachRound: BuiltValueNullFieldError.checkNotNull(
              resetsEachRound,
              r'GrantedSpell',
              'resetsEachRound',
            ),
            rule: _rule?.build(),
            cast: BuiltValueNullFieldError.checkNotNull(
              cast,
              r'GrantedSpell',
              'cast',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rule';
        _rule?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GrantedSpell',
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
