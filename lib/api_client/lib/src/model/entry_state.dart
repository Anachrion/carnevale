//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/entry_stat_value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_state.g.dart';

/// EntryState
///
/// Properties:
/// * [lifePoints]
/// * [willPoints]
/// * [commandPoints]
/// * [stunned]
/// * [hidden]
/// * [guarding]
/// * [carryingObjective]
/// * [underwaterCounters]
/// * [activated] - Whether this model has already been activated on its *owner's* current turn (each player has an independent turn cursor). Derived server-side, so it flips back to false on its own when the owning player advances the turn.
@BuiltValue()
abstract class EntryState implements Built<EntryState, EntryStateBuilder> {
  @BuiltValueField(wireName: r'life_points')
  EntryStatValue get lifePoints;

  @BuiltValueField(wireName: r'will_points')
  EntryStatValue get willPoints;

  @BuiltValueField(wireName: r'command_points')
  EntryStatValue get commandPoints;

  @BuiltValueField(wireName: r'stunned')
  bool get stunned;

  @BuiltValueField(wireName: r'hidden')
  bool get hidden;

  @BuiltValueField(wireName: r'guarding')
  bool get guarding;

  @BuiltValueField(wireName: r'carrying_objective')
  bool get carryingObjective;

  @BuiltValueField(wireName: r'underwater_counters')
  int get underwaterCounters;

  /// Whether this model has already been activated on its *owner's* current turn (each player has an independent turn cursor). Derived server-side, so it flips back to false on its own when the owning player advances the turn.
  @BuiltValueField(wireName: r'activated')
  bool get activated;

  EntryState._();

  factory EntryState([void updates(EntryStateBuilder b)]) = _$EntryState;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryStateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryState> get serializer => _$EntryStateSerializer();
}

class _$EntryStateSerializer implements PrimitiveSerializer<EntryState> {
  @override
  final Iterable<Type> types = const [EntryState, _$EntryState];

  @override
  final String wireName = r'EntryState';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryState object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'life_points';
    yield serializers.serialize(
      object.lifePoints,
      specifiedType: const FullType(EntryStatValue),
    );
    yield r'will_points';
    yield serializers.serialize(
      object.willPoints,
      specifiedType: const FullType(EntryStatValue),
    );
    yield r'command_points';
    yield serializers.serialize(
      object.commandPoints,
      specifiedType: const FullType(EntryStatValue),
    );
    yield r'stunned';
    yield serializers.serialize(
      object.stunned,
      specifiedType: const FullType(bool),
    );
    yield r'hidden';
    yield serializers.serialize(
      object.hidden,
      specifiedType: const FullType(bool),
    );
    yield r'guarding';
    yield serializers.serialize(
      object.guarding,
      specifiedType: const FullType(bool),
    );
    yield r'carrying_objective';
    yield serializers.serialize(
      object.carryingObjective,
      specifiedType: const FullType(bool),
    );
    yield r'underwater_counters';
    yield serializers.serialize(
      object.underwaterCounters,
      specifiedType: const FullType(int),
    );
    yield r'activated';
    yield serializers.serialize(
      object.activated,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryState object, {
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
    required EntryStateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'life_points':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(EntryStatValue),
                  )
                  as EntryStatValue;
          result.lifePoints.replace(valueDes);
          break;
        case r'will_points':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(EntryStatValue),
                  )
                  as EntryStatValue;
          result.willPoints.replace(valueDes);
          break;
        case r'command_points':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(EntryStatValue),
                  )
                  as EntryStatValue;
          result.commandPoints.replace(valueDes);
          break;
        case r'stunned':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.stunned = valueDes;
          break;
        case r'hidden':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.hidden = valueDes;
          break;
        case r'guarding':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.guarding = valueDes;
          break;
        case r'carrying_objective':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.carryingObjective = valueDes;
          break;
        case r'underwater_counters':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.underwaterCounters = valueDes;
          break;
        case r'activated':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.activated = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EntryState deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryStateBuilder();
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
