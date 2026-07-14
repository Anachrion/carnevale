// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rules_document.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RulesDocument extends RulesDocument {
  @override
  final String key;
  @override
  final String title;
  @override
  final String url;

  factory _$RulesDocument([void Function(RulesDocumentBuilder)? updates]) =>
      (RulesDocumentBuilder()..update(updates))._build();

  _$RulesDocument._({required this.key, required this.title, required this.url})
    : super._();
  @override
  RulesDocument rebuild(void Function(RulesDocumentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RulesDocumentBuilder toBuilder() => RulesDocumentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RulesDocument &&
        key == other.key &&
        title == other.title &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RulesDocument')
          ..add('key', key)
          ..add('title', title)
          ..add('url', url))
        .toString();
  }
}

class RulesDocumentBuilder
    implements Builder<RulesDocument, RulesDocumentBuilder> {
  _$RulesDocument? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  RulesDocumentBuilder() {
    RulesDocument._defaults(this);
  }

  RulesDocumentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _title = $v.title;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RulesDocument other) {
    _$v = other as _$RulesDocument;
  }

  @override
  void update(void Function(RulesDocumentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RulesDocument build() => _build();

  _$RulesDocument _build() {
    final _$result =
        _$v ??
        _$RulesDocument._(
          key: BuiltValueNullFieldError.checkNotNull(
            key,
            r'RulesDocument',
            'key',
          ),
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'RulesDocument',
            'title',
          ),
          url: BuiltValueNullFieldError.checkNotNull(
            url,
            r'RulesDocument',
            'url',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
