//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_cable_ticket201_response.g.dart';

/// CreateCableTicket201Response
///
/// Properties:
/// * [ticket] 
@BuiltValue()
abstract class CreateCableTicket201Response implements Built<CreateCableTicket201Response, CreateCableTicket201ResponseBuilder> {
  @BuiltValueField(wireName: r'ticket')
  String get ticket;

  CreateCableTicket201Response._();

  factory CreateCableTicket201Response([void updates(CreateCableTicket201ResponseBuilder b)]) = _$CreateCableTicket201Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateCableTicket201ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateCableTicket201Response> get serializer => _$CreateCableTicket201ResponseSerializer();
}

class _$CreateCableTicket201ResponseSerializer implements PrimitiveSerializer<CreateCableTicket201Response> {
  @override
  final Iterable<Type> types = const [CreateCableTicket201Response, _$CreateCableTicket201Response];

  @override
  final String wireName = r'CreateCableTicket201Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateCableTicket201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticket';
    yield serializers.serialize(
      object.ticket,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateCableTicket201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateCableTicket201ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticket = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateCableTicket201Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateCableTicket201ResponseBuilder();
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

