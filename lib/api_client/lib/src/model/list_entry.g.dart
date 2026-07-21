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
  final String? profileName;
  @override
  final BuiltList<String> keywords;
  @override
  final bool flexibleLeader;
  @override
  final bool demotedLeader;
  @override
  final bool promotableLeader;
  @override
  final String? identifier;
  @override
  final String? cardFront;
  @override
  final String? cardBack;
  @override
  final int cost;
  @override
  final bool summoned;
  @override
  final int? companionOfEntryId;
  @override
  final bool upgradeSelected;
  @override
  final bool upgradeAvailable;
  @override
  final int upgradeDucats;
  @override
  final EntryState? state;
  @override
  final bool mage;
  @override
  final int? mentoredByEntryId;
  @override
  final bool distinctDisciplinePerCopy;
  @override
  final BuiltList<SpellPool> pools;
  @override
  final BuiltList<GrantedSpell> grantedSpells;

  factory _$ListEntry([void Function(ListEntryBuilder)? updates]) =>
      (ListEntryBuilder()..update(updates))._build();

  _$ListEntry._({
    required this.id,
    required this.position,
    required this.entryType,
    required this.entryId,
    required this.name,
    this.profileName,
    required this.keywords,
    required this.flexibleLeader,
    required this.demotedLeader,
    required this.promotableLeader,
    this.identifier,
    this.cardFront,
    this.cardBack,
    required this.cost,
    required this.summoned,
    this.companionOfEntryId,
    required this.upgradeSelected,
    required this.upgradeAvailable,
    required this.upgradeDucats,
    this.state,
    required this.mage,
    this.mentoredByEntryId,
    required this.distinctDisciplinePerCopy,
    required this.pools,
    required this.grantedSpells,
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
        profileName == other.profileName &&
        keywords == other.keywords &&
        flexibleLeader == other.flexibleLeader &&
        demotedLeader == other.demotedLeader &&
        promotableLeader == other.promotableLeader &&
        identifier == other.identifier &&
        cardFront == other.cardFront &&
        cardBack == other.cardBack &&
        cost == other.cost &&
        summoned == other.summoned &&
        companionOfEntryId == other.companionOfEntryId &&
        upgradeSelected == other.upgradeSelected &&
        upgradeAvailable == other.upgradeAvailable &&
        upgradeDucats == other.upgradeDucats &&
        state == other.state &&
        mage == other.mage &&
        mentoredByEntryId == other.mentoredByEntryId &&
        distinctDisciplinePerCopy == other.distinctDisciplinePerCopy &&
        pools == other.pools &&
        grantedSpells == other.grantedSpells;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, entryType.hashCode);
    _$hash = $jc(_$hash, entryId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, profileName.hashCode);
    _$hash = $jc(_$hash, keywords.hashCode);
    _$hash = $jc(_$hash, flexibleLeader.hashCode);
    _$hash = $jc(_$hash, demotedLeader.hashCode);
    _$hash = $jc(_$hash, promotableLeader.hashCode);
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, cardFront.hashCode);
    _$hash = $jc(_$hash, cardBack.hashCode);
    _$hash = $jc(_$hash, cost.hashCode);
    _$hash = $jc(_$hash, summoned.hashCode);
    _$hash = $jc(_$hash, companionOfEntryId.hashCode);
    _$hash = $jc(_$hash, upgradeSelected.hashCode);
    _$hash = $jc(_$hash, upgradeAvailable.hashCode);
    _$hash = $jc(_$hash, upgradeDucats.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, mage.hashCode);
    _$hash = $jc(_$hash, mentoredByEntryId.hashCode);
    _$hash = $jc(_$hash, distinctDisciplinePerCopy.hashCode);
    _$hash = $jc(_$hash, pools.hashCode);
    _$hash = $jc(_$hash, grantedSpells.hashCode);
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
          ..add('profileName', profileName)
          ..add('keywords', keywords)
          ..add('flexibleLeader', flexibleLeader)
          ..add('demotedLeader', demotedLeader)
          ..add('promotableLeader', promotableLeader)
          ..add('identifier', identifier)
          ..add('cardFront', cardFront)
          ..add('cardBack', cardBack)
          ..add('cost', cost)
          ..add('summoned', summoned)
          ..add('companionOfEntryId', companionOfEntryId)
          ..add('upgradeSelected', upgradeSelected)
          ..add('upgradeAvailable', upgradeAvailable)
          ..add('upgradeDucats', upgradeDucats)
          ..add('state', state)
          ..add('mage', mage)
          ..add('mentoredByEntryId', mentoredByEntryId)
          ..add('distinctDisciplinePerCopy', distinctDisciplinePerCopy)
          ..add('pools', pools)
          ..add('grantedSpells', grantedSpells))
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

  String? _profileName;
  String? get profileName => _$this._profileName;
  set profileName(String? profileName) => _$this._profileName = profileName;

  ListBuilder<String>? _keywords;
  ListBuilder<String> get keywords =>
      _$this._keywords ??= ListBuilder<String>();
  set keywords(ListBuilder<String>? keywords) => _$this._keywords = keywords;

  bool? _flexibleLeader;
  bool? get flexibleLeader => _$this._flexibleLeader;
  set flexibleLeader(bool? flexibleLeader) =>
      _$this._flexibleLeader = flexibleLeader;

  bool? _demotedLeader;
  bool? get demotedLeader => _$this._demotedLeader;
  set demotedLeader(bool? demotedLeader) =>
      _$this._demotedLeader = demotedLeader;

  bool? _promotableLeader;
  bool? get promotableLeader => _$this._promotableLeader;
  set promotableLeader(bool? promotableLeader) =>
      _$this._promotableLeader = promotableLeader;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _cardFront;
  String? get cardFront => _$this._cardFront;
  set cardFront(String? cardFront) => _$this._cardFront = cardFront;

  String? _cardBack;
  String? get cardBack => _$this._cardBack;
  set cardBack(String? cardBack) => _$this._cardBack = cardBack;

  int? _cost;
  int? get cost => _$this._cost;
  set cost(int? cost) => _$this._cost = cost;

  bool? _summoned;
  bool? get summoned => _$this._summoned;
  set summoned(bool? summoned) => _$this._summoned = summoned;

  int? _companionOfEntryId;
  int? get companionOfEntryId => _$this._companionOfEntryId;
  set companionOfEntryId(int? companionOfEntryId) =>
      _$this._companionOfEntryId = companionOfEntryId;

  bool? _upgradeSelected;
  bool? get upgradeSelected => _$this._upgradeSelected;
  set upgradeSelected(bool? upgradeSelected) =>
      _$this._upgradeSelected = upgradeSelected;

  bool? _upgradeAvailable;
  bool? get upgradeAvailable => _$this._upgradeAvailable;
  set upgradeAvailable(bool? upgradeAvailable) =>
      _$this._upgradeAvailable = upgradeAvailable;

  int? _upgradeDucats;
  int? get upgradeDucats => _$this._upgradeDucats;
  set upgradeDucats(int? upgradeDucats) =>
      _$this._upgradeDucats = upgradeDucats;

  EntryStateBuilder? _state;
  EntryStateBuilder get state => _$this._state ??= EntryStateBuilder();
  set state(EntryStateBuilder? state) => _$this._state = state;

  bool? _mage;
  bool? get mage => _$this._mage;
  set mage(bool? mage) => _$this._mage = mage;

  int? _mentoredByEntryId;
  int? get mentoredByEntryId => _$this._mentoredByEntryId;
  set mentoredByEntryId(int? mentoredByEntryId) =>
      _$this._mentoredByEntryId = mentoredByEntryId;

  bool? _distinctDisciplinePerCopy;
  bool? get distinctDisciplinePerCopy => _$this._distinctDisciplinePerCopy;
  set distinctDisciplinePerCopy(bool? distinctDisciplinePerCopy) =>
      _$this._distinctDisciplinePerCopy = distinctDisciplinePerCopy;

  ListBuilder<SpellPool>? _pools;
  ListBuilder<SpellPool> get pools =>
      _$this._pools ??= ListBuilder<SpellPool>();
  set pools(ListBuilder<SpellPool>? pools) => _$this._pools = pools;

  ListBuilder<GrantedSpell>? _grantedSpells;
  ListBuilder<GrantedSpell> get grantedSpells =>
      _$this._grantedSpells ??= ListBuilder<GrantedSpell>();
  set grantedSpells(ListBuilder<GrantedSpell>? grantedSpells) =>
      _$this._grantedSpells = grantedSpells;

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
      _profileName = $v.profileName;
      _keywords = $v.keywords.toBuilder();
      _flexibleLeader = $v.flexibleLeader;
      _demotedLeader = $v.demotedLeader;
      _promotableLeader = $v.promotableLeader;
      _identifier = $v.identifier;
      _cardFront = $v.cardFront;
      _cardBack = $v.cardBack;
      _cost = $v.cost;
      _summoned = $v.summoned;
      _companionOfEntryId = $v.companionOfEntryId;
      _upgradeSelected = $v.upgradeSelected;
      _upgradeAvailable = $v.upgradeAvailable;
      _upgradeDucats = $v.upgradeDucats;
      _state = $v.state?.toBuilder();
      _mage = $v.mage;
      _mentoredByEntryId = $v.mentoredByEntryId;
      _distinctDisciplinePerCopy = $v.distinctDisciplinePerCopy;
      _pools = $v.pools.toBuilder();
      _grantedSpells = $v.grantedSpells.toBuilder();
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
            profileName: profileName,
            keywords: keywords.build(),
            flexibleLeader: BuiltValueNullFieldError.checkNotNull(
              flexibleLeader,
              r'ListEntry',
              'flexibleLeader',
            ),
            demotedLeader: BuiltValueNullFieldError.checkNotNull(
              demotedLeader,
              r'ListEntry',
              'demotedLeader',
            ),
            promotableLeader: BuiltValueNullFieldError.checkNotNull(
              promotableLeader,
              r'ListEntry',
              'promotableLeader',
            ),
            identifier: identifier,
            cardFront: cardFront,
            cardBack: cardBack,
            cost: BuiltValueNullFieldError.checkNotNull(
              cost,
              r'ListEntry',
              'cost',
            ),
            summoned: BuiltValueNullFieldError.checkNotNull(
              summoned,
              r'ListEntry',
              'summoned',
            ),
            companionOfEntryId: companionOfEntryId,
            upgradeSelected: BuiltValueNullFieldError.checkNotNull(
              upgradeSelected,
              r'ListEntry',
              'upgradeSelected',
            ),
            upgradeAvailable: BuiltValueNullFieldError.checkNotNull(
              upgradeAvailable,
              r'ListEntry',
              'upgradeAvailable',
            ),
            upgradeDucats: BuiltValueNullFieldError.checkNotNull(
              upgradeDucats,
              r'ListEntry',
              'upgradeDucats',
            ),
            state: _state?.build(),
            mage: BuiltValueNullFieldError.checkNotNull(
              mage,
              r'ListEntry',
              'mage',
            ),
            mentoredByEntryId: mentoredByEntryId,
            distinctDisciplinePerCopy: BuiltValueNullFieldError.checkNotNull(
              distinctDisciplinePerCopy,
              r'ListEntry',
              'distinctDisciplinePerCopy',
            ),
            pools: pools.build(),
            grantedSpells: grantedSpells.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keywords';
        keywords.build();

        _$failedField = 'state';
        _state?.build();

        _$failedField = 'pools';
        pools.build();
        _$failedField = 'grantedSpells';
        grantedSpells.build();
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
