//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/src/model/model_list.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gang_import_result.g.dart';

/// GangImportResult
///
/// Properties:
/// * [list] 
/// * [warnings] - What could not be resolved and was skipped — an unknown model, a renamed spell. Import succeeds partially by design, so a client that drops these leaves the user with a quietly incomplete gang. 
@BuiltValue()
abstract class GangImportResult implements Built<GangImportResult, GangImportResultBuilder> {
  @BuiltValueField(wireName: r'list')
  ModelList get list;

  /// What could not be resolved and was skipped — an unknown model, a renamed spell. Import succeeds partially by design, so a client that drops these leaves the user with a quietly incomplete gang. 
  @BuiltValueField(wireName: r'warnings')
  BuiltList<String> get warnings;

  GangImportResult._();

  factory GangImportResult([void updates(GangImportResultBuilder b)]) = _$GangImportResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GangImportResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GangImportResult> get serializer => _$GangImportResultSerializer();
}

class _$GangImportResultSerializer implements PrimitiveSerializer<GangImportResult> {
  @override
  final Iterable<Type> types = const [GangImportResult, _$GangImportResult];

  @override
  final String wireName = r'GangImportResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GangImportResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'list';
    yield serializers.serialize(
      object.list,
      specifiedType: const FullType(ModelList),
    );
    yield r'warnings';
    yield serializers.serialize(
      object.warnings,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GangImportResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GangImportResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'list':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ModelList),
          ) as ModelList;
          result.list.replace(valueDes);
          break;
        case r'warnings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.warnings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GangImportResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GangImportResultBuilder();
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

