// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_history_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AgendaHistoryEntryActionEnum _$agendaHistoryEntryActionEnum_drawn =
    const AgendaHistoryEntryActionEnum._('drawn');
const AgendaHistoryEntryActionEnum _$agendaHistoryEntryActionEnum_scored =
    const AgendaHistoryEntryActionEnum._('scored');
const AgendaHistoryEntryActionEnum _$agendaHistoryEntryActionEnum_discarded =
    const AgendaHistoryEntryActionEnum._('discarded');

AgendaHistoryEntryActionEnum _$agendaHistoryEntryActionEnumValueOf(
  String name,
) {
  switch (name) {
    case 'drawn':
      return _$agendaHistoryEntryActionEnum_drawn;
    case 'scored':
      return _$agendaHistoryEntryActionEnum_scored;
    case 'discarded':
      return _$agendaHistoryEntryActionEnum_discarded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AgendaHistoryEntryActionEnum>
_$agendaHistoryEntryActionEnumValues =
    BuiltSet<AgendaHistoryEntryActionEnum>(const <AgendaHistoryEntryActionEnum>[
      _$agendaHistoryEntryActionEnum_drawn,
      _$agendaHistoryEntryActionEnum_scored,
      _$agendaHistoryEntryActionEnum_discarded,
    ]);

const AgendaHistoryEntryOriginEnum _$agendaHistoryEntryOriginEnum_initial =
    const AgendaHistoryEntryOriginEnum._('initial');
const AgendaHistoryEntryOriginEnum _$agendaHistoryEntryOriginEnum_specialRule =
    const AgendaHistoryEntryOriginEnum._('specialRule');
const AgendaHistoryEntryOriginEnum _$agendaHistoryEntryOriginEnum_commandPoint =
    const AgendaHistoryEntryOriginEnum._('commandPoint');
const AgendaHistoryEntryOriginEnum _$agendaHistoryEntryOriginEnum_recycle =
    const AgendaHistoryEntryOriginEnum._('recycle');

AgendaHistoryEntryOriginEnum _$agendaHistoryEntryOriginEnumValueOf(
  String name,
) {
  switch (name) {
    case 'initial':
      return _$agendaHistoryEntryOriginEnum_initial;
    case 'specialRule':
      return _$agendaHistoryEntryOriginEnum_specialRule;
    case 'commandPoint':
      return _$agendaHistoryEntryOriginEnum_commandPoint;
    case 'recycle':
      return _$agendaHistoryEntryOriginEnum_recycle;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AgendaHistoryEntryOriginEnum>
_$agendaHistoryEntryOriginEnumValues =
    BuiltSet<AgendaHistoryEntryOriginEnum>(const <AgendaHistoryEntryOriginEnum>[
      _$agendaHistoryEntryOriginEnum_initial,
      _$agendaHistoryEntryOriginEnum_specialRule,
      _$agendaHistoryEntryOriginEnum_commandPoint,
      _$agendaHistoryEntryOriginEnum_recycle,
    ]);

Serializer<AgendaHistoryEntryActionEnum>
_$agendaHistoryEntryActionEnumSerializer =
    _$AgendaHistoryEntryActionEnumSerializer();
Serializer<AgendaHistoryEntryOriginEnum>
_$agendaHistoryEntryOriginEnumSerializer =
    _$AgendaHistoryEntryOriginEnumSerializer();

class _$AgendaHistoryEntryActionEnumSerializer
    implements PrimitiveSerializer<AgendaHistoryEntryActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'drawn': 'drawn',
    'scored': 'scored',
    'discarded': 'discarded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'drawn': 'drawn',
    'scored': 'scored',
    'discarded': 'discarded',
  };

  @override
  final Iterable<Type> types = const <Type>[AgendaHistoryEntryActionEnum];
  @override
  final String wireName = 'AgendaHistoryEntryActionEnum';

  @override
  Object serialize(
    Serializers serializers,
    AgendaHistoryEntryActionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AgendaHistoryEntryActionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AgendaHistoryEntryActionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AgendaHistoryEntryOriginEnumSerializer
    implements PrimitiveSerializer<AgendaHistoryEntryOriginEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'initial': 'initial',
    'specialRule': 'special_rule',
    'commandPoint': 'command_point',
    'recycle': 'recycle',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'initial': 'initial',
    'special_rule': 'specialRule',
    'command_point': 'commandPoint',
    'recycle': 'recycle',
  };

  @override
  final Iterable<Type> types = const <Type>[AgendaHistoryEntryOriginEnum];
  @override
  final String wireName = 'AgendaHistoryEntryOriginEnum';

  @override
  Object serialize(
    Serializers serializers,
    AgendaHistoryEntryOriginEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AgendaHistoryEntryOriginEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AgendaHistoryEntryOriginEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AgendaHistoryEntry extends AgendaHistoryEntry {
  @override
  final int turn;
  @override
  final AgendaHistoryEntryActionEnum action;
  @override
  final AgendaHistoryEntryOriginEnum? origin;
  @override
  final int? causedByEventId;
  @override
  final AgendaHistoryEntryAgenda agenda;

  factory _$AgendaHistoryEntry([
    void Function(AgendaHistoryEntryBuilder)? updates,
  ]) => (AgendaHistoryEntryBuilder()..update(updates))._build();

  _$AgendaHistoryEntry._({
    required this.turn,
    required this.action,
    this.origin,
    this.causedByEventId,
    required this.agenda,
  }) : super._();
  @override
  AgendaHistoryEntry rebuild(
    void Function(AgendaHistoryEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AgendaHistoryEntryBuilder toBuilder() =>
      AgendaHistoryEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgendaHistoryEntry &&
        turn == other.turn &&
        action == other.action &&
        origin == other.origin &&
        causedByEventId == other.causedByEventId &&
        agenda == other.agenda;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, turn.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, causedByEventId.hashCode);
    _$hash = $jc(_$hash, agenda.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AgendaHistoryEntry')
          ..add('turn', turn)
          ..add('action', action)
          ..add('origin', origin)
          ..add('causedByEventId', causedByEventId)
          ..add('agenda', agenda))
        .toString();
  }
}

class AgendaHistoryEntryBuilder
    implements Builder<AgendaHistoryEntry, AgendaHistoryEntryBuilder> {
  _$AgendaHistoryEntry? _$v;

  int? _turn;
  int? get turn => _$this._turn;
  set turn(int? turn) => _$this._turn = turn;

  AgendaHistoryEntryActionEnum? _action;
  AgendaHistoryEntryActionEnum? get action => _$this._action;
  set action(AgendaHistoryEntryActionEnum? action) => _$this._action = action;

  AgendaHistoryEntryOriginEnum? _origin;
  AgendaHistoryEntryOriginEnum? get origin => _$this._origin;
  set origin(AgendaHistoryEntryOriginEnum? origin) => _$this._origin = origin;

  int? _causedByEventId;
  int? get causedByEventId => _$this._causedByEventId;
  set causedByEventId(int? causedByEventId) =>
      _$this._causedByEventId = causedByEventId;

  AgendaHistoryEntryAgendaBuilder? _agenda;
  AgendaHistoryEntryAgendaBuilder get agenda =>
      _$this._agenda ??= AgendaHistoryEntryAgendaBuilder();
  set agenda(AgendaHistoryEntryAgendaBuilder? agenda) =>
      _$this._agenda = agenda;

  AgendaHistoryEntryBuilder() {
    AgendaHistoryEntry._defaults(this);
  }

  AgendaHistoryEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _turn = $v.turn;
      _action = $v.action;
      _origin = $v.origin;
      _causedByEventId = $v.causedByEventId;
      _agenda = $v.agenda.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgendaHistoryEntry other) {
    _$v = other as _$AgendaHistoryEntry;
  }

  @override
  void update(void Function(AgendaHistoryEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgendaHistoryEntry build() => _build();

  _$AgendaHistoryEntry _build() {
    _$AgendaHistoryEntry _$result;
    try {
      _$result =
          _$v ??
          _$AgendaHistoryEntry._(
            turn: BuiltValueNullFieldError.checkNotNull(
              turn,
              r'AgendaHistoryEntry',
              'turn',
            ),
            action: BuiltValueNullFieldError.checkNotNull(
              action,
              r'AgendaHistoryEntry',
              'action',
            ),
            origin: origin,
            causedByEventId: causedByEventId,
            agenda: agenda.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'agenda';
        agenda.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AgendaHistoryEntry',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
