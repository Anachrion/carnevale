//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/list_entry.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'model_list.g.dart';

/// ModelList
///
/// Properties:
/// * [id]
/// * [sourceListId] - The source list this gang was snapshotted from when selected for a game; null for a source list itself. Lets a client match a player's in-game gang to their available-lists picker.
/// * [name]
/// * [faction]
/// * [points]
/// * [totalCost]
/// * [selectionValid] - Whether the current set of entries satisfies the gang composition rules (points limit, faction, uniqueness, Leader, Hero/Henchman ratio, etc).
/// * [selectionErrors]
/// * [entries]
@BuiltValue()
abstract class ModelList implements Built<ModelList, ModelListBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  /// The source list this gang was snapshotted from when selected for a game; null for a source list itself. Lets a client match a player's in-game gang to their available-lists picker.
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

  /// Whether the current set of entries satisfies the gang composition rules (points limit, faction, uniqueness, Leader, Hero/Henchman ratio, etc).
  @BuiltValueField(wireName: r'selection_valid')
  bool get selectionValid;

  @BuiltValueField(wireName: r'selection_errors')
  BuiltList<String> get selectionErrors;

  @BuiltValueField(wireName: r'entries')
  BuiltList<ListEntry> get entries;

  ModelList._();

  factory ModelList([void updates(ModelListBuilder b)]) = _$ModelList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ModelListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ModelList> get serializer => _$ModelListSerializer();
}

class _$ModelListSerializer implements PrimitiveSerializer<ModelList> {
  @override
  final Iterable<Type> types = const [ModelList, _$ModelList];

  @override
  final String wireName = r'ModelList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ModelList object, {
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
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    yield r'selection_valid';
    yield serializers.serialize(
      object.selectionValid,
      specifiedType: const FullType(bool),
    );
    yield r'selection_errors';
    yield serializers.serialize(
      object.selectionErrors,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [FullType(ListEntry)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ModelList object, {
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
    required ModelListBuilder result,
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
        case r'selection_valid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.selectionValid = valueDes;
          break;
        case r'selection_errors':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.selectionErrors.replace(valueDes);
          break;
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ListEntry),
                    ]),
                  )
                  as BuiltList<ListEntry>;
          result.entries.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ModelList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ModelListBuilder();
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
