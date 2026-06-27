// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_input_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryInputEntry extends EntryInputEntry {
  @override
  final int listId;
  @override
  final int cardReferenceId;

  factory _$EntryInputEntry([void Function(EntryInputEntryBuilder)? updates]) =>
      (EntryInputEntryBuilder()..update(updates))._build();

  _$EntryInputEntry._({required this.listId, required this.cardReferenceId})
    : super._();
  @override
  EntryInputEntry rebuild(void Function(EntryInputEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryInputEntryBuilder toBuilder() => EntryInputEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryInputEntry &&
        listId == other.listId &&
        cardReferenceId == other.cardReferenceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listId.hashCode);
    _$hash = $jc(_$hash, cardReferenceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EntryInputEntry')
          ..add('listId', listId)
          ..add('cardReferenceId', cardReferenceId))
        .toString();
  }
}

class EntryInputEntryBuilder
    implements Builder<EntryInputEntry, EntryInputEntryBuilder> {
  _$EntryInputEntry? _$v;

  int? _listId;
  int? get listId => _$this._listId;
  set listId(int? listId) => _$this._listId = listId;

  int? _cardReferenceId;
  int? get cardReferenceId => _$this._cardReferenceId;
  set cardReferenceId(int? cardReferenceId) =>
      _$this._cardReferenceId = cardReferenceId;

  EntryInputEntryBuilder() {
    EntryInputEntry._defaults(this);
  }

  EntryInputEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listId = $v.listId;
      _cardReferenceId = $v.cardReferenceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryInputEntry other) {
    _$v = other as _$EntryInputEntry;
  }

  @override
  void update(void Function(EntryInputEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryInputEntry build() => _build();

  _$EntryInputEntry _build() {
    final _$result =
        _$v ??
        _$EntryInputEntry._(
          listId: BuiltValueNullFieldError.checkNotNull(
            listId,
            r'EntryInputEntry',
            'listId',
          ),
          cardReferenceId: BuiltValueNullFieldError.checkNotNull(
            cardReferenceId,
            r'EntryInputEntry',
            'cardReferenceId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
