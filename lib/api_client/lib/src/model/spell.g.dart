// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spell.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SpellDisciplineEnum _$spellDisciplineEnum_bloodRites =
    const SpellDisciplineEnum._('bloodRites');
const SpellDisciplineEnum _$spellDisciplineEnum_divinity =
    const SpellDisciplineEnum._('divinity');
const SpellDisciplineEnum _$spellDisciplineEnum_fateweaving =
    const SpellDisciplineEnum._('fateweaving');
const SpellDisciplineEnum _$spellDisciplineEnum_runesOfSovereignty =
    const SpellDisciplineEnum._('runesOfSovereignty');
const SpellDisciplineEnum _$spellDisciplineEnum_wildMagic =
    const SpellDisciplineEnum._('wildMagic');

SpellDisciplineEnum _$spellDisciplineEnumValueOf(String name) {
  switch (name) {
    case 'bloodRites':
      return _$spellDisciplineEnum_bloodRites;
    case 'divinity':
      return _$spellDisciplineEnum_divinity;
    case 'fateweaving':
      return _$spellDisciplineEnum_fateweaving;
    case 'runesOfSovereignty':
      return _$spellDisciplineEnum_runesOfSovereignty;
    case 'wildMagic':
      return _$spellDisciplineEnum_wildMagic;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SpellDisciplineEnum> _$spellDisciplineEnumValues =
    BuiltSet<SpellDisciplineEnum>(const <SpellDisciplineEnum>[
      _$spellDisciplineEnum_bloodRites,
      _$spellDisciplineEnum_divinity,
      _$spellDisciplineEnum_fateweaving,
      _$spellDisciplineEnum_runesOfSovereignty,
      _$spellDisciplineEnum_wildMagic,
    ]);

Serializer<SpellDisciplineEnum> _$spellDisciplineEnumSerializer =
    _$SpellDisciplineEnumSerializer();

class _$SpellDisciplineEnumSerializer
    implements PrimitiveSerializer<SpellDisciplineEnum> {
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
  final Iterable<Type> types = const <Type>[SpellDisciplineEnum];
  @override
  final String wireName = 'SpellDisciplineEnum';

  @override
  Object serialize(
    Serializers serializers,
    SpellDisciplineEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SpellDisciplineEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SpellDisciplineEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Spell extends Spell {
  @override
  final int id;
  @override
  final String name;
  @override
  final SpellDisciplineEnum discipline;
  @override
  final int cost;
  @override
  final int difficulty;
  @override
  final bool cantrip;
  @override
  final String description;

  factory _$Spell([void Function(SpellBuilder)? updates]) =>
      (SpellBuilder()..update(updates))._build();

  _$Spell._({
    required this.id,
    required this.name,
    required this.discipline,
    required this.cost,
    required this.difficulty,
    required this.cantrip,
    required this.description,
  }) : super._();
  @override
  Spell rebuild(void Function(SpellBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SpellBuilder toBuilder() => SpellBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Spell &&
        id == other.id &&
        name == other.name &&
        discipline == other.discipline &&
        cost == other.cost &&
        difficulty == other.difficulty &&
        cantrip == other.cantrip &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, discipline.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, difficulty.hashCode);
    _$hash = $jc(_$hash, cantrip.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Spell')
          ..add('id', id)
          ..add('name', name)
          ..add('discipline', discipline)
          ..add('cost', cost)
          ..add('difficulty', difficulty)
          ..add('cantrip', cantrip)
          ..add('description', description))
        .toString();
  }
}

class SpellBuilder implements Builder<Spell, SpellBuilder> {
  _$Spell? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SpellDisciplineEnum? _discipline;
  SpellDisciplineEnum? get discipline => _$this._discipline;
  set discipline(SpellDisciplineEnum? discipline) =>
      _$this._discipline = discipline;

  int? _cost;
  int? get cost => _$this._cost;
  set cost(int? cost) => _$this._cost = cost;

  int? _difficulty;
  int? get difficulty => _$this._difficulty;
  set difficulty(int? difficulty) => _$this._difficulty = difficulty;

  bool? _cantrip;
  bool? get cantrip => _$this._cantrip;
  set cantrip(bool? cantrip) => _$this._cantrip = cantrip;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  SpellBuilder() {
    Spell._defaults(this);
  }

  SpellBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _discipline = $v.discipline;
      _cost = $v.cost;
      _difficulty = $v.difficulty;
      _cantrip = $v.cantrip;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Spell other) {
    _$v = other as _$Spell;
  }

  @override
  void update(void Function(SpellBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Spell build() => _build();

  _$Spell _build() {
    final _$result =
        _$v ??
        _$Spell._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Spell', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'Spell', 'name'),
          discipline: BuiltValueNullFieldError.checkNotNull(
            discipline,
            r'Spell',
            'discipline',
          ),
          cost: BuiltValueNullFieldError.checkNotNull(cost, r'Spell', 'cost'),
          difficulty: BuiltValueNullFieldError.checkNotNull(
            difficulty,
            r'Spell',
            'difficulty',
          ),
          cantrip: BuiltValueNullFieldError.checkNotNull(
            cantrip,
            r'Spell',
            'cantrip',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'Spell',
            'description',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
