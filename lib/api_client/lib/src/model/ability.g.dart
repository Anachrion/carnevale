// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AbilityCategoryEnum _$abilityCategoryEnum_character =
    const AbilityCategoryEnum._('character');
const AbilityCategoryEnum _$abilityCategoryEnum_weapon =
    const AbilityCategoryEnum._('weapon');

AbilityCategoryEnum _$abilityCategoryEnumValueOf(String name) {
  switch (name) {
    case 'character':
      return _$abilityCategoryEnum_character;
    case 'weapon':
      return _$abilityCategoryEnum_weapon;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AbilityCategoryEnum> _$abilityCategoryEnumValues =
    BuiltSet<AbilityCategoryEnum>(const <AbilityCategoryEnum>[
      _$abilityCategoryEnum_character,
      _$abilityCategoryEnum_weapon,
    ]);

Serializer<AbilityCategoryEnum> _$abilityCategoryEnumSerializer =
    _$AbilityCategoryEnumSerializer();

class _$AbilityCategoryEnumSerializer
    implements PrimitiveSerializer<AbilityCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'character': 'character',
    'weapon': 'weapon',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'character': 'character',
    'weapon': 'weapon',
  };

  @override
  final Iterable<Type> types = const <Type>[AbilityCategoryEnum];
  @override
  final String wireName = 'AbilityCategoryEnum';

  @override
  Object serialize(
    Serializers serializers,
    AbilityCategoryEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AbilityCategoryEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AbilityCategoryEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Ability extends Ability {
  @override
  final String name;
  @override
  final AbilityCategoryEnum category;
  @override
  final String description;

  factory _$Ability([void Function(AbilityBuilder)? updates]) =>
      (AbilityBuilder()..update(updates))._build();

  _$Ability._({
    required this.name,
    required this.category,
    required this.description,
  }) : super._();
  @override
  Ability rebuild(void Function(AbilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AbilityBuilder toBuilder() => AbilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Ability &&
        name == other.name &&
        category == other.category &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Ability')
          ..add('name', name)
          ..add('category', category)
          ..add('description', description))
        .toString();
  }
}

class AbilityBuilder implements Builder<Ability, AbilityBuilder> {
  _$Ability? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AbilityCategoryEnum? _category;
  AbilityCategoryEnum? get category => _$this._category;
  set category(AbilityCategoryEnum? category) => _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AbilityBuilder() {
    Ability._defaults(this);
  }

  AbilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Ability other) {
    _$v = other as _$Ability;
  }

  @override
  void update(void Function(AbilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Ability build() => _build();

  _$Ability _build() {
    final _$result =
        _$v ??
        _$Ability._(
          name: BuiltValueNullFieldError.checkNotNull(name, r'Ability', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
            category,
            r'Ability',
            'category',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'Ability',
            'description',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
