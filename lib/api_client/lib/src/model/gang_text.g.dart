// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gang_text.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GangText extends GangText {
  @override
  final String text;

  factory _$GangText([void Function(GangTextBuilder)? updates]) =>
      (GangTextBuilder()..update(updates))._build();

  _$GangText._({required this.text}) : super._();
  @override
  GangText rebuild(void Function(GangTextBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GangTextBuilder toBuilder() => GangTextBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GangText && text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'GangText',
    )..add('text', text)).toString();
  }
}

class GangTextBuilder implements Builder<GangText, GangTextBuilder> {
  _$GangText? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  GangTextBuilder() {
    GangText._defaults(this);
  }

  GangTextBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GangText other) {
    _$v = other as _$GangText;
  }

  @override
  void update(void Function(GangTextBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GangText build() => _build();

  _$GangText _build() {
    final _$result =
        _$v ??
        _$GangText._(
          text: BuiltValueNullFieldError.checkNotNull(
            text,
            r'GangText',
            'text',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
