// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_illustration_input_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryIllustrationInputEntry extends EntryIllustrationInputEntry {
  @override
  final int entryId;

  factory _$EntryIllustrationInputEntry([
    void Function(EntryIllustrationInputEntryBuilder)? updates,
  ]) => (EntryIllustrationInputEntryBuilder()..update(updates))._build();

  _$EntryIllustrationInputEntry._({required this.entryId}) : super._();
  @override
  EntryIllustrationInputEntry rebuild(
    void Function(EntryIllustrationInputEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EntryIllustrationInputEntryBuilder toBuilder() =>
      EntryIllustrationInputEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryIllustrationInputEntry && entryId == other.entryId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entryId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EntryIllustrationInputEntry',
    )..add('entryId', entryId)).toString();
  }
}

class EntryIllustrationInputEntryBuilder
    implements
        Builder<
          EntryIllustrationInputEntry,
          EntryIllustrationInputEntryBuilder
        > {
  _$EntryIllustrationInputEntry? _$v;

  int? _entryId;
  int? get entryId => _$this._entryId;
  set entryId(int? entryId) => _$this._entryId = entryId;

  EntryIllustrationInputEntryBuilder() {
    EntryIllustrationInputEntry._defaults(this);
  }

  EntryIllustrationInputEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entryId = $v.entryId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryIllustrationInputEntry other) {
    _$v = other as _$EntryIllustrationInputEntry;
  }

  @override
  void update(void Function(EntryIllustrationInputEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryIllustrationInputEntry build() => _build();

  _$EntryIllustrationInputEntry _build() {
    final _$result =
        _$v ??
        _$EntryIllustrationInputEntry._(
          entryId: BuiltValueNullFieldError.checkNotNull(
            entryId,
            r'EntryIllustrationInputEntry',
            'entryId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
