// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScenarioAgendaRulesEnum _$scenarioAgendaRulesEnum_cycle =
    const ScenarioAgendaRulesEnum._('cycle');
const ScenarioAgendaRulesEnum _$scenarioAgendaRulesEnum_secondary =
    const ScenarioAgendaRulesEnum._('secondary');
const ScenarioAgendaRulesEnum _$scenarioAgendaRulesEnum_double_ =
    const ScenarioAgendaRulesEnum._('double_');
const ScenarioAgendaRulesEnum _$scenarioAgendaRulesEnum_secret =
    const ScenarioAgendaRulesEnum._('secret');
const ScenarioAgendaRulesEnum _$scenarioAgendaRulesEnum_total =
    const ScenarioAgendaRulesEnum._('total');

ScenarioAgendaRulesEnum _$scenarioAgendaRulesEnumValueOf(String name) {
  switch (name) {
    case 'cycle':
      return _$scenarioAgendaRulesEnum_cycle;
    case 'secondary':
      return _$scenarioAgendaRulesEnum_secondary;
    case 'double_':
      return _$scenarioAgendaRulesEnum_double_;
    case 'secret':
      return _$scenarioAgendaRulesEnum_secret;
    case 'total':
      return _$scenarioAgendaRulesEnum_total;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScenarioAgendaRulesEnum> _$scenarioAgendaRulesEnumValues =
    BuiltSet<ScenarioAgendaRulesEnum>(const <ScenarioAgendaRulesEnum>[
      _$scenarioAgendaRulesEnum_cycle,
      _$scenarioAgendaRulesEnum_secondary,
      _$scenarioAgendaRulesEnum_double_,
      _$scenarioAgendaRulesEnum_secret,
      _$scenarioAgendaRulesEnum_total,
    ]);

Serializer<ScenarioAgendaRulesEnum> _$scenarioAgendaRulesEnumSerializer =
    _$ScenarioAgendaRulesEnumSerializer();

class _$ScenarioAgendaRulesEnumSerializer
    implements PrimitiveSerializer<ScenarioAgendaRulesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'cycle': 'cycle',
    'secondary': 'secondary',
    'double_': 'double',
    'secret': 'secret',
    'total': 'total',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'cycle': 'cycle',
    'secondary': 'secondary',
    'double': 'double_',
    'secret': 'secret',
    'total': 'total',
  };

  @override
  final Iterable<Type> types = const <Type>[ScenarioAgendaRulesEnum];
  @override
  final String wireName = 'ScenarioAgendaRulesEnum';

  @override
  Object serialize(
    Serializers serializers,
    ScenarioAgendaRulesEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ScenarioAgendaRulesEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ScenarioAgendaRulesEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

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
  final BuiltList<ScenarioAgendaRulesEnum> agendaRules;
  @override
  final int agendaCount;
  @override
  final BuiltList<String> specialRules;
  @override
  final String duration;
  @override
  final int turns;
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
    required this.agendaRules,
    required this.agendaCount,
    required this.specialRules,
    required this.duration,
    required this.turns,
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
        agendaRules == other.agendaRules &&
        agendaCount == other.agendaCount &&
        specialRules == other.specialRules &&
        duration == other.duration &&
        turns == other.turns &&
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
    _$hash = $jc(_$hash, agendaRules.hashCode);
    _$hash = $jc(_$hash, agendaCount.hashCode);
    _$hash = $jc(_$hash, specialRules.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, turns.hashCode);
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
          ..add('agendaRules', agendaRules)
          ..add('agendaCount', agendaCount)
          ..add('specialRules', specialRules)
          ..add('duration', duration)
          ..add('turns', turns)
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

  ListBuilder<ScenarioAgendaRulesEnum>? _agendaRules;
  ListBuilder<ScenarioAgendaRulesEnum> get agendaRules =>
      _$this._agendaRules ??= ListBuilder<ScenarioAgendaRulesEnum>();
  set agendaRules(ListBuilder<ScenarioAgendaRulesEnum>? agendaRules) =>
      _$this._agendaRules = agendaRules;

  int? _agendaCount;
  int? get agendaCount => _$this._agendaCount;
  set agendaCount(int? agendaCount) => _$this._agendaCount = agendaCount;

  ListBuilder<String>? _specialRules;
  ListBuilder<String> get specialRules =>
      _$this._specialRules ??= ListBuilder<String>();
  set specialRules(ListBuilder<String>? specialRules) =>
      _$this._specialRules = specialRules;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  int? _turns;
  int? get turns => _$this._turns;
  set turns(int? turns) => _$this._turns = turns;

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
      _agendaRules = $v.agendaRules.toBuilder();
      _agendaCount = $v.agendaCount;
      _specialRules = $v.specialRules.toBuilder();
      _duration = $v.duration;
      _turns = $v.turns;
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
            agendaRules: agendaRules.build(),
            agendaCount: BuiltValueNullFieldError.checkNotNull(
              agendaCount,
              r'Scenario',
              'agendaCount',
            ),
            specialRules: specialRules.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
              duration,
              r'Scenario',
              'duration',
            ),
            turns: BuiltValueNullFieldError.checkNotNull(
              turns,
              r'Scenario',
              'turns',
            ),
            deploymentZones: deploymentZones.build(),
            illustration: illustration,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'agendas';
        agendas.build();
        _$failedField = 'agendaRules';
        agendaRules.build();

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
