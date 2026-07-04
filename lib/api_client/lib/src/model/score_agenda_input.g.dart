// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_agenda_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScoreAgendaInput extends ScoreAgendaInput {
  @override
  final bool? recycle;

  factory _$ScoreAgendaInput([
    void Function(ScoreAgendaInputBuilder)? updates,
  ]) => (ScoreAgendaInputBuilder()..update(updates))._build();

  _$ScoreAgendaInput._({this.recycle}) : super._();
  @override
  ScoreAgendaInput rebuild(void Function(ScoreAgendaInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScoreAgendaInputBuilder toBuilder() =>
      ScoreAgendaInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScoreAgendaInput && recycle == other.recycle;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recycle.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ScoreAgendaInput',
    )..add('recycle', recycle)).toString();
  }
}

class ScoreAgendaInputBuilder
    implements Builder<ScoreAgendaInput, ScoreAgendaInputBuilder> {
  _$ScoreAgendaInput? _$v;

  bool? _recycle;
  bool? get recycle => _$this._recycle;
  set recycle(bool? recycle) => _$this._recycle = recycle;

  ScoreAgendaInputBuilder() {
    ScoreAgendaInput._defaults(this);
  }

  ScoreAgendaInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recycle = $v.recycle;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScoreAgendaInput other) {
    _$v = other as _$ScoreAgendaInput;
  }

  @override
  void update(void Function(ScoreAgendaInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScoreAgendaInput build() => _build();

  _$ScoreAgendaInput _build() {
    final _$result = _$v ?? _$ScoreAgendaInput._(recycle: recycle);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
