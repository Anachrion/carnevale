//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_upgrade_input_entry.g.dart';

/// EntryUpgradeInputEntry
///
/// Properties:
/// * [upgradeSelected] - Whether to buy this model's optional paid upgrade (the Emissary's +12 Ducats for a second set of Tentacles). Its companion entries are reconciled to match. 
@BuiltValue()
abstract class EntryUpgradeInputEntry implements Built<EntryUpgradeInputEntry, EntryUpgradeInputEntryBuilder> {
  /// Whether to buy this model's optional paid upgrade (the Emissary's +12 Ducats for a second set of Tentacles). Its companion entries are reconciled to match. 
  @BuiltValueField(wireName: r'upgrade_selected')
  bool get upgradeSelected;

  EntryUpgradeInputEntry._();

  factory EntryUpgradeInputEntry([void updates(EntryUpgradeInputEntryBuilder b)]) = _$EntryUpgradeInputEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EntryUpgradeInputEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EntryUpgradeInputEntry> get serializer => _$EntryUpgradeInputEntrySerializer();
}

class _$EntryUpgradeInputEntrySerializer implements PrimitiveSerializer<EntryUpgradeInputEntry> {
  @override
  final Iterable<Type> types = const [EntryUpgradeInputEntry, _$EntryUpgradeInputEntry];

  @override
  final String wireName = r'EntryUpgradeInputEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EntryUpgradeInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'upgrade_selected';
    yield serializers.serialize(
      object.upgradeSelected,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EntryUpgradeInputEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EntryUpgradeInputEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'upgrade_selected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.upgradeSelected = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EntryUpgradeInputEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EntryUpgradeInputEntryBuilder();
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

