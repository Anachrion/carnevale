//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:carnevale_api/src/model/entry_illustration_input_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_illustration_input.g.dart';

/// EntryIllustrationInput
///
/// Properties:
/// * [entry] 
@BuiltValue()
abstract class EntryIllustrationInput implements Built<EntryIllustrationInput, EntryIllustrationInputBuilder> {
  @BuiltValueField(wireName: r'entry')
  EntryIllustrationInputEntry get entry;

  EntryIllustrationInput._();

  factory EntryIllustrationInput([void updates(EntryIllustrationInputBuilder b)]) = _$EntryIllustrationInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryIllustrationInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryIllustrationInput> get serializer => _$EntryIllustrationInputSerializer();
}

class _$EntryIllustrationInputSerializer implements PrimitiveSerializer<EntryIllustrationInput> {
  @override
  final Iterable<Type> types = const [EntryIllustrationInput, _$EntryIllustrationInput];

  @override
  final String wireName = r'EntryIllustrationInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryIllustrationInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entry';
    yield serializers.serialize(
      object.entry,
      specifiedType: const FullType(EntryIllustrationInputEntry),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryIllustrationInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EntryIllustrationInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EntryIllustrationInputEntry),
          ) as EntryIllustrationInputEntry;
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
  EntryIllustrationInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryIllustrationInputBuilder();
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

