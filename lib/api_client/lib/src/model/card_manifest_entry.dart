//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'card_manifest_entry.g.dart';

/// CardManifestEntry
///
/// Properties:
/// * [identifier] 
/// * [faction] 
/// * [internalVersion] - Bumps whenever the card's image bytes change; drives client re-download.
/// * [frontUrl] - Versioned (?v=internal_version) URL of the front image, or null if missing.
/// * [backUrl] 
/// * [frontBytes] - Size in bytes of the front image, or null if the file is missing.
/// * [backBytes] 
@BuiltValue()
abstract class CardManifestEntry implements Built<CardManifestEntry, CardManifestEntryBuilder> {
  @BuiltValueField(wireName: r'identifier')
  String get identifier;

  @BuiltValueField(wireName: r'faction')
  String? get faction;

  /// Bumps whenever the card's image bytes change; drives client re-download.
  @BuiltValueField(wireName: r'internal_version')
  int get internalVersion;

  /// Versioned (?v=internal_version) URL of the front image, or null if missing.
  @BuiltValueField(wireName: r'front_url')
  String? get frontUrl;

  @BuiltValueField(wireName: r'back_url')
  String? get backUrl;

  /// Size in bytes of the front image, or null if the file is missing.
  @BuiltValueField(wireName: r'front_bytes')
  int? get frontBytes;

  @BuiltValueField(wireName: r'back_bytes')
  int? get backBytes;

  CardManifestEntry._();

  factory CardManifestEntry([void updates(CardManifestEntryBuilder b)]) = _$CardManifestEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CardManifestEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CardManifestEntry> get serializer => _$CardManifestEntrySerializer();
}

class _$CardManifestEntrySerializer implements PrimitiveSerializer<CardManifestEntry> {
  @override
  final Iterable<Type> types = const [CardManifestEntry, _$CardManifestEntry];

  @override
  final String wireName = r'CardManifestEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CardManifestEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'identifier';
    yield serializers.serialize(
      object.identifier,
      specifiedType: const FullType(String),
    );
    if (object.faction != null) {
      yield r'faction';
      yield serializers.serialize(
        object.faction,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'internal_version';
    yield serializers.serialize(
      object.internalVersion,
      specifiedType: const FullType(int),
    );
    if (object.frontUrl != null) {
      yield r'front_url';
      yield serializers.serialize(
        object.frontUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.backUrl != null) {
      yield r'back_url';
      yield serializers.serialize(
        object.backUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.frontBytes != null) {
      yield r'front_bytes';
      yield serializers.serialize(
        object.frontBytes,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.backBytes != null) {
      yield r'back_bytes';
      yield serializers.serialize(
        object.backBytes,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CardManifestEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CardManifestEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.identifier = valueDes;
          break;
        case r'faction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.faction = valueDes;
          break;
        case r'internal_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.internalVersion = valueDes;
          break;
        case r'front_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.frontUrl = valueDes;
          break;
        case r'back_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.backUrl = valueDes;
          break;
        case r'front_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.frontBytes = valueDes;
          break;
        case r'back_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.backBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CardManifestEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CardManifestEntryBuilder();
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

