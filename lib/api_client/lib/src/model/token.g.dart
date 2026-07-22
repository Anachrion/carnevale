// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TokenColorEnum _$tokenColorEnum_crimson = const TokenColorEnum._(
  'crimson',
);
const TokenColorEnum _$tokenColorEnum_azure = const TokenColorEnum._('azure');
const TokenColorEnum _$tokenColorEnum_teal = const TokenColorEnum._('teal');
const TokenColorEnum _$tokenColorEnum_amethyst = const TokenColorEnum._(
  'amethyst',
);
const TokenColorEnum _$tokenColorEnum_fuchsia = const TokenColorEnum._(
  'fuchsia',
);
const TokenColorEnum _$tokenColorEnum_pewter = const TokenColorEnum._('pewter');

TokenColorEnum _$tokenColorEnumValueOf(String name) {
  switch (name) {
    case 'crimson':
      return _$tokenColorEnum_crimson;
    case 'azure':
      return _$tokenColorEnum_azure;
    case 'teal':
      return _$tokenColorEnum_teal;
    case 'amethyst':
      return _$tokenColorEnum_amethyst;
    case 'fuchsia':
      return _$tokenColorEnum_fuchsia;
    case 'pewter':
      return _$tokenColorEnum_pewter;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TokenColorEnum> _$tokenColorEnumValues =
    BuiltSet<TokenColorEnum>(const <TokenColorEnum>[
      _$tokenColorEnum_crimson,
      _$tokenColorEnum_azure,
      _$tokenColorEnum_teal,
      _$tokenColorEnum_amethyst,
      _$tokenColorEnum_fuchsia,
      _$tokenColorEnum_pewter,
    ]);

Serializer<TokenColorEnum> _$tokenColorEnumSerializer =
    _$TokenColorEnumSerializer();

class _$TokenColorEnumSerializer
    implements PrimitiveSerializer<TokenColorEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'crimson': 'crimson',
    'azure': 'azure',
    'teal': 'teal',
    'amethyst': 'amethyst',
    'fuchsia': 'fuchsia',
    'pewter': 'pewter',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'crimson': 'crimson',
    'azure': 'azure',
    'teal': 'teal',
    'amethyst': 'amethyst',
    'fuchsia': 'fuchsia',
    'pewter': 'pewter',
  };

  @override
  final Iterable<Type> types = const <Type>[TokenColorEnum];
  @override
  final String wireName = 'TokenColorEnum';

  @override
  Object serialize(
    Serializers serializers,
    TokenColorEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  TokenColorEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => TokenColorEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Token extends Token {
  @override
  final String id;
  @override
  final TokenColorEnum color;
  @override
  final String? text;
  @override
  final bool toggleable;
  @override
  final bool active;
  @override
  final int? count;

  factory _$Token([void Function(TokenBuilder)? updates]) =>
      (TokenBuilder()..update(updates))._build();

  _$Token._({
    required this.id,
    required this.color,
    this.text,
    required this.toggleable,
    required this.active,
    this.count,
  }) : super._();
  @override
  Token rebuild(void Function(TokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TokenBuilder toBuilder() => TokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Token &&
        id == other.id &&
        color == other.color &&
        text == other.text &&
        toggleable == other.toggleable &&
        active == other.active &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, toggleable.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Token')
          ..add('id', id)
          ..add('color', color)
          ..add('text', text)
          ..add('toggleable', toggleable)
          ..add('active', active)
          ..add('count', count))
        .toString();
  }
}

class TokenBuilder implements Builder<Token, TokenBuilder> {
  _$Token? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  TokenColorEnum? _color;
  TokenColorEnum? get color => _$this._color;
  set color(TokenColorEnum? color) => _$this._color = color;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  bool? _toggleable;
  bool? get toggleable => _$this._toggleable;
  set toggleable(bool? toggleable) => _$this._toggleable = toggleable;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  TokenBuilder() {
    Token._defaults(this);
  }

  TokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _color = $v.color;
      _text = $v.text;
      _toggleable = $v.toggleable;
      _active = $v.active;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Token other) {
    _$v = other as _$Token;
  }

  @override
  void update(void Function(TokenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Token build() => _build();

  _$Token _build() {
    final _$result =
        _$v ??
        _$Token._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Token', 'id'),
          color: BuiltValueNullFieldError.checkNotNull(
            color,
            r'Token',
            'color',
          ),
          text: text,
          toggleable: BuiltValueNullFieldError.checkNotNull(
            toggleable,
            r'Token',
            'toggleable',
          ),
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'Token',
            'active',
          ),
          count: count,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
