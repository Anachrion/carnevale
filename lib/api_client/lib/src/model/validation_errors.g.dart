// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_errors.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ValidationErrors extends ValidationErrors {
  @override
  final BuiltMap<String, BuiltList<String>> errors;

  factory _$ValidationErrors([
    void Function(ValidationErrorsBuilder)? updates,
  ]) => (ValidationErrorsBuilder()..update(updates))._build();

  _$ValidationErrors._({required this.errors}) : super._();
  @override
  ValidationErrors rebuild(void Function(ValidationErrorsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ValidationErrorsBuilder toBuilder() =>
      ValidationErrorsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValidationErrors && errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ValidationErrors',
    )..add('errors', errors)).toString();
  }
}

class ValidationErrorsBuilder
    implements Builder<ValidationErrors, ValidationErrorsBuilder> {
  _$ValidationErrors? _$v;

  MapBuilder<String, BuiltList<String>>? _errors;
  MapBuilder<String, BuiltList<String>> get errors =>
      _$this._errors ??= MapBuilder<String, BuiltList<String>>();
  set errors(MapBuilder<String, BuiltList<String>>? errors) =>
      _$this._errors = errors;

  ValidationErrorsBuilder() {
    ValidationErrors._defaults(this);
  }

  ValidationErrorsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ValidationErrors other) {
    _$v = other as _$ValidationErrors;
  }

  @override
  void update(void Function(ValidationErrorsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ValidationErrors build() => _build();

  _$ValidationErrors _build() {
    _$ValidationErrors _$result;
    try {
      _$result = _$v ?? _$ValidationErrors._(errors: errors.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ValidationErrors',
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
