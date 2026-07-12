//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/agenda.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'draw_agendas_response.g.dart';

/// DrawAgendasResponse
///
/// Properties:
/// * [agendas]
@BuiltValue()
abstract class DrawAgendasResponse
    implements Built<DrawAgendasResponse, DrawAgendasResponseBuilder> {
  @BuiltValueField(wireName: r'agendas')
  BuiltList<Agenda> get agendas;

  DrawAgendasResponse._();

  factory DrawAgendasResponse([void updates(DrawAgendasResponseBuilder b)]) =
      _$DrawAgendasResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DrawAgendasResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DrawAgendasResponse> get serializer =>
      _$DrawAgendasResponseSerializer();
}

class _$DrawAgendasResponseSerializer
    implements PrimitiveSerializer<DrawAgendasResponse> {
  @override
  final Iterable<Type> types = const [
    DrawAgendasResponse,
    _$DrawAgendasResponse,
  ];

  @override
  final String wireName = r'DrawAgendasResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DrawAgendasResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'agendas';
    yield serializers.serialize(
      object.agendas,
      specifiedType: const FullType(BuiltList, [FullType(Agenda)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DrawAgendasResponse object, {
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
    required DrawAgendasResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'agendas':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(Agenda),
                    ]),
                  )
                  as BuiltList<Agenda>;
          result.agendas.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DrawAgendasResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DrawAgendasResponseBuilder();
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
