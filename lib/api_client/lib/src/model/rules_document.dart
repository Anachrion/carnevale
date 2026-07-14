//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rules_document.g.dart';

/// RulesDocument
///
/// Properties:
/// * [key] - Stable identifier, safe to use as a client-side cache key. Never reused.
/// * [title] 
/// * [url] - Absolute URL of the PDF, on TT Combat's CDN.
@BuiltValue()
abstract class RulesDocument implements Built<RulesDocument, RulesDocumentBuilder> {
  /// Stable identifier, safe to use as a client-side cache key. Never reused.
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'title')
  String get title;

  /// Absolute URL of the PDF, on TT Combat's CDN.
  @BuiltValueField(wireName: r'url')
  String get url;

  RulesDocument._();

  factory RulesDocument([void updates(RulesDocumentBuilder b)]) = _$RulesDocument;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RulesDocumentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RulesDocument> get serializer => _$RulesDocumentSerializer();
}

class _$RulesDocumentSerializer implements PrimitiveSerializer<RulesDocument> {
  @override
  final Iterable<Type> types = const [RulesDocument, _$RulesDocument];

  @override
  final String wireName = r'RulesDocument';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RulesDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RulesDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RulesDocumentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RulesDocument deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RulesDocumentBuilder();
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

