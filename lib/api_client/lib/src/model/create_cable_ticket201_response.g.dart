// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_cable_ticket201_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateCableTicket201Response extends CreateCableTicket201Response {
  @override
  final String ticket;

  factory _$CreateCableTicket201Response([
    void Function(CreateCableTicket201ResponseBuilder)? updates,
  ]) => (CreateCableTicket201ResponseBuilder()..update(updates))._build();

  _$CreateCableTicket201Response._({required this.ticket}) : super._();
  @override
  CreateCableTicket201Response rebuild(
    void Function(CreateCableTicket201ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreateCableTicket201ResponseBuilder toBuilder() =>
      CreateCableTicket201ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCableTicket201Response && ticket == other.ticket;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticket.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CreateCableTicket201Response',
    )..add('ticket', ticket)).toString();
  }
}

class CreateCableTicket201ResponseBuilder
    implements
        Builder<
          CreateCableTicket201Response,
          CreateCableTicket201ResponseBuilder
        > {
  _$CreateCableTicket201Response? _$v;

  String? _ticket;
  String? get ticket => _$this._ticket;
  set ticket(String? ticket) => _$this._ticket = ticket;

  CreateCableTicket201ResponseBuilder() {
    CreateCableTicket201Response._defaults(this);
  }

  CreateCableTicket201ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticket = $v.ticket;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateCableTicket201Response other) {
    _$v = other as _$CreateCableTicket201Response;
  }

  @override
  void update(void Function(CreateCableTicket201ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCableTicket201Response build() => _build();

  _$CreateCableTicket201Response _build() {
    final _$result =
        _$v ??
        _$CreateCableTicket201Response._(
          ticket: BuiltValueNullFieldError.checkNotNull(
            ticket,
            r'CreateCableTicket201Response',
            'ticket',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
