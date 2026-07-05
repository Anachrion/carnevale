// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_entry_spells_input_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SetEntrySpellsInputEntryDisciplineEnum
_$setEntrySpellsInputEntryDisciplineEnum_bloodRites =
    const SetEntrySpellsInputEntryDisciplineEnum._('bloodRites');
const SetEntrySpellsInputEntryDisciplineEnum
_$setEntrySpellsInputEntryDisciplineEnum_divinity =
    const SetEntrySpellsInputEntryDisciplineEnum._('divinity');
const SetEntrySpellsInputEntryDisciplineEnum
_$setEntrySpellsInputEntryDisciplineEnum_fateweaving =
    const SetEntrySpellsInputEntryDisciplineEnum._('fateweaving');
const SetEntrySpellsInputEntryDisciplineEnum
_$setEntrySpellsInputEntryDisciplineEnum_runesOfSovereignty =
    const SetEntrySpellsInputEntryDisciplineEnum._('runesOfSovereignty');
const SetEntrySpellsInputEntryDisciplineEnum
_$setEntrySpellsInputEntryDisciplineEnum_wildMagic =
    const SetEntrySpellsInputEntryDisciplineEnum._('wildMagic');

SetEntrySpellsInputEntryDisciplineEnum
_$setEntrySpellsInputEntryDisciplineEnumValueOf(String name) {
  switch (name) {
    case 'bloodRites':
      return _$setEntrySpellsInputEntryDisciplineEnum_bloodRites;
    case 'divinity':
      return _$setEntrySpellsInputEntryDisciplineEnum_divinity;
    case 'fateweaving':
      return _$setEntrySpellsInputEntryDisciplineEnum_fateweaving;
    case 'runesOfSovereignty':
      return _$setEntrySpellsInputEntryDisciplineEnum_runesOfSovereignty;
    case 'wildMagic':
      return _$setEntrySpellsInputEntryDisciplineEnum_wildMagic;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SetEntrySpellsInputEntryDisciplineEnum>
_$setEntrySpellsInputEntryDisciplineEnumValues =
    BuiltSet<SetEntrySpellsInputEntryDisciplineEnum>(
      const <SetEntrySpellsInputEntryDisciplineEnum>[
        _$setEntrySpellsInputEntryDisciplineEnum_bloodRites,
        _$setEntrySpellsInputEntryDisciplineEnum_divinity,
        _$setEntrySpellsInputEntryDisciplineEnum_fateweaving,
        _$setEntrySpellsInputEntryDisciplineEnum_runesOfSovereignty,
        _$setEntrySpellsInputEntryDisciplineEnum_wildMagic,
      ],
    );

Serializer<SetEntrySpellsInputEntryDisciplineEnum>
_$setEntrySpellsInputEntryDisciplineEnumSerializer =
    _$SetEntrySpellsInputEntryDisciplineEnumSerializer();

class _$SetEntrySpellsInputEntryDisciplineEnumSerializer
    implements PrimitiveSerializer<SetEntrySpellsInputEntryDisciplineEnum> {
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
    SetEntrySpellsInputEntryDisciplineEnum,
  ];
  @override
  final String wireName = 'SetEntrySpellsInputEntryDisciplineEnum';

  @override
  Object serialize(
    Serializers serializers,
    SetEntrySpellsInputEntryDisciplineEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SetEntrySpellsInputEntryDisciplineEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SetEntrySpellsInputEntryDisciplineEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SetEntrySpellsInputEntry extends SetEntrySpellsInputEntry {
  @override
  final SetEntrySpellsInputEntryDisciplineEnum? discipline;
  @override
  final BuiltList<int>? spellIds;

  factory _$SetEntrySpellsInputEntry([
    void Function(SetEntrySpellsInputEntryBuilder)? updates,
  ]) => (SetEntrySpellsInputEntryBuilder()..update(updates))._build();

  _$SetEntrySpellsInputEntry._({this.discipline, this.spellIds}) : super._();
  @override
  SetEntrySpellsInputEntry rebuild(
    void Function(SetEntrySpellsInputEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SetEntrySpellsInputEntryBuilder toBuilder() =>
      SetEntrySpellsInputEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetEntrySpellsInputEntry &&
        discipline == other.discipline &&
        spellIds == other.spellIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, discipline.hashCode);
    _$hash = $jc(_$hash, spellIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetEntrySpellsInputEntry')
          ..add('discipline', discipline)
          ..add('spellIds', spellIds))
        .toString();
  }
}

class SetEntrySpellsInputEntryBuilder
    implements
        Builder<SetEntrySpellsInputEntry, SetEntrySpellsInputEntryBuilder> {
  _$SetEntrySpellsInputEntry? _$v;

  SetEntrySpellsInputEntryDisciplineEnum? _discipline;
  SetEntrySpellsInputEntryDisciplineEnum? get discipline => _$this._discipline;
  set discipline(SetEntrySpellsInputEntryDisciplineEnum? discipline) =>
      _$this._discipline = discipline;

  ListBuilder<int>? _spellIds;
  ListBuilder<int> get spellIds => _$this._spellIds ??= ListBuilder<int>();
  set spellIds(ListBuilder<int>? spellIds) => _$this._spellIds = spellIds;

  SetEntrySpellsInputEntryBuilder() {
    SetEntrySpellsInputEntry._defaults(this);
  }

  SetEntrySpellsInputEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _discipline = $v.discipline;
      _spellIds = $v.spellIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetEntrySpellsInputEntry other) {
    _$v = other as _$SetEntrySpellsInputEntry;
  }

  @override
  void update(void Function(SetEntrySpellsInputEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetEntrySpellsInputEntry build() => _build();

  _$SetEntrySpellsInputEntry _build() {
    _$SetEntrySpellsInputEntry _$result;
    try {
      _$result =
          _$v ??
          _$SetEntrySpellsInputEntry._(
            discipline: discipline,
            spellIds: _spellIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'spellIds';
        _spellIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SetEntrySpellsInputEntry',
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
