// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_illustration_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryIllustrationInput extends EntryIllustrationInput {
  @override
  final EntryIllustrationInputEntry entry;

  factory _$EntryIllustrationInput([
    void Function(EntryIllustrationInputBuilder)? updates,
  ]) => (EntryIllustrationInputBuilder()..update(updates))._build();

  _$EntryIllustrationInput._({required this.entry}) : super._();
  @override
  EntryIllustrationInput rebuild(
    void Function(EntryIllustrationInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EntryIllustrationInputBuilder toBuilder() =>
      EntryIllustrationInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryIllustrationInput && entry == other.entry;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entry.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EntryIllustrationInput',
    )..add('entry', entry)).toString();
  }
}

class EntryIllustrationInputBuilder
    implements Builder<EntryIllustrationInput, EntryIllustrationInputBuilder> {
  _$EntryIllustrationInput? _$v;

  EntryIllustrationInputEntryBuilder? _entry;
  EntryIllustrationInputEntryBuilder get entry =>
      _$this._entry ??= EntryIllustrationInputEntryBuilder();
  set entry(EntryIllustrationInputEntryBuilder? entry) => _$this._entry = entry;

  EntryIllustrationInputBuilder() {
    EntryIllustrationInput._defaults(this);
  }

  EntryIllustrationInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entry = $v.entry.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryIllustrationInput other) {
    _$v = other as _$EntryIllustrationInput;
  }

  @override
  void update(void Function(EntryIllustrationInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryIllustrationInput build() => _build();

  _$EntryIllustrationInput _build() {
    _$EntryIllustrationInput _$result;
    try {
      _$result = _$v ?? _$EntryIllustrationInput._(entry: entry.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entry';
        entry.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EntryIllustrationInput',
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
