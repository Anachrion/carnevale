//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gang_summary.g.dart';

/// GangSummary
///
/// Properties:
/// * [id]
/// * [sourceListId] - The source list this gang was snapshotted from when selected for a game; null for a source list itself (e.g. entries in the available-lists picker). Lets a client match a player's in-game gang to the picker.
/// * [name]
/// * [faction]
/// * [points]
/// * [totalCost]
@BuiltValue()
abstract class GangSummary implements Built<GangSummary, GangSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  /// The source list this gang was snapshotted from when selected for a game; null for a source list itself (e.g. entries in the available-lists picker). Lets a client match a player's in-game gang to the picker.
  @BuiltValueField(wireName: r'source_list_id')
  int? get sourceListId;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'faction')
  String get faction;

  @BuiltValueField(wireName: r'points')
  int get points;

  @BuiltValueField(wireName: r'total_cost')
  int get totalCost;

  GangSummary._();

  factory GangSummary([void updates(GangSummaryBuilder b)]) = _$GangSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GangSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GangSummary> get serializer => _$GangSummarySerializer();
}

class _$GangSummarySerializer implements PrimitiveSerializer<GangSummary> {
  @override
  final Iterable<Type> types = const [GangSummary, _$GangSummary];

  @override
  final String wireName = r'GangSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GangSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(object.id, specifiedType: const FullType(int));
    if (object.sourceListId != null) {
      yield r'source_list_id';
      yield serializers.serialize(
        object.sourceListId,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
    yield r'faction';
    yield serializers.serialize(
      object.faction,
      specifiedType: const FullType(String),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(int),
    );
    yield r'total_cost';
    yield serializers.serialize(
      object.totalCost,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GangSummary object, {
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
    required GangSummaryBuilder result,
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
        case r'source_list_id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.sourceListId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'faction':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.faction = valueDes;
          break;
        case r'points':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.points = valueDes;
          break;
        case r'total_cost':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.totalCost = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GangSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GangSummaryBuilder();
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
