// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summon_model_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SummonModelRequest extends SummonModelRequest {
  @override
  final int cardReferenceId;

  factory _$SummonModelRequest([
    void Function(SummonModelRequestBuilder)? updates,
  ]) => (SummonModelRequestBuilder()..update(updates))._build();

  _$SummonModelRequest._({required this.cardReferenceId}) : super._();
  @override
  SummonModelRequest rebuild(
    void Function(SummonModelRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SummonModelRequestBuilder toBuilder() =>
      SummonModelRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SummonModelRequest &&
        cardReferenceId == other.cardReferenceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cardReferenceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'SummonModelRequest',
    )..add('cardReferenceId', cardReferenceId)).toString();
  }
}

class SummonModelRequestBuilder
    implements Builder<SummonModelRequest, SummonModelRequestBuilder> {
  _$SummonModelRequest? _$v;

  int? _cardReferenceId;
  int? get cardReferenceId => _$this._cardReferenceId;
  set cardReferenceId(int? cardReferenceId) =>
      _$this._cardReferenceId = cardReferenceId;

  SummonModelRequestBuilder() {
    SummonModelRequest._defaults(this);
  }

  SummonModelRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cardReferenceId = $v.cardReferenceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SummonModelRequest other) {
    _$v = other as _$SummonModelRequest;
  }

  @override
  void update(void Function(SummonModelRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SummonModelRequest build() => _build();

  _$SummonModelRequest _build() {
    final _$result =
        _$v ??
        _$SummonModelRequest._(
          cardReferenceId: BuiltValueNullFieldError.checkNotNull(
            cardReferenceId,
            r'SummonModelRequest',
            'cardReferenceId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
