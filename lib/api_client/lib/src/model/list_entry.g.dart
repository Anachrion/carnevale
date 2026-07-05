// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListEntryEntryTypeEnum
_$listEntryEntryTypeEnum_catalogColonColonCardReference =
    const ListEntryEntryTypeEnum._('catalogColonColonCardReference');
const ListEntryEntryTypeEnum
_$listEntryEntryTypeEnum_catalogColonColonEquipment =
    const ListEntryEntryTypeEnum._('catalogColonColonEquipment');

ListEntryEntryTypeEnum _$listEntryEntryTypeEnumValueOf(String name) {
  switch (name) {
    case 'catalogColonColonCardReference':
      return _$listEntryEntryTypeEnum_catalogColonColonCardReference;
    case 'catalogColonColonEquipment':
      return _$listEntryEntryTypeEnum_catalogColonColonEquipment;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListEntryEntryTypeEnum> _$listEntryEntryTypeEnumValues =
    BuiltSet<ListEntryEntryTypeEnum>(const <ListEntryEntryTypeEnum>[
      _$listEntryEntryTypeEnum_catalogColonColonCardReference,
      _$listEntryEntryTypeEnum_catalogColonColonEquipment,
    ]);

Serializer<ListEntryEntryTypeEnum> _$listEntryEntryTypeEnumSerializer =
    _$ListEntryEntryTypeEnumSerializer();

class _$ListEntryEntryTypeEnumSerializer
    implements PrimitiveSerializer<ListEntryEntryTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'catalogColonColonCardReference': 'Catalog::CardReference',
    'catalogColonColonEquipment': 'Catalog::Equipment',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Catalog::CardReference': 'catalogColonColonCardReference',
    'Catalog::Equipment': 'catalogColonColonEquipment',
  };

  @override
  final Iterable<Type> types = const <Type>[ListEntryEntryTypeEnum];
  @override
  final String wireName = 'ListEntryEntryTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ListEntryEntryTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ListEntryEntryTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ListEntryEntryTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ListEntry extends ListEntry {
  @override
  final int id;
  @override
  final int position;
  @override
  final ListEntryEntryTypeEnum entryType;
  @override
  final int entryId;
  @override
  final String name;
  @override
  final int cost;
  @override
  final EntryState? state;
  @override
  final bool mage;
  @override
  final int spellSlots;
  @override
  final BuiltList<String> disciplines;
  @override
  final String? spellDiscipline;
  @override
  final Spell? cantrip;
  @override
  final BuiltList<Spell> spells;

  factory _$ListEntry([void Function(ListEntryBuilder)? updates]) =>
      (ListEntryBuilder()..update(updates))._build();

  _$ListEntry._({
    required this.id,
    required this.position,
    required this.entryType,
    required this.entryId,
    required this.name,
    required this.cost,
    this.state,
    required this.mage,
    required this.spellSlots,
    required this.disciplines,
    this.spellDiscipline,
    this.cantrip,
    required this.spells,
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
        entryType == other.entryType &&
        entryId == other.entryId &&
        name == other.name &&
        cost == other.cost &&
        state == other.state &&
        mage == other.mage &&
        spellSlots == other.spellSlots &&
        disciplines == other.disciplines &&
        spellDiscipline == other.spellDiscipline &&
        cantrip == other.cantrip &&
        spells == other.spells;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, entryType.hashCode);
    _$hash = $jc(_$hash, entryId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, mage.hashCode);
    _$hash = $jc(_$hash, spellSlots.hashCode);
    _$hash = $jc(_$hash, disciplines.hashCode);
    _$hash = $jc(_$hash, spellDiscipline.hashCode);
    _$hash = $jc(_$hash, cantrip.hashCode);
    _$hash = $jc(_$hash, spells.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListEntry')
          ..add('id', id)
          ..add('position', position)
          ..add('entryType', entryType)
          ..add('entryId', entryId)
          ..add('name', name)
          ..add('cost', cost)
          ..add('state', state)
          ..add('mage', mage)
          ..add('spellSlots', spellSlots)
          ..add('disciplines', disciplines)
          ..add('spellDiscipline', spellDiscipline)
          ..add('cantrip', cantrip)
          ..add('spells', spells))
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

  ListEntryEntryTypeEnum? _entryType;
  ListEntryEntryTypeEnum? get entryType => _$this._entryType;
  set entryType(ListEntryEntryTypeEnum? entryType) =>
      _$this._entryType = entryType;

  int? _entryId;
  int? get entryId => _$this._entryId;
  set entryId(int? entryId) => _$this._entryId = entryId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _cost;
  int? get cost => _$this._cost;
  set cost(int? cost) => _$this._cost = cost;

  EntryStateBuilder? _state;
  EntryStateBuilder get state => _$this._state ??= EntryStateBuilder();
  set state(EntryStateBuilder? state) => _$this._state = state;

  bool? _mage;
  bool? get mage => _$this._mage;
  set mage(bool? mage) => _$this._mage = mage;

  int? _spellSlots;
  int? get spellSlots => _$this._spellSlots;
  set spellSlots(int? spellSlots) => _$this._spellSlots = spellSlots;

  ListBuilder<String>? _disciplines;
  ListBuilder<String> get disciplines =>
      _$this._disciplines ??= ListBuilder<String>();
  set disciplines(ListBuilder<String>? disciplines) =>
      _$this._disciplines = disciplines;

  String? _spellDiscipline;
  String? get spellDiscipline => _$this._spellDiscipline;
  set spellDiscipline(String? spellDiscipline) =>
      _$this._spellDiscipline = spellDiscipline;

  SpellBuilder? _cantrip;
  SpellBuilder get cantrip => _$this._cantrip ??= SpellBuilder();
  set cantrip(SpellBuilder? cantrip) => _$this._cantrip = cantrip;

  ListBuilder<Spell>? _spells;
  ListBuilder<Spell> get spells => _$this._spells ??= ListBuilder<Spell>();
  set spells(ListBuilder<Spell>? spells) => _$this._spells = spells;

  ListEntryBuilder() {
    ListEntry._defaults(this);
  }

  ListEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _position = $v.position;
      _entryType = $v.entryType;
      _entryId = $v.entryId;
      _name = $v.name;
      _cost = $v.cost;
      _state = $v.state?.toBuilder();
      _mage = $v.mage;
      _spellSlots = $v.spellSlots;
      _disciplines = $v.disciplines.toBuilder();
      _spellDiscipline = $v.spellDiscipline;
      _cantrip = $v.cantrip?.toBuilder();
      _spells = $v.spells.toBuilder();
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
    _$ListEntry _$result;
    try {
      _$result =
          _$v ??
          _$ListEntry._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ListEntry', 'id'),
            position: BuiltValueNullFieldError.checkNotNull(
              position,
              r'ListEntry',
              'position',
            ),
            entryType: BuiltValueNullFieldError.checkNotNull(
              entryType,
              r'ListEntry',
              'entryType',
            ),
            entryId: BuiltValueNullFieldError.checkNotNull(
              entryId,
              r'ListEntry',
              'entryId',
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
            state: _state?.build(),
            mage: BuiltValueNullFieldError.checkNotNull(
              mage,
              r'ListEntry',
              'mage',
            ),
            spellSlots: BuiltValueNullFieldError.checkNotNull(
              spellSlots,
              r'ListEntry',
              'spellSlots',
            ),
            disciplines: disciplines.build(),
            spellDiscipline: spellDiscipline,
            cantrip: _cantrip?.build(),
            spells: spells.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'state';
        _state?.build();

        _$failedField = 'disciplines';
        disciplines.build();

        _$failedField = 'cantrip';
        _cantrip?.build();
        _$failedField = 'spells';
        spells.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ListEntry',
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
