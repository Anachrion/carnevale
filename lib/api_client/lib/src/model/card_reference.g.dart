// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_reference.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CardReference extends CardReference {
  @override
  final int id;
  @override
  final String identifier;
  @override
  final String? name;
  @override
  final String? cardFront;
  @override
  final String? cardBack;

  factory _$CardReference([void Function(CardReferenceBuilder)? updates]) =>
      (CardReferenceBuilder()..update(updates))._build();

  _$CardReference._({
    required this.id,
    required this.identifier,
    this.name,
    this.cardFront,
    this.cardBack,
  }) : super._();
  @override
  CardReference rebuild(void Function(CardReferenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CardReferenceBuilder toBuilder() => CardReferenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CardReference &&
        id == other.id &&
        identifier == other.identifier &&
        name == other.name &&
        cardFront == other.cardFront &&
        cardBack == other.cardBack;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, cardFront.hashCode);
    _$hash = $jc(_$hash, cardBack.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CardReference')
          ..add('id', id)
          ..add('identifier', identifier)
          ..add('name', name)
          ..add('cardFront', cardFront)
          ..add('cardBack', cardBack))
        .toString();
  }
}

class CardReferenceBuilder
    implements Builder<CardReference, CardReferenceBuilder> {
  _$CardReference? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _cardFront;
  String? get cardFront => _$this._cardFront;
  set cardFront(String? cardFront) => _$this._cardFront = cardFront;

  String? _cardBack;
  String? get cardBack => _$this._cardBack;
  set cardBack(String? cardBack) => _$this._cardBack = cardBack;

  CardReferenceBuilder() {
    CardReference._defaults(this);
  }

  CardReferenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _identifier = $v.identifier;
      _name = $v.name;
      _cardFront = $v.cardFront;
      _cardBack = $v.cardBack;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardReference other) {
    _$v = other as _$CardReference;
  }

  @override
  void update(void Function(CardReferenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CardReference build() => _build();

  _$CardReference _build() {
    final _$result =
        _$v ??
        _$CardReference._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'CardReference', 'id'),
          identifier: BuiltValueNullFieldError.checkNotNull(
            identifier,
            r'CardReference',
            'identifier',
          ),
          name: name,
          cardFront: cardFront,
          cardBack: cardBack,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
