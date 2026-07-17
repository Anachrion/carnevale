// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_entry_spells_input_entry_pool_selections_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
_$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_bloodRites =
    const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum._(
      'bloodRites',
    );
const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
_$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_divinity =
    const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum._(
      'divinity',
    );
const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
_$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_fateweaving =
    const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum._(
      'fateweaving',
    );
const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
_$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_runesOfSovereignty =
    const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum._(
      'runesOfSovereignty',
    );
const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
_$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_wildMagic =
    const SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum._(
      'wildMagic',
    );

SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
_$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnumValueOf(
  String name,
) {
  switch (name) {
    case 'bloodRites':
      return _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_bloodRites;
    case 'divinity':
      return _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_divinity;
    case 'fateweaving':
      return _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_fateweaving;
    case 'runesOfSovereignty':
      return _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_runesOfSovereignty;
    case 'wildMagic':
      return _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_wildMagic;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>
_$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnumValues =
    BuiltSet<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>(const <
      SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
    >[
      _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_bloodRites,
      _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_divinity,
      _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_fateweaving,
      _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_runesOfSovereignty,
      _$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum_wildMagic,
    ]);

Serializer<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>
_$setEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnumSerializer =
    _$SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnumSerializer();

class _$SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnumSerializer
    implements
        PrimitiveSerializer<
          SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
        > {
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
  final Iterable<Type> types = const <Type>[
    SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum,
  ];
  @override
  final String wireName =
      'SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum';

  @override
  Object serialize(
    Serializers serializers,
    SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SetEntrySpellsInputEntryPoolSelectionsInner
    extends SetEntrySpellsInputEntryPoolSelectionsInner {
  @override
  final int poolId;
  @override
  final BuiltList<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>?
  disciplines;
  @override
  final BuiltList<int>? spellIds;

  factory _$SetEntrySpellsInputEntryPoolSelectionsInner([
    void Function(SetEntrySpellsInputEntryPoolSelectionsInnerBuilder)? updates,
  ]) => (SetEntrySpellsInputEntryPoolSelectionsInnerBuilder()..update(updates))
      ._build();

  _$SetEntrySpellsInputEntryPoolSelectionsInner._({
    required this.poolId,
    this.disciplines,
    this.spellIds,
  }) : super._();
  @override
  SetEntrySpellsInputEntryPoolSelectionsInner rebuild(
    void Function(SetEntrySpellsInputEntryPoolSelectionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SetEntrySpellsInputEntryPoolSelectionsInnerBuilder toBuilder() =>
      SetEntrySpellsInputEntryPoolSelectionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetEntrySpellsInputEntryPoolSelectionsInner &&
        poolId == other.poolId &&
        disciplines == other.disciplines &&
        spellIds == other.spellIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, poolId.hashCode);
    _$hash = $jc(_$hash, disciplines.hashCode);
    _$hash = $jc(_$hash, spellIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SetEntrySpellsInputEntryPoolSelectionsInner',
          )
          ..add('poolId', poolId)
          ..add('disciplines', disciplines)
          ..add('spellIds', spellIds))
        .toString();
  }
}

class SetEntrySpellsInputEntryPoolSelectionsInnerBuilder
    implements
        Builder<
          SetEntrySpellsInputEntryPoolSelectionsInner,
          SetEntrySpellsInputEntryPoolSelectionsInnerBuilder
        > {
  _$SetEntrySpellsInputEntryPoolSelectionsInner? _$v;

  int? _poolId;
  int? get poolId => _$this._poolId;
  set poolId(int? poolId) => _$this._poolId = poolId;

  ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>?
  _disciplines;
  ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>
  get disciplines => _$this._disciplines ??=
      ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>();
  set disciplines(
    ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>?
    disciplines,
  ) => _$this._disciplines = disciplines;

  ListBuilder<int>? _spellIds;
  ListBuilder<int> get spellIds => _$this._spellIds ??= ListBuilder<int>();
  set spellIds(ListBuilder<int>? spellIds) => _$this._spellIds = spellIds;

  SetEntrySpellsInputEntryPoolSelectionsInnerBuilder() {
    SetEntrySpellsInputEntryPoolSelectionsInner._defaults(this);
  }

  SetEntrySpellsInputEntryPoolSelectionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _poolId = $v.poolId;
      _disciplines = $v.disciplines?.toBuilder();
      _spellIds = $v.spellIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetEntrySpellsInputEntryPoolSelectionsInner other) {
    _$v = other as _$SetEntrySpellsInputEntryPoolSelectionsInner;
  }

  @override
  void update(
    void Function(SetEntrySpellsInputEntryPoolSelectionsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  SetEntrySpellsInputEntryPoolSelectionsInner build() => _build();

  _$SetEntrySpellsInputEntryPoolSelectionsInner _build() {
    _$SetEntrySpellsInputEntryPoolSelectionsInner _$result;
    try {
      _$result =
          _$v ??
          _$SetEntrySpellsInputEntryPoolSelectionsInner._(
            poolId: BuiltValueNullFieldError.checkNotNull(
              poolId,
              r'SetEntrySpellsInputEntryPoolSelectionsInner',
              'poolId',
            ),
            disciplines: _disciplines?.build(),
            spellIds: _spellIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'disciplines';
        _disciplines?.build();
        _$failedField = 'spellIds';
        _spellIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SetEntrySpellsInputEntryPoolSelectionsInner',
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
