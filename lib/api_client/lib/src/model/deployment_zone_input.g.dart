// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deployment_zone_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeploymentZoneInputZoneEnum _$deploymentZoneInputZoneEnum_A =
    const DeploymentZoneInputZoneEnum._('A');
const DeploymentZoneInputZoneEnum _$deploymentZoneInputZoneEnum_B =
    const DeploymentZoneInputZoneEnum._('B');

DeploymentZoneInputZoneEnum _$deploymentZoneInputZoneEnumValueOf(String name) {
  switch (name) {
    case 'A':
      return _$deploymentZoneInputZoneEnum_A;
    case 'B':
      return _$deploymentZoneInputZoneEnum_B;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeploymentZoneInputZoneEnum>
_$deploymentZoneInputZoneEnumValues = BuiltSet<DeploymentZoneInputZoneEnum>(
  const <DeploymentZoneInputZoneEnum>[
    _$deploymentZoneInputZoneEnum_A,
    _$deploymentZoneInputZoneEnum_B,
  ],
);

Serializer<DeploymentZoneInputZoneEnum>
_$deploymentZoneInputZoneEnumSerializer =
    _$DeploymentZoneInputZoneEnumSerializer();

class _$DeploymentZoneInputZoneEnumSerializer
    implements PrimitiveSerializer<DeploymentZoneInputZoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'A': 'A',
    'B': 'B',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'A': 'A',
    'B': 'B',
  };

  @override
  final Iterable<Type> types = const <Type>[DeploymentZoneInputZoneEnum];
  @override
  final String wireName = 'DeploymentZoneInputZoneEnum';

  @override
  Object serialize(
    Serializers serializers,
    DeploymentZoneInputZoneEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DeploymentZoneInputZoneEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DeploymentZoneInputZoneEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$DeploymentZoneInput extends DeploymentZoneInput {
  @override
  final DeploymentZoneInputZoneEnum zone;

  factory _$DeploymentZoneInput([
    void Function(DeploymentZoneInputBuilder)? updates,
  ]) => (DeploymentZoneInputBuilder()..update(updates))._build();

  _$DeploymentZoneInput._({required this.zone}) : super._();
  @override
  DeploymentZoneInput rebuild(
    void Function(DeploymentZoneInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DeploymentZoneInputBuilder toBuilder() =>
      DeploymentZoneInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeploymentZoneInput && zone == other.zone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, zone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DeploymentZoneInput',
    )..add('zone', zone)).toString();
  }
}

class DeploymentZoneInputBuilder
    implements Builder<DeploymentZoneInput, DeploymentZoneInputBuilder> {
  _$DeploymentZoneInput? _$v;

  DeploymentZoneInputZoneEnum? _zone;
  DeploymentZoneInputZoneEnum? get zone => _$this._zone;
  set zone(DeploymentZoneInputZoneEnum? zone) => _$this._zone = zone;

  DeploymentZoneInputBuilder() {
    DeploymentZoneInput._defaults(this);
  }

  DeploymentZoneInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _zone = $v.zone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeploymentZoneInput other) {
    _$v = other as _$DeploymentZoneInput;
  }

  @override
  void update(void Function(DeploymentZoneInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeploymentZoneInput build() => _build();

  _$DeploymentZoneInput _build() {
    final _$result =
        _$v ??
        _$DeploymentZoneInput._(
          zone: BuiltValueNullFieldError.checkNotNull(
            zone,
            r'DeploymentZoneInput',
            'zone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
