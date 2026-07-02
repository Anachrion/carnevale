// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Scenario extends Scenario {
  @override
  final int id;
  @override
  final String name;
  @override
  final int ducats;
  @override
  final bool asymmetric;
  @override
  final String setup;
  @override
  final String primaryObjective;
  @override
  final BuiltList<String> agendas;
  @override
  final BuiltList<String> specialRules;
  @override
  final String duration;
  @override
  final BuiltList<String> deploymentZones;
  @override
  final String? illustration;

  factory _$Scenario([void Function(ScenarioBuilder)? updates]) =>
      (ScenarioBuilder()..update(updates))._build();

  _$Scenario._({
    required this.id,
    required this.name,
    required this.ducats,
    required this.asymmetric,
    required this.setup,
    required this.primaryObjective,
    required this.agendas,
    required this.specialRules,
    required this.duration,
    required this.deploymentZones,
    this.illustration,
  }) : super._();
  @override
  Scenario rebuild(void Function(ScenarioBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScenarioBuilder toBuilder() => ScenarioBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Scenario &&
        id == other.id &&
        name == other.name &&
        ducats == other.ducats &&
        asymmetric == other.asymmetric &&
        setup == other.setup &&
        primaryObjective == other.primaryObjective &&
        agendas == other.agendas &&
        specialRules == other.specialRules &&
        duration == other.duration &&
        deploymentZones == other.deploymentZones &&
        illustration == other.illustration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ducats.hashCode);
    _$hash = $jc(_$hash, asymmetric.hashCode);
    _$hash = $jc(_$hash, setup.hashCode);
    _$hash = $jc(_$hash, primaryObjective.hashCode);
    _$hash = $jc(_$hash, agendas.hashCode);
    _$hash = $jc(_$hash, specialRules.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, deploymentZones.hashCode);
    _$hash = $jc(_$hash, illustration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Scenario')
          ..add('id', id)
          ..add('name', name)
          ..add('ducats', ducats)
          ..add('asymmetric', asymmetric)
          ..add('setup', setup)
          ..add('primaryObjective', primaryObjective)
          ..add('agendas', agendas)
          ..add('specialRules', specialRules)
          ..add('duration', duration)
          ..add('deploymentZones', deploymentZones)
          ..add('illustration', illustration))
        .toString();
  }
}

class ScenarioBuilder implements Builder<Scenario, ScenarioBuilder> {
  _$Scenario? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _ducats;
  int? get ducats => _$this._ducats;
  set ducats(int? ducats) => _$this._ducats = ducats;

  bool? _asymmetric;
  bool? get asymmetric => _$this._asymmetric;
  set asymmetric(bool? asymmetric) => _$this._asymmetric = asymmetric;

  String? _setup;
  String? get setup => _$this._setup;
  set setup(String? setup) => _$this._setup = setup;

  String? _primaryObjective;
  String? get primaryObjective => _$this._primaryObjective;
  set primaryObjective(String? primaryObjective) =>
      _$this._primaryObjective = primaryObjective;

  ListBuilder<String>? _agendas;
  ListBuilder<String> get agendas => _$this._agendas ??= ListBuilder<String>();
  set agendas(ListBuilder<String>? agendas) => _$this._agendas = agendas;

  ListBuilder<String>? _specialRules;
  ListBuilder<String> get specialRules =>
      _$this._specialRules ??= ListBuilder<String>();
  set specialRules(ListBuilder<String>? specialRules) =>
      _$this._specialRules = specialRules;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ListBuilder<String>? _deploymentZones;
  ListBuilder<String> get deploymentZones =>
      _$this._deploymentZones ??= ListBuilder<String>();
  set deploymentZones(ListBuilder<String>? deploymentZones) =>
      _$this._deploymentZones = deploymentZones;

  String? _illustration;
  String? get illustration => _$this._illustration;
  set illustration(String? illustration) => _$this._illustration = illustration;

  ScenarioBuilder() {
    Scenario._defaults(this);
  }

  ScenarioBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _ducats = $v.ducats;
      _asymmetric = $v.asymmetric;
      _setup = $v.setup;
      _primaryObjective = $v.primaryObjective;
      _agendas = $v.agendas.toBuilder();
      _specialRules = $v.specialRules.toBuilder();
      _duration = $v.duration;
      _deploymentZones = $v.deploymentZones.toBuilder();
      _illustration = $v.illustration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Scenario other) {
    _$v = other as _$Scenario;
  }

  @override
  void update(void Function(ScenarioBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Scenario build() => _build();

  _$Scenario _build() {
    _$Scenario _$result;
    try {
      _$result =
          _$v ??
          _$Scenario._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Scenario', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'Scenario',
              'name',
            ),
            ducats: BuiltValueNullFieldError.checkNotNull(
              ducats,
              r'Scenario',
              'ducats',
            ),
            asymmetric: BuiltValueNullFieldError.checkNotNull(
              asymmetric,
              r'Scenario',
              'asymmetric',
            ),
            setup: BuiltValueNullFieldError.checkNotNull(
              setup,
              r'Scenario',
              'setup',
            ),
            primaryObjective: BuiltValueNullFieldError.checkNotNull(
              primaryObjective,
              r'Scenario',
              'primaryObjective',
            ),
            agendas: agendas.build(),
            specialRules: specialRules.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
              duration,
              r'Scenario',
              'duration',
            ),
            deploymentZones: deploymentZones.build(),
            illustration: illustration,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'agendas';
        agendas.build();
        _$failedField = 'specialRules';
        specialRules.build();

        _$failedField = 'deploymentZones';
        deploymentZones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Scenario',
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
