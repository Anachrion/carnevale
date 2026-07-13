//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'validation_errors.g.dart';

/// ValidationErrors
///
/// Properties:
/// * [errors] 
@BuiltValue()
abstract class ValidationErrors implements Built<ValidationErrors, ValidationErrorsBuilder> {
  @BuiltValueField(wireName: r'errors')
  BuiltMap<String, BuiltList<String>> get errors;

  ValidationErrors._();

  factory ValidationErrors([void updates(ValidationErrorsBuilder b)]) = _$ValidationErrors;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ValidationErrorsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ValidationErrors> get serializer => _$ValidationErrorsSerializer();
}

class _$ValidationErrorsSerializer implements PrimitiveSerializer<ValidationErrors> {
  @override
  final Iterable<Type> types = const [ValidationErrors, _$ValidationErrors];

  @override
  final String wireName = r'ValidationErrors';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ValidationErrors object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(BuiltList, [FullType(String)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ValidationErrors object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ValidationErrorsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(BuiltList, [FullType(String)])]),
          ) as BuiltMap<String, BuiltList<String>>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ValidationErrors deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ValidationErrorsBuilder();
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

