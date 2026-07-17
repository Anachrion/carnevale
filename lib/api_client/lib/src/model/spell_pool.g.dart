// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spell_pool.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SpellPool extends SpellPool {
  @override
  final int id;
  @override
  final int of_;
  @override
  final int slotCount;
  @override
  final int mageSlotCount;
  @override
  final bool unlimited;
  @override
  final bool grantsCantrip;
  @override
  final bool mentorDerived;
  @override
  final bool distinctFromOtherPools;
  @override
  final bool resetsEachRound;
  @override
  final SpellRuleRef? rule;
  @override
  final BuiltList<String> eligibleDisciplines;
  @override
  final BuiltList<String> chosenDisciplines;
  @override
  final BuiltList<PoolSpell> cantrips;
  @override
  final BuiltList<PoolSpell> spells;

  factory _$SpellPool([void Function(SpellPoolBuilder)? updates]) =>
      (SpellPoolBuilder()..update(updates))._build();

  _$SpellPool._({
    required this.id,
    required this.of_,
    required this.slotCount,
    required this.mageSlotCount,
    required this.unlimited,
    required this.grantsCantrip,
    required this.mentorDerived,
    required this.distinctFromOtherPools,
    required this.resetsEachRound,
    this.rule,
    required this.eligibleDisciplines,
    required this.chosenDisciplines,
    required this.cantrips,
    required this.spells,
  }) : super._();
  @override
  SpellPool rebuild(void Function(SpellPoolBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SpellPoolBuilder toBuilder() => SpellPoolBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SpellPool &&
        id == other.id &&
        of_ == other.of_ &&
        slotCount == other.slotCount &&
        mageSlotCount == other.mageSlotCount &&
        unlimited == other.unlimited &&
        grantsCantrip == other.grantsCantrip &&
        mentorDerived == other.mentorDerived &&
        distinctFromOtherPools == other.distinctFromOtherPools &&
        resetsEachRound == other.resetsEachRound &&
        rule == other.rule &&
        eligibleDisciplines == other.eligibleDisciplines &&
        chosenDisciplines == other.chosenDisciplines &&
        cantrips == other.cantrips &&
        spells == other.spells;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, of_.hashCode);
    _$hash = $jc(_$hash, slotCount.hashCode);
    _$hash = $jc(_$hash, mageSlotCount.hashCode);
    _$hash = $jc(_$hash, unlimited.hashCode);
    _$hash = $jc(_$hash, grantsCantrip.hashCode);
    _$hash = $jc(_$hash, mentorDerived.hashCode);
    _$hash = $jc(_$hash, distinctFromOtherPools.hashCode);
    _$hash = $jc(_$hash, resetsEachRound.hashCode);
    _$hash = $jc(_$hash, rule.hashCode);
    _$hash = $jc(_$hash, eligibleDisciplines.hashCode);
    _$hash = $jc(_$hash, chosenDisciplines.hashCode);
    _$hash = $jc(_$hash, cantrips.hashCode);
    _$hash = $jc(_$hash, spells.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SpellPool')
          ..add('id', id)
          ..add('of_', of_)
          ..add('slotCount', slotCount)
          ..add('mageSlotCount', mageSlotCount)
          ..add('unlimited', unlimited)
          ..add('grantsCantrip', grantsCantrip)
          ..add('mentorDerived', mentorDerived)
          ..add('distinctFromOtherPools', distinctFromOtherPools)
          ..add('resetsEachRound', resetsEachRound)
          ..add('rule', rule)
          ..add('eligibleDisciplines', eligibleDisciplines)
          ..add('chosenDisciplines', chosenDisciplines)
          ..add('cantrips', cantrips)
          ..add('spells', spells))
        .toString();
  }
}

class SpellPoolBuilder implements Builder<SpellPool, SpellPoolBuilder> {
  _$SpellPool? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _of_;
  int? get of_ => _$this._of_;
  set of_(int? of_) => _$this._of_ = of_;

  int? _slotCount;
  int? get slotCount => _$this._slotCount;
  set slotCount(int? slotCount) => _$this._slotCount = slotCount;

  int? _mageSlotCount;
  int? get mageSlotCount => _$this._mageSlotCount;
  set mageSlotCount(int? mageSlotCount) =>
      _$this._mageSlotCount = mageSlotCount;

  bool? _unlimited;
  bool? get unlimited => _$this._unlimited;
  set unlimited(bool? unlimited) => _$this._unlimited = unlimited;

  bool? _grantsCantrip;
  bool? get grantsCantrip => _$this._grantsCantrip;
  set grantsCantrip(bool? grantsCantrip) =>
      _$this._grantsCantrip = grantsCantrip;

  bool? _mentorDerived;
  bool? get mentorDerived => _$this._mentorDerived;
  set mentorDerived(bool? mentorDerived) =>
      _$this._mentorDerived = mentorDerived;

  bool? _distinctFromOtherPools;
  bool? get distinctFromOtherPools => _$this._distinctFromOtherPools;
  set distinctFromOtherPools(bool? distinctFromOtherPools) =>
      _$this._distinctFromOtherPools = distinctFromOtherPools;

  bool? _resetsEachRound;
  bool? get resetsEachRound => _$this._resetsEachRound;
  set resetsEachRound(bool? resetsEachRound) =>
      _$this._resetsEachRound = resetsEachRound;

  SpellRuleRefBuilder? _rule;
  SpellRuleRefBuilder get rule => _$this._rule ??= SpellRuleRefBuilder();
  set rule(SpellRuleRefBuilder? rule) => _$this._rule = rule;

  ListBuilder<String>? _eligibleDisciplines;
  ListBuilder<String> get eligibleDisciplines =>
      _$this._eligibleDisciplines ??= ListBuilder<String>();
  set eligibleDisciplines(ListBuilder<String>? eligibleDisciplines) =>
      _$this._eligibleDisciplines = eligibleDisciplines;

  ListBuilder<String>? _chosenDisciplines;
  ListBuilder<String> get chosenDisciplines =>
      _$this._chosenDisciplines ??= ListBuilder<String>();
  set chosenDisciplines(ListBuilder<String>? chosenDisciplines) =>
      _$this._chosenDisciplines = chosenDisciplines;

  ListBuilder<PoolSpell>? _cantrips;
  ListBuilder<PoolSpell> get cantrips =>
      _$this._cantrips ??= ListBuilder<PoolSpell>();
  set cantrips(ListBuilder<PoolSpell>? cantrips) => _$this._cantrips = cantrips;

  ListBuilder<PoolSpell>? _spells;
  ListBuilder<PoolSpell> get spells =>
      _$this._spells ??= ListBuilder<PoolSpell>();
  set spells(ListBuilder<PoolSpell>? spells) => _$this._spells = spells;

  SpellPoolBuilder() {
    SpellPool._defaults(this);
  }

  SpellPoolBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _of_ = $v.of_;
      _slotCount = $v.slotCount;
      _mageSlotCount = $v.mageSlotCount;
      _unlimited = $v.unlimited;
      _grantsCantrip = $v.grantsCantrip;
      _mentorDerived = $v.mentorDerived;
      _distinctFromOtherPools = $v.distinctFromOtherPools;
      _resetsEachRound = $v.resetsEachRound;
      _rule = $v.rule?.toBuilder();
      _eligibleDisciplines = $v.eligibleDisciplines.toBuilder();
      _chosenDisciplines = $v.chosenDisciplines.toBuilder();
      _cantrips = $v.cantrips.toBuilder();
      _spells = $v.spells.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SpellPool other) {
    _$v = other as _$SpellPool;
  }

  @override
  void update(void Function(SpellPoolBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SpellPool build() => _build();

  _$SpellPool _build() {
    _$SpellPool _$result;
    try {
      _$result =
          _$v ??
          _$SpellPool._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'SpellPool', 'id'),
            of_: BuiltValueNullFieldError.checkNotNull(
              of_,
              r'SpellPool',
              'of_',
            ),
            slotCount: BuiltValueNullFieldError.checkNotNull(
              slotCount,
              r'SpellPool',
              'slotCount',
            ),
            mageSlotCount: BuiltValueNullFieldError.checkNotNull(
              mageSlotCount,
              r'SpellPool',
              'mageSlotCount',
            ),
            unlimited: BuiltValueNullFieldError.checkNotNull(
              unlimited,
              r'SpellPool',
              'unlimited',
            ),
            grantsCantrip: BuiltValueNullFieldError.checkNotNull(
              grantsCantrip,
              r'SpellPool',
              'grantsCantrip',
            ),
            mentorDerived: BuiltValueNullFieldError.checkNotNull(
              mentorDerived,
              r'SpellPool',
              'mentorDerived',
            ),
            distinctFromOtherPools: BuiltValueNullFieldError.checkNotNull(
              distinctFromOtherPools,
              r'SpellPool',
              'distinctFromOtherPools',
            ),
            resetsEachRound: BuiltValueNullFieldError.checkNotNull(
              resetsEachRound,
              r'SpellPool',
              'resetsEachRound',
            ),
            rule: _rule?.build(),
            eligibleDisciplines: eligibleDisciplines.build(),
            chosenDisciplines: chosenDisciplines.build(),
            cantrips: cantrips.build(),
            spells: spells.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rule';
        _rule?.build();
        _$failedField = 'eligibleDisciplines';
        eligibleDisciplines.build();
        _$failedField = 'chosenDisciplines';
        chosenDisciplines.build();
        _$failedField = 'cantrips';
        cantrips.build();
        _$failedField = 'spells';
        spells.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SpellPool',
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
