//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'draw_agenda_input.g.dart';

/// Only used (and only required) while the game is `in_progress` — ignored during the initial `agenda_draw` batch draw.
///
/// Properties:
/// * [origin] 
@BuiltValue()
abstract class DrawAgendaInput implements Built<DrawAgendaInput, DrawAgendaInputBuilder> {
  @BuiltValueField(wireName: r'origin')
  DrawAgendaInputOriginEnum? get origin;
  // enum originEnum {  special_rule,  command_point,  };

  DrawAgendaInput._();

  factory DrawAgendaInput([void updates(DrawAgendaInputBuilder b)]) = _$DrawAgendaInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DrawAgendaInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DrawAgendaInput> get serializer => _$DrawAgendaInputSerializer();
}

class _$DrawAgendaInputSerializer implements PrimitiveSerializer<DrawAgendaInput> {
  @override
  final Iterable<Type> types = const [DrawAgendaInput, _$DrawAgendaInput];

  @override
  final String wireName = r'DrawAgendaInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DrawAgendaInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.origin != null) {
      yield r'origin';
      yield serializers.serialize(
        object.origin,
        specifiedType: const FullType(DrawAgendaInputOriginEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DrawAgendaInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DrawAgendaInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DrawAgendaInputOriginEnum),
          ) as DrawAgendaInputOriginEnum;
          result.origin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DrawAgendaInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DrawAgendaInputBuilder();
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

class DrawAgendaInputOriginEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'special_rule')
  static const DrawAgendaInputOriginEnum specialRule = _$drawAgendaInputOriginEnum_specialRule;
  @BuiltValueEnumConst(wireName: r'command_point')
  static const DrawAgendaInputOriginEnum commandPoint = _$drawAgendaInputOriginEnum_commandPoint;

  static Serializer<DrawAgendaInputOriginEnum> get serializer => _$drawAgendaInputOriginEnumSerializer;

  const DrawAgendaInputOriginEnum._(String name): super(name);

  static BuiltSet<DrawAgendaInputOriginEnum> get values => _$drawAgendaInputOriginEnumValues;
  static DrawAgendaInputOriginEnum valueOf(String name) => _$drawAgendaInputOriginEnumValueOf(name);
}

