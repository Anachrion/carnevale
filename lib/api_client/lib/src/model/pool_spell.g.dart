// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool_spell.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PoolSpellDisciplineEnum _$poolSpellDisciplineEnum_bloodRites =
    const PoolSpellDisciplineEnum._('bloodRites');
const PoolSpellDisciplineEnum _$poolSpellDisciplineEnum_divinity =
    const PoolSpellDisciplineEnum._('divinity');
const PoolSpellDisciplineEnum _$poolSpellDisciplineEnum_fateweaving =
    const PoolSpellDisciplineEnum._('fateweaving');
const PoolSpellDisciplineEnum _$poolSpellDisciplineEnum_runesOfSovereignty =
    const PoolSpellDisciplineEnum._('runesOfSovereignty');
const PoolSpellDisciplineEnum _$poolSpellDisciplineEnum_wildMagic =
    const PoolSpellDisciplineEnum._('wildMagic');

PoolSpellDisciplineEnum _$poolSpellDisciplineEnumValueOf(String name) {
  switch (name) {
    case 'bloodRites':
      return _$poolSpellDisciplineEnum_bloodRites;
    case 'divinity':
      return _$poolSpellDisciplineEnum_divinity;
    case 'fateweaving':
      return _$poolSpellDisciplineEnum_fateweaving;
    case 'runesOfSovereignty':
      return _$poolSpellDisciplineEnum_runesOfSovereignty;
    case 'wildMagic':
      return _$poolSpellDisciplineEnum_wildMagic;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PoolSpellDisciplineEnum> _$poolSpellDisciplineEnumValues =
    BuiltSet<PoolSpellDisciplineEnum>(const <PoolSpellDisciplineEnum>[
      _$poolSpellDisciplineEnum_bloodRites,
      _$poolSpellDisciplineEnum_divinity,
      _$poolSpellDisciplineEnum_fateweaving,
      _$poolSpellDisciplineEnum_runesOfSovereignty,
      _$poolSpellDisciplineEnum_wildMagic,
    ]);

Serializer<PoolSpellDisciplineEnum> _$poolSpellDisciplineEnumSerializer =
    _$PoolSpellDisciplineEnumSerializer();

class _$PoolSpellDisciplineEnumSerializer
    implements PrimitiveSerializer<PoolSpellDisciplineEnum> {
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
  final Iterable<Type> types = const <Type>[PoolSpellDisciplineEnum];
  @override
  final String wireName = 'PoolSpellDisciplineEnum';

  @override
  Object serialize(
    Serializers serializers,
    PoolSpellDisciplineEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PoolSpellDisciplineEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PoolSpellDisciplineEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$PoolSpell extends PoolSpell {
  @override
  final String key;
  @override
  final int id;
  @override
  final String name;
  @override
  final PoolSpellDisciplineEnum discipline;
  @override
  final int cost;
  @override
  final int difficulty;
  @override
  final bool cantrip;
  @override
  final String description;
  @override
  final bool cast;

  factory _$PoolSpell([void Function(PoolSpellBuilder)? updates]) =>
      (PoolSpellBuilder()..update(updates))._build();

  _$PoolSpell._({
    required this.key,
    required this.id,
    required this.name,
    required this.discipline,
    required this.cost,
    required this.difficulty,
    required this.cantrip,
    required this.description,
    required this.cast,
  }) : super._();
  @override
  PoolSpell rebuild(void Function(PoolSpellBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PoolSpellBuilder toBuilder() => PoolSpellBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PoolSpell &&
        key == other.key &&
        id == other.id &&
        name == other.name &&
        discipline == other.discipline &&
        cost == other.cost &&
        difficulty == other.difficulty &&
        cantrip == other.cantrip &&
        description == other.description &&
        cast == other.cast;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, discipline.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, difficulty.hashCode);
    _$hash = $jc(_$hash, cantrip.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, cast.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PoolSpell')
          ..add('key', key)
          ..add('id', id)
          ..add('name', name)
          ..add('discipline', discipline)
          ..add('cost', cost)
          ..add('difficulty', difficulty)
          ..add('cantrip', cantrip)
          ..add('description', description)
          ..add('cast', cast))
        .toString();
  }
}

class PoolSpellBuilder implements Builder<PoolSpell, PoolSpellBuilder> {
  _$PoolSpell? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PoolSpellDisciplineEnum? _discipline;
  PoolSpellDisciplineEnum? get discipline => _$this._discipline;
  set discipline(PoolSpellDisciplineEnum? discipline) =>
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

  bool? _cast;
  bool? get cast => _$this._cast;
  set cast(bool? cast) => _$this._cast = cast;

  PoolSpellBuilder() {
    PoolSpell._defaults(this);
  }

  PoolSpellBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _id = $v.id;
      _name = $v.name;
      _discipline = $v.discipline;
      _cost = $v.cost;
      _difficulty = $v.difficulty;
      _cantrip = $v.cantrip;
      _description = $v.description;
      _cast = $v.cast;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PoolSpell other) {
    _$v = other as _$PoolSpell;
  }

  @override
  void update(void Function(PoolSpellBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PoolSpell build() => _build();

  _$PoolSpell _build() {
    final _$result =
        _$v ??
        _$PoolSpell._(
          key: BuiltValueNullFieldError.checkNotNull(key, r'PoolSpell', 'key'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'PoolSpell', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'PoolSpell',
            'name',
          ),
          discipline: BuiltValueNullFieldError.checkNotNull(
            discipline,
            r'PoolSpell',
            'discipline',
          ),
          cost: BuiltValueNullFieldError.checkNotNull(
            cost,
            r'PoolSpell',
            'cost',
          ),
          difficulty: BuiltValueNullFieldError.checkNotNull(
            difficulty,
            r'PoolSpell',
            'difficulty',
          ),
          cantrip: BuiltValueNullFieldError.checkNotNull(
            cantrip,
            r'PoolSpell',
            'cantrip',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'PoolSpell',
            'description',
          ),
          cast: BuiltValueNullFieldError.checkNotNull(
            cast,
            r'PoolSpell',
            'cast',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
