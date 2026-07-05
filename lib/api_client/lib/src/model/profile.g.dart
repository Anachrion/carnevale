// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Profile extends Profile {
  @override
  final int id;
  @override
  final String name;
  @override
  final String faction;
  @override
  final int ducats;
  @override
  final int movement;
  @override
  final int attack;
  @override
  final int dexterity;
  @override
  final int lifePoints;
  @override
  final int mind;
  @override
  final int willPoints;
  @override
  final int protection;
  @override
  final int actionPoints;
  @override
  final int commandPoints;
  @override
  final int size;
  @override
  final BuiltList<String> abilities;
  @override
  final BuiltList<String> keywords;
  @override
  final String version;
  @override
  final bool mage;
  @override
  final int spellSlots;
  @override
  final BuiltList<String> disciplines;
  @override
  final BuiltList<Weapon> weapons;
  @override
  final BuiltList<SpecialRule> specialRules;
  @override
  final BuiltList<CardReference> cardReferences;

  factory _$Profile([void Function(ProfileBuilder)? updates]) =>
      (ProfileBuilder()..update(updates))._build();

  _$Profile._({
    required this.id,
    required this.name,
    required this.faction,
    required this.ducats,
    required this.movement,
    required this.attack,
    required this.dexterity,
    required this.lifePoints,
    required this.mind,
    required this.willPoints,
    required this.protection,
    required this.actionPoints,
    required this.commandPoints,
    required this.size,
    required this.abilities,
    required this.keywords,
    required this.version,
    required this.mage,
    required this.spellSlots,
    required this.disciplines,
    required this.weapons,
    required this.specialRules,
    required this.cardReferences,
  }) : super._();
  @override
  Profile rebuild(void Function(ProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileBuilder toBuilder() => ProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Profile &&
        id == other.id &&
        name == other.name &&
        faction == other.faction &&
        ducats == other.ducats &&
        movement == other.movement &&
        attack == other.attack &&
        dexterity == other.dexterity &&
        lifePoints == other.lifePoints &&
        mind == other.mind &&
        willPoints == other.willPoints &&
        protection == other.protection &&
        actionPoints == other.actionPoints &&
        commandPoints == other.commandPoints &&
        size == other.size &&
        abilities == other.abilities &&
        keywords == other.keywords &&
        version == other.version &&
        mage == other.mage &&
        spellSlots == other.spellSlots &&
        disciplines == other.disciplines &&
        weapons == other.weapons &&
        specialRules == other.specialRules &&
        cardReferences == other.cardReferences;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, faction.hashCode);
    _$hash = $jc(_$hash, ducats.hashCode);
    _$hash = $jc(_$hash, movement.hashCode);
    _$hash = $jc(_$hash, attack.hashCode);
    _$hash = $jc(_$hash, dexterity.hashCode);
    _$hash = $jc(_$hash, lifePoints.hashCode);
    _$hash = $jc(_$hash, mind.hashCode);
    _$hash = $jc(_$hash, willPoints.hashCode);
    _$hash = $jc(_$hash, protection.hashCode);
    _$hash = $jc(_$hash, actionPoints.hashCode);
    _$hash = $jc(_$hash, commandPoints.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, abilities.hashCode);
    _$hash = $jc(_$hash, keywords.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, mage.hashCode);
    _$hash = $jc(_$hash, spellSlots.hashCode);
    _$hash = $jc(_$hash, disciplines.hashCode);
    _$hash = $jc(_$hash, weapons.hashCode);
    _$hash = $jc(_$hash, specialRules.hashCode);
    _$hash = $jc(_$hash, cardReferences.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Profile')
          ..add('id', id)
          ..add('name', name)
          ..add('faction', faction)
          ..add('ducats', ducats)
          ..add('movement', movement)
          ..add('attack', attack)
          ..add('dexterity', dexterity)
          ..add('lifePoints', lifePoints)
          ..add('mind', mind)
          ..add('willPoints', willPoints)
          ..add('protection', protection)
          ..add('actionPoints', actionPoints)
          ..add('commandPoints', commandPoints)
          ..add('size', size)
          ..add('abilities', abilities)
          ..add('keywords', keywords)
          ..add('version', version)
          ..add('mage', mage)
          ..add('spellSlots', spellSlots)
          ..add('disciplines', disciplines)
          ..add('weapons', weapons)
          ..add('specialRules', specialRules)
          ..add('cardReferences', cardReferences))
        .toString();
  }
}

class ProfileBuilder implements Builder<Profile, ProfileBuilder> {
  _$Profile? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _faction;
  String? get faction => _$this._faction;
  set faction(String? faction) => _$this._faction = faction;

  int? _ducats;
  int? get ducats => _$this._ducats;
  set ducats(int? ducats) => _$this._ducats = ducats;

  int? _movement;
  int? get movement => _$this._movement;
  set movement(int? movement) => _$this._movement = movement;

  int? _attack;
  int? get attack => _$this._attack;
  set attack(int? attack) => _$this._attack = attack;

  int? _dexterity;
  int? get dexterity => _$this._dexterity;
  set dexterity(int? dexterity) => _$this._dexterity = dexterity;

  int? _lifePoints;
  int? get lifePoints => _$this._lifePoints;
  set lifePoints(int? lifePoints) => _$this._lifePoints = lifePoints;

  int? _mind;
  int? get mind => _$this._mind;
  set mind(int? mind) => _$this._mind = mind;

  int? _willPoints;
  int? get willPoints => _$this._willPoints;
  set willPoints(int? willPoints) => _$this._willPoints = willPoints;

  int? _protection;
  int? get protection => _$this._protection;
  set protection(int? protection) => _$this._protection = protection;

  int? _actionPoints;
  int? get actionPoints => _$this._actionPoints;
  set actionPoints(int? actionPoints) => _$this._actionPoints = actionPoints;

  int? _commandPoints;
  int? get commandPoints => _$this._commandPoints;
  set commandPoints(int? commandPoints) =>
      _$this._commandPoints = commandPoints;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  ListBuilder<String>? _abilities;
  ListBuilder<String> get abilities =>
      _$this._abilities ??= ListBuilder<String>();
  set abilities(ListBuilder<String>? abilities) =>
      _$this._abilities = abilities;

  ListBuilder<String>? _keywords;
  ListBuilder<String> get keywords =>
      _$this._keywords ??= ListBuilder<String>();
  set keywords(ListBuilder<String>? keywords) => _$this._keywords = keywords;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

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

  ListBuilder<Weapon>? _weapons;
  ListBuilder<Weapon> get weapons => _$this._weapons ??= ListBuilder<Weapon>();
  set weapons(ListBuilder<Weapon>? weapons) => _$this._weapons = weapons;

  ListBuilder<SpecialRule>? _specialRules;
  ListBuilder<SpecialRule> get specialRules =>
      _$this._specialRules ??= ListBuilder<SpecialRule>();
  set specialRules(ListBuilder<SpecialRule>? specialRules) =>
      _$this._specialRules = specialRules;

  ListBuilder<CardReference>? _cardReferences;
  ListBuilder<CardReference> get cardReferences =>
      _$this._cardReferences ??= ListBuilder<CardReference>();
  set cardReferences(ListBuilder<CardReference>? cardReferences) =>
      _$this._cardReferences = cardReferences;

  ProfileBuilder() {
    Profile._defaults(this);
  }

  ProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _faction = $v.faction;
      _ducats = $v.ducats;
      _movement = $v.movement;
      _attack = $v.attack;
      _dexterity = $v.dexterity;
      _lifePoints = $v.lifePoints;
      _mind = $v.mind;
      _willPoints = $v.willPoints;
      _protection = $v.protection;
      _actionPoints = $v.actionPoints;
      _commandPoints = $v.commandPoints;
      _size = $v.size;
      _abilities = $v.abilities.toBuilder();
      _keywords = $v.keywords.toBuilder();
      _version = $v.version;
      _mage = $v.mage;
      _spellSlots = $v.spellSlots;
      _disciplines = $v.disciplines.toBuilder();
      _weapons = $v.weapons.toBuilder();
      _specialRules = $v.specialRules.toBuilder();
      _cardReferences = $v.cardReferences.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Profile other) {
    _$v = other as _$Profile;
  }

  @override
  void update(void Function(ProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Profile build() => _build();

  _$Profile _build() {
    _$Profile _$result;
    try {
      _$result =
          _$v ??
          _$Profile._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Profile', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'Profile',
              'name',
            ),
            faction: BuiltValueNullFieldError.checkNotNull(
              faction,
              r'Profile',
              'faction',
            ),
            ducats: BuiltValueNullFieldError.checkNotNull(
              ducats,
              r'Profile',
              'ducats',
            ),
            movement: BuiltValueNullFieldError.checkNotNull(
              movement,
              r'Profile',
              'movement',
            ),
            attack: BuiltValueNullFieldError.checkNotNull(
              attack,
              r'Profile',
              'attack',
            ),
            dexterity: BuiltValueNullFieldError.checkNotNull(
              dexterity,
              r'Profile',
              'dexterity',
            ),
            lifePoints: BuiltValueNullFieldError.checkNotNull(
              lifePoints,
              r'Profile',
              'lifePoints',
            ),
            mind: BuiltValueNullFieldError.checkNotNull(
              mind,
              r'Profile',
              'mind',
            ),
            willPoints: BuiltValueNullFieldError.checkNotNull(
              willPoints,
              r'Profile',
              'willPoints',
            ),
            protection: BuiltValueNullFieldError.checkNotNull(
              protection,
              r'Profile',
              'protection',
            ),
            actionPoints: BuiltValueNullFieldError.checkNotNull(
              actionPoints,
              r'Profile',
              'actionPoints',
            ),
            commandPoints: BuiltValueNullFieldError.checkNotNull(
              commandPoints,
              r'Profile',
              'commandPoints',
            ),
            size: BuiltValueNullFieldError.checkNotNull(
              size,
              r'Profile',
              'size',
            ),
            abilities: abilities.build(),
            keywords: keywords.build(),
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'Profile',
              'version',
            ),
            mage: BuiltValueNullFieldError.checkNotNull(
              mage,
              r'Profile',
              'mage',
            ),
            spellSlots: BuiltValueNullFieldError.checkNotNull(
              spellSlots,
              r'Profile',
              'spellSlots',
            ),
            disciplines: disciplines.build(),
            weapons: weapons.build(),
            specialRules: specialRules.build(),
            cardReferences: cardReferences.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'abilities';
        abilities.build();
        _$failedField = 'keywords';
        keywords.build();

        _$failedField = 'disciplines';
        disciplines.build();
        _$failedField = 'weapons';
        weapons.build();
        _$failedField = 'specialRules';
        specialRules.build();
        _$failedField = 'cardReferences';
        cardReferences.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Profile',
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
