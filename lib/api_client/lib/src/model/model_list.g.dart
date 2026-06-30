// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ModelList extends ModelList {
  @override
  final int id;
  @override
  final String? name;
  @override
  final String faction;
  @override
  final int points;
  @override
  final int totalCost;
  @override
  final bool selectionValid;
  @override
  final BuiltList<String> selectionErrors;
  @override
  final BuiltList<ListEntry> entries;

  factory _$ModelList([void Function(ModelListBuilder)? updates]) =>
      (ModelListBuilder()..update(updates))._build();

  _$ModelList._({
    required this.id,
    this.name,
    required this.faction,
    required this.points,
    required this.totalCost,
    required this.selectionValid,
    required this.selectionErrors,
    required this.entries,
  }) : super._();
  @override
  ModelList rebuild(void Function(ModelListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModelListBuilder toBuilder() => ModelListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModelList &&
        id == other.id &&
        name == other.name &&
        faction == other.faction &&
        points == other.points &&
        totalCost == other.totalCost &&
        selectionValid == other.selectionValid &&
        selectionErrors == other.selectionErrors &&
        entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, faction.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, totalCost.hashCode);
    _$hash = $jc(_$hash, selectionValid.hashCode);
    _$hash = $jc(_$hash, selectionErrors.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ModelList')
          ..add('id', id)
          ..add('name', name)
          ..add('faction', faction)
          ..add('points', points)
          ..add('totalCost', totalCost)
          ..add('selectionValid', selectionValid)
          ..add('selectionErrors', selectionErrors)
          ..add('entries', entries))
        .toString();
  }
}

class ModelListBuilder implements Builder<ModelList, ModelListBuilder> {
  _$ModelList? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _faction;
  String? get faction => _$this._faction;
  set faction(String? faction) => _$this._faction = faction;

  int? _points;
  int? get points => _$this._points;
  set points(int? points) => _$this._points = points;

  int? _totalCost;
  int? get totalCost => _$this._totalCost;
  set totalCost(int? totalCost) => _$this._totalCost = totalCost;

  bool? _selectionValid;
  bool? get selectionValid => _$this._selectionValid;
  set selectionValid(bool? selectionValid) =>
      _$this._selectionValid = selectionValid;

  ListBuilder<String>? _selectionErrors;
  ListBuilder<String> get selectionErrors =>
      _$this._selectionErrors ??= ListBuilder<String>();
  set selectionErrors(ListBuilder<String>? selectionErrors) =>
      _$this._selectionErrors = selectionErrors;

  ListBuilder<ListEntry>? _entries;
  ListBuilder<ListEntry> get entries =>
      _$this._entries ??= ListBuilder<ListEntry>();
  set entries(ListBuilder<ListEntry>? entries) => _$this._entries = entries;

  ModelListBuilder() {
    ModelList._defaults(this);
  }

  ModelListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _faction = $v.faction;
      _points = $v.points;
      _totalCost = $v.totalCost;
      _selectionValid = $v.selectionValid;
      _selectionErrors = $v.selectionErrors.toBuilder();
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModelList other) {
    _$v = other as _$ModelList;
  }

  @override
  void update(void Function(ModelListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModelList build() => _build();

  _$ModelList _build() {
    _$ModelList _$result;
    try {
      _$result =
          _$v ??
          _$ModelList._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ModelList', 'id'),
            name: name,
            faction: BuiltValueNullFieldError.checkNotNull(
              faction,
              r'ModelList',
              'faction',
            ),
            points: BuiltValueNullFieldError.checkNotNull(
              points,
              r'ModelList',
              'points',
            ),
            totalCost: BuiltValueNullFieldError.checkNotNull(
              totalCost,
              r'ModelList',
              'totalCost',
            ),
            selectionValid: BuiltValueNullFieldError.checkNotNull(
              selectionValid,
              r'ModelList',
              'selectionValid',
            ),
            selectionErrors: selectionErrors.build(),
            entries: entries.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selectionErrors';
        selectionErrors.build();
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ModelList',
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
