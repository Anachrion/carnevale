// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gang_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GangSummary extends GangSummary {
  @override
  final int id;
  @override
  final int? sourceListId;
  @override
  final String? name;
  @override
  final String faction;
  @override
  final int points;
  @override
  final int totalCost;

  factory _$GangSummary([void Function(GangSummaryBuilder)? updates]) =>
      (GangSummaryBuilder()..update(updates))._build();

  _$GangSummary._({
    required this.id,
    this.sourceListId,
    this.name,
    required this.faction,
    required this.points,
    required this.totalCost,
  }) : super._();
  @override
  GangSummary rebuild(void Function(GangSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GangSummaryBuilder toBuilder() => GangSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GangSummary &&
        id == other.id &&
        sourceListId == other.sourceListId &&
        name == other.name &&
        faction == other.faction &&
        points == other.points &&
        totalCost == other.totalCost;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sourceListId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, faction.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, totalCost.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GangSummary')
          ..add('id', id)
          ..add('sourceListId', sourceListId)
          ..add('name', name)
          ..add('faction', faction)
          ..add('points', points)
          ..add('totalCost', totalCost))
        .toString();
  }
}

class GangSummaryBuilder implements Builder<GangSummary, GangSummaryBuilder> {
  _$GangSummary? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _sourceListId;
  int? get sourceListId => _$this._sourceListId;
  set sourceListId(int? sourceListId) => _$this._sourceListId = sourceListId;

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

  GangSummaryBuilder() {
    GangSummary._defaults(this);
  }

  GangSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _sourceListId = $v.sourceListId;
      _name = $v.name;
      _faction = $v.faction;
      _points = $v.points;
      _totalCost = $v.totalCost;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GangSummary other) {
    _$v = other as _$GangSummary;
  }

  @override
  void update(void Function(GangSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GangSummary build() => _build();

  _$GangSummary _build() {
    final _$result =
        _$v ??
        _$GangSummary._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'GangSummary', 'id'),
          sourceListId: sourceListId,
          name: name,
          faction: BuiltValueNullFieldError.checkNotNull(
            faction,
            r'GangSummary',
            'faction',
          ),
          points: BuiltValueNullFieldError.checkNotNull(
            points,
            r'GangSummary',
            'points',
          ),
          totalCost: BuiltValueNullFieldError.checkNotNull(
            totalCost,
            r'GangSummary',
            'totalCost',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
