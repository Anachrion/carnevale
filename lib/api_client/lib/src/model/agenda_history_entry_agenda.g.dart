// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_history_entry_agenda.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AgendaHistoryEntryAgenda extends AgendaHistoryEntryAgenda {
  @override
  final int id;
  @override
  final String name;

  factory _$AgendaHistoryEntryAgenda([
    void Function(AgendaHistoryEntryAgendaBuilder)? updates,
  ]) => (AgendaHistoryEntryAgendaBuilder()..update(updates))._build();

  _$AgendaHistoryEntryAgenda._({required this.id, required this.name})
    : super._();
  @override
  AgendaHistoryEntryAgenda rebuild(
    void Function(AgendaHistoryEntryAgendaBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AgendaHistoryEntryAgendaBuilder toBuilder() =>
      AgendaHistoryEntryAgendaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgendaHistoryEntryAgenda &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AgendaHistoryEntryAgenda')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AgendaHistoryEntryAgendaBuilder
    implements
        Builder<AgendaHistoryEntryAgenda, AgendaHistoryEntryAgendaBuilder> {
  _$AgendaHistoryEntryAgenda? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AgendaHistoryEntryAgendaBuilder() {
    AgendaHistoryEntryAgenda._defaults(this);
  }

  AgendaHistoryEntryAgendaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgendaHistoryEntryAgenda other) {
    _$v = other as _$AgendaHistoryEntryAgenda;
  }

  @override
  void update(void Function(AgendaHistoryEntryAgendaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AgendaHistoryEntryAgenda build() => _build();

  _$AgendaHistoryEntryAgenda _build() {
    final _$result =
        _$v ??
        _$AgendaHistoryEntryAgenda._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AgendaHistoryEntryAgenda',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AgendaHistoryEntryAgenda',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
