// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Agenda extends Agenda {
  @override
  final int id;
  @override
  final String name;
  @override
  final String description;

  factory _$Agenda([void Function(AgendaBuilder)? updates]) =>
      (AgendaBuilder()..update(updates))._build();

  _$Agenda._({required this.id, required this.name, required this.description})
    : super._();
  @override
  Agenda rebuild(void Function(AgendaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgendaBuilder toBuilder() => AgendaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Agenda &&
        id == other.id &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Agenda')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class AgendaBuilder implements Builder<Agenda, AgendaBuilder> {
  _$Agenda? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AgendaBuilder() {
    Agenda._defaults(this);
  }

  AgendaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Agenda other) {
    _$v = other as _$Agenda;
  }

  @override
  void update(void Function(AgendaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Agenda build() => _build();

  _$Agenda _build() {
    final _$result =
        _$v ??
        _$Agenda._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Agenda', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'Agenda', 'name'),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'Agenda',
            'description',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
