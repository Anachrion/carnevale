//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/gang_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'available_gang.g.dart';

/// AvailableGang
///
/// Properties:
/// * [list]
/// * [selectable] - False when list.points exceeds the game's ducat_limit.
@BuiltValue()
abstract class AvailableGang
    implements Built<AvailableGang, AvailableGangBuilder> {
  @BuiltValueField(wireName: r'list')
  GangSummary get list;

  /// False when list.points exceeds the game's ducat_limit.
  @BuiltValueField(wireName: r'selectable')
  bool get selectable;

  AvailableGang._();

  factory AvailableGang([void updates(AvailableGangBuilder b)]) =
      _$AvailableGang;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AvailableGangBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AvailableGang> get serializer =>
      _$AvailableGangSerializer();
}

class _$AvailableGangSerializer implements PrimitiveSerializer<AvailableGang> {
  @override
  final Iterable<Type> types = const [AvailableGang, _$AvailableGang];

  @override
  final String wireName = r'AvailableGang';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AvailableGang object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'list';
    yield serializers.serialize(
      object.list,
      specifiedType: const FullType(GangSummary),
    );
    yield r'selectable';
    yield serializers.serialize(
      object.selectable,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AvailableGang object, {
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
    required AvailableGangBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'list':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(GangSummary),
                  )
                  as GangSummary;
          result.list.replace(valueDes);
          break;
        case r'selectable':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.selectable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AvailableGang deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AvailableGangBuilder();
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
