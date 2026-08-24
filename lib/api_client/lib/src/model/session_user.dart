//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_user.g.dart';

/// SessionUser
///
/// Properties:
/// * [id] 
/// * [email] 
/// * [username] 
/// * [collectionEnabled] - Whether the player has switched the Collection feature on (CARNEVALEB-76). False until they do. 
/// * [collectionVisible] - Whether the Collection feature is offered at all — the home-screen entry and the menu item. True by default; turning it off hides everything the feature adds, including the catalogue marks, while remembering `collection_enabled`. Both switches live on the account rather than in the client's local settings, so someone who tracks a collection finds it set up the same way on every device. 
@BuiltValue()
abstract class SessionUser implements Built<SessionUser, SessionUserBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'username')
  String get username;

  /// Whether the player has switched the Collection feature on (CARNEVALEB-76). False until they do. 
  @BuiltValueField(wireName: r'collection_enabled')
  bool get collectionEnabled;

  /// Whether the Collection feature is offered at all — the home-screen entry and the menu item. True by default; turning it off hides everything the feature adds, including the catalogue marks, while remembering `collection_enabled`. Both switches live on the account rather than in the client's local settings, so someone who tracks a collection finds it set up the same way on every device. 
  @BuiltValueField(wireName: r'collection_visible')
  bool get collectionVisible;

  SessionUser._();

  factory SessionUser([void updates(SessionUserBuilder b)]) = _$SessionUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionUser> get serializer => _$SessionUserSerializer();
}

class _$SessionUserSerializer implements PrimitiveSerializer<SessionUser> {
  @override
  final Iterable<Type> types = const [SessionUser, _$SessionUser];

  @override
  final String wireName = r'SessionUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'collection_enabled';
    yield serializers.serialize(
      object.collectionEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'collection_visible';
    yield serializers.serialize(
      object.collectionVisible,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SessionUser object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SessionUserBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'collection_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.collectionEnabled = valueDes;
          break;
        case r'collection_visible':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.collectionVisible = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SessionUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionUserBuilder();
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

