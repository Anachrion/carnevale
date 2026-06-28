// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_input_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EntryInputEntryEntryTypeEnum
_$entryInputEntryEntryTypeEnum_cardReference =
    const EntryInputEntryEntryTypeEnum._('cardReference');
const EntryInputEntryEntryTypeEnum _$entryInputEntryEntryTypeEnum_equipment =
    const EntryInputEntryEntryTypeEnum._('equipment');

EntryInputEntryEntryTypeEnum _$entryInputEntryEntryTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'cardReference':
      return _$entryInputEntryEntryTypeEnum_cardReference;
    case 'equipment':
      return _$entryInputEntryEntryTypeEnum_equipment;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EntryInputEntryEntryTypeEnum>
_$entryInputEntryEntryTypeEnumValues =
    BuiltSet<EntryInputEntryEntryTypeEnum>(const <EntryInputEntryEntryTypeEnum>[
      _$entryInputEntryEntryTypeEnum_cardReference,
      _$entryInputEntryEntryTypeEnum_equipment,
    ]);

Serializer<EntryInputEntryEntryTypeEnum>
_$entryInputEntryEntryTypeEnumSerializer =
    _$EntryInputEntryEntryTypeEnumSerializer();

class _$EntryInputEntryEntryTypeEnumSerializer
    implements PrimitiveSerializer<EntryInputEntryEntryTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'cardReference': 'CardReference',
    'equipment': 'Equipment',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CardReference': 'cardReference',
    'Equipment': 'equipment',
  };

  @override
  final Iterable<Type> types = const <Type>[EntryInputEntryEntryTypeEnum];
  @override
  final String wireName = 'EntryInputEntryEntryTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    EntryInputEntryEntryTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EntryInputEntryEntryTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EntryInputEntryEntryTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$EntryInputEntry extends EntryInputEntry {
  @override
  final int listId;
  @override
  final EntryInputEntryEntryTypeEnum entryType;
  @override
  final int entryId;

  factory _$EntryInputEntry([void Function(EntryInputEntryBuilder)? updates]) =>
      (EntryInputEntryBuilder()..update(updates))._build();

  _$EntryInputEntry._({
    required this.listId,
    required this.entryType,
    required this.entryId,
  }) : super._();
  @override
  EntryInputEntry rebuild(void Function(EntryInputEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryInputEntryBuilder toBuilder() => EntryInputEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryInputEntry &&
        listId == other.listId &&
        entryType == other.entryType &&
        entryId == other.entryId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listId.hashCode);
    _$hash = $jc(_$hash, entryType.hashCode);
    _$hash = $jc(_$hash, entryId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EntryInputEntry')
          ..add('listId', listId)
          ..add('entryType', entryType)
          ..add('entryId', entryId))
        .toString();
  }
}

class EntryInputEntryBuilder
    implements Builder<EntryInputEntry, EntryInputEntryBuilder> {
  _$EntryInputEntry? _$v;

  int? _listId;
  int? get listId => _$this._listId;
  set listId(int? listId) => _$this._listId = listId;

  EntryInputEntryEntryTypeEnum? _entryType;
  EntryInputEntryEntryTypeEnum? get entryType => _$this._entryType;
  set entryType(EntryInputEntryEntryTypeEnum? entryType) =>
      _$this._entryType = entryType;

  int? _entryId;
  int? get entryId => _$this._entryId;
  set entryId(int? entryId) => _$this._entryId = entryId;

  EntryInputEntryBuilder() {
    EntryInputEntry._defaults(this);
  }

  EntryInputEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listId = $v.listId;
      _entryType = $v.entryType;
      _entryId = $v.entryId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryInputEntry other) {
    _$v = other as _$EntryInputEntry;
  }

  @override
  void update(void Function(EntryInputEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryInputEntry build() => _build();

  _$EntryInputEntry _build() {
    final _$result =
        _$v ??
        _$EntryInputEntry._(
          listId: BuiltValueNullFieldError.checkNotNull(
            listId,
            r'EntryInputEntry',
            'listId',
          ),
          entryType: BuiltValueNullFieldError.checkNotNull(
            entryType,
            r'EntryInputEntry',
            'entryType',
          ),
          entryId: BuiltValueNullFieldError.checkNotNull(
            entryId,
            r'EntryInputEntry',
            'entryId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
