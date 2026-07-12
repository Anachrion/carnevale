//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'scenario.g.dart';

/// Scenario
///
/// Properties:
/// * [id]
/// * [name]
/// * [ducats] - Default ducat limit recommended by the rulebook for this scenario.
/// * [asymmetric] - True for scenarios with Attacker/Defender roles (e.g. Street Fight), which run a role roll-off once both players have joined.
/// * [setup]
/// * [primaryObjective]
/// * [agendas] - Free-text rendering of the scenario's agenda instructions (e.g. \"3 scoring 1 Victory Point each.\", \"Secret, Cycle, Double.\"). See `agenda_rules`/`agenda_count` for the structured form.
/// * [agendaRules] - The agenda special rules in effect for this scenario (rulebook p.36). `secret` hides opponents' in-hand agendas; `cycle` auto-draws a replacement when an agenda is scored.
/// * [agendaCount] - How many agendas each player draws for their initial hand.
/// * [specialRules]
/// * [duration] - Free-text rendering of the scenario's duration (e.g. \"5 rounds.\"). See `turns` for the structured count.
/// * [turns] - Number of turns the scenario lasts.
/// * [deploymentZones]
/// * [illustration]
@BuiltValue()
abstract class Scenario implements Built<Scenario, ScenarioBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Default ducat limit recommended by the rulebook for this scenario.
  @BuiltValueField(wireName: r'ducats')
  int get ducats;

  /// True for scenarios with Attacker/Defender roles (e.g. Street Fight), which run a role roll-off once both players have joined.
  @BuiltValueField(wireName: r'asymmetric')
  bool get asymmetric;

  @BuiltValueField(wireName: r'setup')
  String get setup;

  @BuiltValueField(wireName: r'primary_objective')
  String get primaryObjective;

  /// Free-text rendering of the scenario's agenda instructions (e.g. \"3 scoring 1 Victory Point each.\", \"Secret, Cycle, Double.\"). See `agenda_rules`/`agenda_count` for the structured form.
  @BuiltValueField(wireName: r'agendas')
  BuiltList<String> get agendas;

  /// The agenda special rules in effect for this scenario (rulebook p.36). `secret` hides opponents' in-hand agendas; `cycle` auto-draws a replacement when an agenda is scored.
  @BuiltValueField(wireName: r'agenda_rules')
  BuiltList<ScenarioAgendaRulesEnum> get agendaRules;
  // enum agendaRulesEnum {  cycle,  secondary,  double,  secret,  total,  };

  /// How many agendas each player draws for their initial hand.
  @BuiltValueField(wireName: r'agenda_count')
  int get agendaCount;

  @BuiltValueField(wireName: r'special_rules')
  BuiltList<String> get specialRules;

  /// Free-text rendering of the scenario's duration (e.g. \"5 rounds.\"). See `turns` for the structured count.
  @BuiltValueField(wireName: r'duration')
  String get duration;

  /// Number of turns the scenario lasts.
  @BuiltValueField(wireName: r'turns')
  int get turns;

  @BuiltValueField(wireName: r'deployment_zones')
  BuiltList<String> get deploymentZones;

  @BuiltValueField(wireName: r'illustration')
  String? get illustration;

  Scenario._();

  factory Scenario([void updates(ScenarioBuilder b)]) = _$Scenario;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScenarioBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Scenario> get serializer => _$ScenarioSerializer();
}

class _$ScenarioSerializer implements PrimitiveSerializer<Scenario> {
  @override
  final Iterable<Type> types = const [Scenario, _$Scenario];

  @override
  final String wireName = r'Scenario';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Scenario object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(object.id, specifiedType: const FullType(int));
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'ducats';
    yield serializers.serialize(
      object.ducats,
      specifiedType: const FullType(int),
    );
    yield r'asymmetric';
    yield serializers.serialize(
      object.asymmetric,
      specifiedType: const FullType(bool),
    );
    yield r'setup';
    yield serializers.serialize(
      object.setup,
      specifiedType: const FullType(String),
    );
    yield r'primary_objective';
    yield serializers.serialize(
      object.primaryObjective,
      specifiedType: const FullType(String),
    );
    yield r'agendas';
    yield serializers.serialize(
      object.agendas,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'agenda_rules';
    yield serializers.serialize(
      object.agendaRules,
      specifiedType: const FullType(BuiltList, [
        FullType(ScenarioAgendaRulesEnum),
      ]),
    );
    yield r'agenda_count';
    yield serializers.serialize(
      object.agendaCount,
      specifiedType: const FullType(int),
    );
    yield r'special_rules';
    yield serializers.serialize(
      object.specialRules,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'turns';
    yield serializers.serialize(
      object.turns,
      specifiedType: const FullType(int),
    );
    yield r'deployment_zones';
    yield serializers.serialize(
      object.deploymentZones,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.illustration != null) {
      yield r'illustration';
      yield serializers.serialize(
        object.illustration,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Scenario object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScenarioBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'ducats':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ducats = valueDes;
          break;
        case r'asymmetric':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.asymmetric = valueDes;
          break;
        case r'setup':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.setup = valueDes;
          break;
        case r'primary_objective':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.primaryObjective = valueDes;
          break;
        case r'agendas':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.agendas.replace(valueDes);
          break;
        case r'agenda_rules':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ScenarioAgendaRulesEnum),
                    ]),
                  )
                  as BuiltList<ScenarioAgendaRulesEnum>;
          result.agendaRules.replace(valueDes);
          break;
        case r'agenda_count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.agendaCount = valueDes;
          break;
        case r'special_rules':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.specialRules.replace(valueDes);
          break;
        case r'duration':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.duration = valueDes;
          break;
        case r'turns':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.turns = valueDes;
          break;
        case r'deployment_zones':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.deploymentZones.replace(valueDes);
          break;
        case r'illustration':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.illustration = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Scenario deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScenarioBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class ScenarioAgendaRulesEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'cycle')
  static const ScenarioAgendaRulesEnum cycle = _$scenarioAgendaRulesEnum_cycle;
  @BuiltValueEnumConst(wireName: r'secondary')
  static const ScenarioAgendaRulesEnum secondary =
      _$scenarioAgendaRulesEnum_secondary;
  @BuiltValueEnumConst(wireName: r'double')
  static const ScenarioAgendaRulesEnum double_ =
      _$scenarioAgendaRulesEnum_double_;
  @BuiltValueEnumConst(wireName: r'secret')
  static const ScenarioAgendaRulesEnum secret =
      _$scenarioAgendaRulesEnum_secret;
  @BuiltValueEnumConst(wireName: r'total')
  static const ScenarioAgendaRulesEnum total = _$scenarioAgendaRulesEnum_total;

  static Serializer<ScenarioAgendaRulesEnum> get serializer =>
      _$scenarioAgendaRulesEnumSerializer;

  const ScenarioAgendaRulesEnum._(String name) : super(name);

  static BuiltSet<ScenarioAgendaRulesEnum> get values =>
      _$scenarioAgendaRulesEnumValues;
  static ScenarioAgendaRulesEnum valueOf(String name) =>
      _$scenarioAgendaRulesEnumValueOf(name);
}
