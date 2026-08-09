// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transform_entry_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TransformEntryInput extends TransformEntryInput {
  @override
  final bool transformed;

  factory _$TransformEntryInput([
    void Function(TransformEntryInputBuilder)? updates,
  ]) => (TransformEntryInputBuilder()..update(updates))._build();

  _$TransformEntryInput._({required this.transformed}) : super._();
  @override
  TransformEntryInput rebuild(
    void Function(TransformEntryInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TransformEntryInputBuilder toBuilder() =>
      TransformEntryInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransformEntryInput && transformed == other.transformed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, transformed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'TransformEntryInput',
    )..add('transformed', transformed)).toString();
  }
}

class TransformEntryInputBuilder
    implements Builder<TransformEntryInput, TransformEntryInputBuilder> {
  _$TransformEntryInput? _$v;

  bool? _transformed;
  bool? get transformed => _$this._transformed;
  set transformed(bool? transformed) => _$this._transformed = transformed;

  TransformEntryInputBuilder() {
    TransformEntryInput._defaults(this);
  }

  TransformEntryInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _transformed = $v.transformed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransformEntryInput other) {
    _$v = other as _$TransformEntryInput;
  }

  @override
  void update(void Function(TransformEntryInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransformEntryInput build() => _build();

  _$TransformEntryInput _build() {
    final _$result =
        _$v ??
        _$TransformEntryInput._(
          transformed: BuiltValueNullFieldError.checkNotNull(
            transformed,
            r'TransformEntryInput',
            'transformed',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
