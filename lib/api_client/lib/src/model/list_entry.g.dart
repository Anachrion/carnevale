// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListEntryEntryTypeEnum _$listEntryEntryTypeEnum_cardReference =
    const ListEntryEntryTypeEnum._('cardReference');
const ListEntryEntryTypeEnum _$listEntryEntryTypeEnum_equipment =
    const ListEntryEntryTypeEnum._('equipment');

ListEntryEntryTypeEnum _$listEntryEntryTypeEnumValueOf(String name) {
  switch (name) {
    case 'cardReference':
      return _$listEntryEntryTypeEnum_cardReference;
    case 'equipment':
      return _$listEntryEntryTypeEnum_equipment;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListEntryEntryTypeEnum> _$listEntryEntryTypeEnumValues =
    BuiltSet<ListEntryEntryTypeEnum>(const <ListEntryEntryTypeEnum>[
      _$listEntryEntryTypeEnum_cardReference,
      _$listEntryEntryTypeEnum_equipment,
    ]);

Serializer<ListEntryEntryTypeEnum> _$listEntryEntryTypeEnumSerializer =
    _$ListEntryEntryTypeEnumSerializer();

class _$ListEntryEntryTypeEnumSerializer
    implements PrimitiveSerializer<ListEntryEntryTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'cardReference': 'CardReference',
    'equipment': 'Equipment',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CardReference': 'cardReference',
    'Equipment': 'equipment',
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

  factory _$ListEntry([void Function(ListEntryBuilder)? updates]) =>
      (ListEntryBuilder()..update(updates))._build();

  _$ListEntry._({
    required this.id,
    required this.position,
    required this.entryType,
    required this.entryId,
    required this.name,
    required this.cost,
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
        cost == other.cost;
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
          ..add('cost', cost))
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
    final _$result =
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
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
