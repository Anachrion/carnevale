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
        state == other.state;
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
          ..add('state', state))
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
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'state';
        _state?.build();
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
