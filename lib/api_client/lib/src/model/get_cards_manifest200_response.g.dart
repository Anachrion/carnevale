// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cards_manifest200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCardsManifest200Response extends GetCardsManifest200Response {
  @override
  final BuiltList<CardManifestEntry> cards;

  factory _$GetCardsManifest200Response([
    void Function(GetCardsManifest200ResponseBuilder)? updates,
  ]) => (GetCardsManifest200ResponseBuilder()..update(updates))._build();

  _$GetCardsManifest200Response._({required this.cards}) : super._();
  @override
  GetCardsManifest200Response rebuild(
    void Function(GetCardsManifest200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GetCardsManifest200ResponseBuilder toBuilder() =>
      GetCardsManifest200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCardsManifest200Response && cards == other.cards;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cards.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'GetCardsManifest200Response',
    )..add('cards', cards)).toString();
  }
}

class GetCardsManifest200ResponseBuilder
    implements
        Builder<
          GetCardsManifest200Response,
          GetCardsManifest200ResponseBuilder
        > {
  _$GetCardsManifest200Response? _$v;

  ListBuilder<CardManifestEntry>? _cards;
  ListBuilder<CardManifestEntry> get cards =>
      _$this._cards ??= ListBuilder<CardManifestEntry>();
  set cards(ListBuilder<CardManifestEntry>? cards) => _$this._cards = cards;

  GetCardsManifest200ResponseBuilder() {
    GetCardsManifest200Response._defaults(this);
  }

  GetCardsManifest200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cards = $v.cards.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetCardsManifest200Response other) {
    _$v = other as _$GetCardsManifest200Response;
  }

  @override
  void update(void Function(GetCardsManifest200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCardsManifest200Response build() => _build();

  _$GetCardsManifest200Response _build() {
    _$GetCardsManifest200Response _$result;
    try {
      _$result = _$v ?? _$GetCardsManifest200Response._(cards: cards.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cards';
        cards.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GetCardsManifest200Response',
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
