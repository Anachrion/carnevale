// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discard_agenda_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DiscardAgendaInputOriginEnum _$discardAgendaInputOriginEnum_unachievable =
    const DiscardAgendaInputOriginEnum._('unachievable');
const DiscardAgendaInputOriginEnum _$discardAgendaInputOriginEnum_specialRule =
    const DiscardAgendaInputOriginEnum._('specialRule');
const DiscardAgendaInputOriginEnum _$discardAgendaInputOriginEnum_commandPoint =
    const DiscardAgendaInputOriginEnum._('commandPoint');

DiscardAgendaInputOriginEnum _$discardAgendaInputOriginEnumValueOf(
  String name,
) {
  switch (name) {
    case 'unachievable':
      return _$discardAgendaInputOriginEnum_unachievable;
    case 'specialRule':
      return _$discardAgendaInputOriginEnum_specialRule;
    case 'commandPoint':
      return _$discardAgendaInputOriginEnum_commandPoint;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DiscardAgendaInputOriginEnum>
_$discardAgendaInputOriginEnumValues =
    BuiltSet<DiscardAgendaInputOriginEnum>(const <DiscardAgendaInputOriginEnum>[
      _$discardAgendaInputOriginEnum_unachievable,
      _$discardAgendaInputOriginEnum_specialRule,
      _$discardAgendaInputOriginEnum_commandPoint,
    ]);

Serializer<DiscardAgendaInputOriginEnum>
_$discardAgendaInputOriginEnumSerializer =
    _$DiscardAgendaInputOriginEnumSerializer();

class _$DiscardAgendaInputOriginEnumSerializer
    implements PrimitiveSerializer<DiscardAgendaInputOriginEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'unachievable': 'unachievable',
    'specialRule': 'special_rule',
    'commandPoint': 'command_point',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'unachievable': 'unachievable',
    'special_rule': 'specialRule',
    'command_point': 'commandPoint',
  };

  @override
  final Iterable<Type> types = const <Type>[DiscardAgendaInputOriginEnum];
  @override
  final String wireName = 'DiscardAgendaInputOriginEnum';

  @override
  Object serialize(
    Serializers serializers,
    DiscardAgendaInputOriginEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DiscardAgendaInputOriginEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DiscardAgendaInputOriginEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$DiscardAgendaInput extends DiscardAgendaInput {
  @override
  final DiscardAgendaInputOriginEnum origin;
  @override
  final bool? recycle;

  factory _$DiscardAgendaInput([
    void Function(DiscardAgendaInputBuilder)? updates,
  ]) => (DiscardAgendaInputBuilder()..update(updates))._build();

  _$DiscardAgendaInput._({required this.origin, this.recycle}) : super._();
  @override
  DiscardAgendaInput rebuild(
    void Function(DiscardAgendaInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DiscardAgendaInputBuilder toBuilder() =>
      DiscardAgendaInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscardAgendaInput &&
        origin == other.origin &&
        recycle == other.recycle;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, recycle.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiscardAgendaInput')
          ..add('origin', origin)
          ..add('recycle', recycle))
        .toString();
  }
}

class DiscardAgendaInputBuilder
    implements Builder<DiscardAgendaInput, DiscardAgendaInputBuilder> {
  _$DiscardAgendaInput? _$v;

  DiscardAgendaInputOriginEnum? _origin;
  DiscardAgendaInputOriginEnum? get origin => _$this._origin;
  set origin(DiscardAgendaInputOriginEnum? origin) => _$this._origin = origin;

  bool? _recycle;
  bool? get recycle => _$this._recycle;
  set recycle(bool? recycle) => _$this._recycle = recycle;

  DiscardAgendaInputBuilder() {
    DiscardAgendaInput._defaults(this);
  }

  DiscardAgendaInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _origin = $v.origin;
      _recycle = $v.recycle;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscardAgendaInput other) {
    _$v = other as _$DiscardAgendaInput;
  }

  @override
  void update(void Function(DiscardAgendaInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscardAgendaInput build() => _build();

  _$DiscardAgendaInput _build() {
    final _$result =
        _$v ??
        _$DiscardAgendaInput._(
          origin: BuiltValueNullFieldError.checkNotNull(
            origin,
            r'DiscardAgendaInput',
            'origin',
          ),
          recycle: recycle,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
