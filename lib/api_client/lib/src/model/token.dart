//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'token.g.dart';

/// Token
///
/// Properties:
/// * [id] - Client-generated stable id; re-sending the same id updates the token instead of adding a duplicate.
/// * [color] 
/// * [text] - Optional label; a colour-only token omits it and renders as a dot.
/// * [toggleable] - Whether the player can flip it on/off (a recurring effect) rather than only add/remove it.
/// * [active] 
/// * [count] - A counter token's running total (grows or spends); null for plain/toggleable tokens.
@BuiltValue()
abstract class Token implements Built<Token, TokenBuilder> {
  /// Client-generated stable id; re-sending the same id updates the token instead of adding a duplicate.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'color')
  TokenColorEnum get color;
  // enum colorEnum {  crimson,  azure,  teal,  amethyst,  fuchsia,  pewter,  };

  /// Optional label; a colour-only token omits it and renders as a dot.
  @BuiltValueField(wireName: r'text')
  String? get text;

  /// Whether the player can flip it on/off (a recurring effect) rather than only add/remove it.
  @BuiltValueField(wireName: r'toggleable')
  bool get toggleable;

  @BuiltValueField(wireName: r'active')
  bool get active;

  /// A counter token's running total (grows or spends); null for plain/toggleable tokens.
  @BuiltValueField(wireName: r'count')
  int? get count;

  Token._();

  factory Token([void updates(TokenBuilder b)]) = _$Token;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TokenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Token> get serializer => _$TokenSerializer();
}

class _$TokenSerializer implements PrimitiveSerializer<Token> {
  @override
  final Iterable<Type> types = const [Token, _$Token];

  @override
  final String wireName = r'Token';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Token object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'color';
    yield serializers.serialize(
      object.color,
      specifiedType: const FullType(TokenColorEnum),
    );
    if (object.text != null) {
      yield r'text';
      yield serializers.serialize(
        object.text,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'toggleable';
    yield serializers.serialize(
      object.toggleable,
      specifiedType: const FullType(bool),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    if (object.count != null) {
      yield r'count';
      yield serializers.serialize(
        object.count,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Token object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TokenBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TokenColorEnum),
          ) as TokenColorEnum;
          result.color = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.text = valueDes;
          break;
        case r'toggleable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.toggleable = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.active = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Token deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TokenBuilder();
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

class TokenColorEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'crimson')
  static const TokenColorEnum crimson = _$tokenColorEnum_crimson;
  @BuiltValueEnumConst(wireName: r'azure')
  static const TokenColorEnum azure = _$tokenColorEnum_azure;
  @BuiltValueEnumConst(wireName: r'teal')
  static const TokenColorEnum teal = _$tokenColorEnum_teal;
  @BuiltValueEnumConst(wireName: r'amethyst')
  static const TokenColorEnum amethyst = _$tokenColorEnum_amethyst;
  @BuiltValueEnumConst(wireName: r'fuchsia')
  static const TokenColorEnum fuchsia = _$tokenColorEnum_fuchsia;
  @BuiltValueEnumConst(wireName: r'pewter')
  static const TokenColorEnum pewter = _$tokenColorEnum_pewter;

  static Serializer<TokenColorEnum> get serializer => _$tokenColorEnumSerializer;

  const TokenColorEnum._(String name): super(name);

  static BuiltSet<TokenColorEnum> get values => _$tokenColorEnumValues;
  static TokenColorEnum valueOf(String name) => _$tokenColorEnumValueOf(name);
}

