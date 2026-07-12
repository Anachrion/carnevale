// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_manifest_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CardManifestEntry extends CardManifestEntry {
  @override
  final String identifier;
  @override
  final String? faction;
  @override
  final int internalVersion;
  @override
  final String? frontUrl;
  @override
  final String? backUrl;
  @override
  final int? frontBytes;
  @override
  final int? backBytes;

  factory _$CardManifestEntry([
    void Function(CardManifestEntryBuilder)? updates,
  ]) => (CardManifestEntryBuilder()..update(updates))._build();

  _$CardManifestEntry._({
    required this.identifier,
    this.faction,
    required this.internalVersion,
    this.frontUrl,
    this.backUrl,
    this.frontBytes,
    this.backBytes,
  }) : super._();
  @override
  CardManifestEntry rebuild(void Function(CardManifestEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CardManifestEntryBuilder toBuilder() =>
      CardManifestEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CardManifestEntry &&
        identifier == other.identifier &&
        faction == other.faction &&
        internalVersion == other.internalVersion &&
        frontUrl == other.frontUrl &&
        backUrl == other.backUrl &&
        frontBytes == other.frontBytes &&
        backBytes == other.backBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, faction.hashCode);
    _$hash = $jc(_$hash, internalVersion.hashCode);
    _$hash = $jc(_$hash, frontUrl.hashCode);
    _$hash = $jc(_$hash, backUrl.hashCode);
    _$hash = $jc(_$hash, frontBytes.hashCode);
    _$hash = $jc(_$hash, backBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CardManifestEntry')
          ..add('identifier', identifier)
          ..add('faction', faction)
          ..add('internalVersion', internalVersion)
          ..add('frontUrl', frontUrl)
          ..add('backUrl', backUrl)
          ..add('frontBytes', frontBytes)
          ..add('backBytes', backBytes))
        .toString();
  }
}

class CardManifestEntryBuilder
    implements Builder<CardManifestEntry, CardManifestEntryBuilder> {
  _$CardManifestEntry? _$v;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _faction;
  String? get faction => _$this._faction;
  set faction(String? faction) => _$this._faction = faction;

  int? _internalVersion;
  int? get internalVersion => _$this._internalVersion;
  set internalVersion(int? internalVersion) =>
      _$this._internalVersion = internalVersion;

  String? _frontUrl;
  String? get frontUrl => _$this._frontUrl;
  set frontUrl(String? frontUrl) => _$this._frontUrl = frontUrl;

  String? _backUrl;
  String? get backUrl => _$this._backUrl;
  set backUrl(String? backUrl) => _$this._backUrl = backUrl;

  int? _frontBytes;
  int? get frontBytes => _$this._frontBytes;
  set frontBytes(int? frontBytes) => _$this._frontBytes = frontBytes;

  int? _backBytes;
  int? get backBytes => _$this._backBytes;
  set backBytes(int? backBytes) => _$this._backBytes = backBytes;

  CardManifestEntryBuilder() {
    CardManifestEntry._defaults(this);
  }

  CardManifestEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _identifier = $v.identifier;
      _faction = $v.faction;
      _internalVersion = $v.internalVersion;
      _frontUrl = $v.frontUrl;
      _backUrl = $v.backUrl;
      _frontBytes = $v.frontBytes;
      _backBytes = $v.backBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardManifestEntry other) {
    _$v = other as _$CardManifestEntry;
  }

  @override
  void update(void Function(CardManifestEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CardManifestEntry build() => _build();

  _$CardManifestEntry _build() {
    final _$result =
        _$v ??
        _$CardManifestEntry._(
          identifier: BuiltValueNullFieldError.checkNotNull(
            identifier,
            r'CardManifestEntry',
            'identifier',
          ),
          faction: faction,
          internalVersion: BuiltValueNullFieldError.checkNotNull(
            internalVersion,
            r'CardManifestEntry',
            'internalVersion',
          ),
          frontUrl: frontUrl,
          backUrl: backUrl,
          frontBytes: frontBytes,
          backBytes: backBytes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
