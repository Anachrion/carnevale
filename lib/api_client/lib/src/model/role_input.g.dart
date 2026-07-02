// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RoleInputRoleEnum _$roleInputRoleEnum_attacker =
    const RoleInputRoleEnum._('attacker');
const RoleInputRoleEnum _$roleInputRoleEnum_defender =
    const RoleInputRoleEnum._('defender');

RoleInputRoleEnum _$roleInputRoleEnumValueOf(String name) {
  switch (name) {
    case 'attacker':
      return _$roleInputRoleEnum_attacker;
    case 'defender':
      return _$roleInputRoleEnum_defender;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RoleInputRoleEnum> _$roleInputRoleEnumValues =
    BuiltSet<RoleInputRoleEnum>(const <RoleInputRoleEnum>[
      _$roleInputRoleEnum_attacker,
      _$roleInputRoleEnum_defender,
    ]);

Serializer<RoleInputRoleEnum> _$roleInputRoleEnumSerializer =
    _$RoleInputRoleEnumSerializer();

class _$RoleInputRoleEnumSerializer
    implements PrimitiveSerializer<RoleInputRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'attacker': 'attacker',
    'defender': 'defender',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'attacker': 'attacker',
    'defender': 'defender',
  };

  @override
  final Iterable<Type> types = const <Type>[RoleInputRoleEnum];
  @override
  final String wireName = 'RoleInputRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    RoleInputRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  RoleInputRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => RoleInputRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$RoleInput extends RoleInput {
  @override
  final RoleInputRoleEnum role;

  factory _$RoleInput([void Function(RoleInputBuilder)? updates]) =>
      (RoleInputBuilder()..update(updates))._build();

  _$RoleInput._({required this.role}) : super._();
  @override
  RoleInput rebuild(void Function(RoleInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleInputBuilder toBuilder() => RoleInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleInput && role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'RoleInput',
    )..add('role', role)).toString();
  }
}

class RoleInputBuilder implements Builder<RoleInput, RoleInputBuilder> {
  _$RoleInput? _$v;

  RoleInputRoleEnum? _role;
  RoleInputRoleEnum? get role => _$this._role;
  set role(RoleInputRoleEnum? role) => _$this._role = role;

  RoleInputBuilder() {
    RoleInput._defaults(this);
  }

  RoleInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleInput other) {
    _$v = other as _$RoleInput;
  }

  @override
  void update(void Function(RoleInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleInput build() => _build();

  _$RoleInput _build() {
    final _$result =
        _$v ??
        _$RoleInput._(
          role: BuiltValueNullFieldError.checkNotNull(
            role,
            r'RoleInput',
            'role',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
