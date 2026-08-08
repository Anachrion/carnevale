// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gang_import_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GangImportResult extends GangImportResult {
  @override
  final ModelList list;
  @override
  final BuiltList<String> warnings;

  factory _$GangImportResult([
    void Function(GangImportResultBuilder)? updates,
  ]) => (GangImportResultBuilder()..update(updates))._build();

  _$GangImportResult._({required this.list, required this.warnings})
    : super._();
  @override
  GangImportResult rebuild(void Function(GangImportResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GangImportResultBuilder toBuilder() =>
      GangImportResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GangImportResult &&
        list == other.list &&
        warnings == other.warnings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, warnings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GangImportResult')
          ..add('list', list)
          ..add('warnings', warnings))
        .toString();
  }
}

class GangImportResultBuilder
    implements Builder<GangImportResult, GangImportResultBuilder> {
  _$GangImportResult? _$v;

  ModelListBuilder? _list;
  ModelListBuilder get list => _$this._list ??= ModelListBuilder();
  set list(ModelListBuilder? list) => _$this._list = list;

  ListBuilder<String>? _warnings;
  ListBuilder<String> get warnings =>
      _$this._warnings ??= ListBuilder<String>();
  set warnings(ListBuilder<String>? warnings) => _$this._warnings = warnings;

  GangImportResultBuilder() {
    GangImportResult._defaults(this);
  }

  GangImportResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _list = $v.list.toBuilder();
      _warnings = $v.warnings.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GangImportResult other) {
    _$v = other as _$GangImportResult;
  }

  @override
  void update(void Function(GangImportResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GangImportResult build() => _build();

  _$GangImportResult _build() {
    _$GangImportResult _$result;
    try {
      _$result =
          _$v ??
          _$GangImportResult._(list: list.build(), warnings: warnings.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'list';
        list.build();
        _$failedField = 'warnings';
        warnings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'GangImportResult',
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
