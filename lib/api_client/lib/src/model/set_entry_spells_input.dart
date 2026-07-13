//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/set_entry_spells_input_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_entry_spells_input.g.dart';

/// SetEntrySpellsInput
///
/// Properties:
/// * [entry] 
@BuiltValue()
abstract class SetEntrySpellsInput implements Built<SetEntrySpellsInput, SetEntrySpellsInputBuilder> {
  @BuiltValueField(wireName: r'entry')
  SetEntrySpellsInputEntry get entry;

  SetEntrySpellsInput._();

  factory SetEntrySpellsInput([void updates(SetEntrySpellsInputBuilder b)]) = _$SetEntrySpellsInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetEntrySpellsInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetEntrySpellsInput> get serializer => _$SetEntrySpellsInputSerializer();
}

class _$SetEntrySpellsInputSerializer implements PrimitiveSerializer<SetEntrySpellsInput> {
  @override
  final Iterable<Type> types = const [SetEntrySpellsInput, _$SetEntrySpellsInput];

  @override
  final String wireName = r'SetEntrySpellsInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetEntrySpellsInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entry';
    yield serializers.serialize(
      object.entry,
      specifiedType: const FullType(SetEntrySpellsInputEntry),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetEntrySpellsInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetEntrySpellsInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SetEntrySpellsInputEntry),
          ) as SetEntrySpellsInputEntry;
          result.entry.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetEntrySpellsInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetEntrySpellsInputBuilder();
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

