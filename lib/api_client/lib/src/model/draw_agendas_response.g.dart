// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draw_agendas_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DrawAgendasResponse extends DrawAgendasResponse {
  @override
  final BuiltList<Agenda> agendas;

  factory _$DrawAgendasResponse([
    void Function(DrawAgendasResponseBuilder)? updates,
  ]) => (DrawAgendasResponseBuilder()..update(updates))._build();

  _$DrawAgendasResponse._({required this.agendas}) : super._();
  @override
  DrawAgendasResponse rebuild(
    void Function(DrawAgendasResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DrawAgendasResponseBuilder toBuilder() =>
      DrawAgendasResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DrawAgendasResponse && agendas == other.agendas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, agendas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DrawAgendasResponse',
    )..add('agendas', agendas)).toString();
  }
}

class DrawAgendasResponseBuilder
    implements Builder<DrawAgendasResponse, DrawAgendasResponseBuilder> {
  _$DrawAgendasResponse? _$v;

  ListBuilder<Agenda>? _agendas;
  ListBuilder<Agenda> get agendas => _$this._agendas ??= ListBuilder<Agenda>();
  set agendas(ListBuilder<Agenda>? agendas) => _$this._agendas = agendas;

  DrawAgendasResponseBuilder() {
    DrawAgendasResponse._defaults(this);
  }

  DrawAgendasResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _agendas = $v.agendas.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DrawAgendasResponse other) {
    _$v = other as _$DrawAgendasResponse;
  }

  @override
  void update(void Function(DrawAgendasResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DrawAgendasResponse build() => _build();

  _$DrawAgendasResponse _build() {
    _$DrawAgendasResponse _$result;
    try {
      _$result = _$v ?? _$DrawAgendasResponse._(agendas: agendas.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'agendas';
        agendas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'DrawAgendasResponse',
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
