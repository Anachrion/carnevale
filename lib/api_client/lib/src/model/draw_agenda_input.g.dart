// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draw_agenda_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DrawAgendaInputOriginEnum _$drawAgendaInputOriginEnum_specialRule =
    const DrawAgendaInputOriginEnum._('specialRule');
const DrawAgendaInputOriginEnum _$drawAgendaInputOriginEnum_commandPoint =
    const DrawAgendaInputOriginEnum._('commandPoint');

DrawAgendaInputOriginEnum _$drawAgendaInputOriginEnumValueOf(String name) {
  switch (name) {
    case 'specialRule':
      return _$drawAgendaInputOriginEnum_specialRule;
    case 'commandPoint':
      return _$drawAgendaInputOriginEnum_commandPoint;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DrawAgendaInputOriginEnum> _$drawAgendaInputOriginEnumValues =
    BuiltSet<DrawAgendaInputOriginEnum>(const <DrawAgendaInputOriginEnum>[
      _$drawAgendaInputOriginEnum_specialRule,
      _$drawAgendaInputOriginEnum_commandPoint,
    ]);

Serializer<DrawAgendaInputOriginEnum> _$drawAgendaInputOriginEnumSerializer =
    _$DrawAgendaInputOriginEnumSerializer();

class _$DrawAgendaInputOriginEnumSerializer
    implements PrimitiveSerializer<DrawAgendaInputOriginEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'specialRule': 'special_rule',
    'commandPoint': 'command_point',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'special_rule': 'specialRule',
    'command_point': 'commandPoint',
  };

  @override
  final Iterable<Type> types = const <Type>[DrawAgendaInputOriginEnum];
  @override
  final String wireName = 'DrawAgendaInputOriginEnum';

  @override
  Object serialize(
    Serializers serializers,
    DrawAgendaInputOriginEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DrawAgendaInputOriginEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DrawAgendaInputOriginEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$DrawAgendaInput extends DrawAgendaInput {
  @override
  final DrawAgendaInputOriginEnum? origin;

  factory _$DrawAgendaInput([void Function(DrawAgendaInputBuilder)? updates]) =>
      (DrawAgendaInputBuilder()..update(updates))._build();

  _$DrawAgendaInput._({this.origin}) : super._();
  @override
  DrawAgendaInput rebuild(void Function(DrawAgendaInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DrawAgendaInputBuilder toBuilder() => DrawAgendaInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DrawAgendaInput && origin == other.origin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DrawAgendaInput',
    )..add('origin', origin)).toString();
  }
}

class DrawAgendaInputBuilder
    implements Builder<DrawAgendaInput, DrawAgendaInputBuilder> {
  _$DrawAgendaInput? _$v;

  DrawAgendaInputOriginEnum? _origin;
  DrawAgendaInputOriginEnum? get origin => _$this._origin;
  set origin(DrawAgendaInputOriginEnum? origin) => _$this._origin = origin;

  DrawAgendaInputBuilder() {
    DrawAgendaInput._defaults(this);
  }

  DrawAgendaInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _origin = $v.origin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DrawAgendaInput other) {
    _$v = other as _$DrawAgendaInput;
  }

  @override
  void update(void Function(DrawAgendaInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DrawAgendaInput build() => _build();

  _$DrawAgendaInput _build() {
    final _$result = _$v ?? _$DrawAgendaInput._(origin: origin);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
