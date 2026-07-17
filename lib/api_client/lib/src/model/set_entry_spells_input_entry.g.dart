// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_entry_spells_input_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetEntrySpellsInputEntry extends SetEntrySpellsInputEntry {
  @override
  final int? mentoredByEntryId;
  @override
  final BuiltList<SetEntrySpellsInputEntryPoolSelectionsInner>? poolSelections;

  factory _$SetEntrySpellsInputEntry([
    void Function(SetEntrySpellsInputEntryBuilder)? updates,
  ]) => (SetEntrySpellsInputEntryBuilder()..update(updates))._build();

  _$SetEntrySpellsInputEntry._({this.mentoredByEntryId, this.poolSelections})
    : super._();
  @override
  SetEntrySpellsInputEntry rebuild(
    void Function(SetEntrySpellsInputEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SetEntrySpellsInputEntryBuilder toBuilder() =>
      SetEntrySpellsInputEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetEntrySpellsInputEntry &&
        mentoredByEntryId == other.mentoredByEntryId &&
        poolSelections == other.poolSelections;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mentoredByEntryId.hashCode);
    _$hash = $jc(_$hash, poolSelections.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetEntrySpellsInputEntry')
          ..add('mentoredByEntryId', mentoredByEntryId)
          ..add('poolSelections', poolSelections))
        .toString();
  }
}

class SetEntrySpellsInputEntryBuilder
    implements
        Builder<SetEntrySpellsInputEntry, SetEntrySpellsInputEntryBuilder> {
  _$SetEntrySpellsInputEntry? _$v;

  int? _mentoredByEntryId;
  int? get mentoredByEntryId => _$this._mentoredByEntryId;
  set mentoredByEntryId(int? mentoredByEntryId) =>
      _$this._mentoredByEntryId = mentoredByEntryId;

  ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInner>? _poolSelections;
  ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInner> get poolSelections =>
      _$this._poolSelections ??=
          ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInner>();
  set poolSelections(
    ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInner>? poolSelections,
  ) => _$this._poolSelections = poolSelections;

  SetEntrySpellsInputEntryBuilder() {
    SetEntrySpellsInputEntry._defaults(this);
  }

  SetEntrySpellsInputEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mentoredByEntryId = $v.mentoredByEntryId;
      _poolSelections = $v.poolSelections?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetEntrySpellsInputEntry other) {
    _$v = other as _$SetEntrySpellsInputEntry;
  }

  @override
  void update(void Function(SetEntrySpellsInputEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetEntrySpellsInputEntry build() => _build();

  _$SetEntrySpellsInputEntry _build() {
    _$SetEntrySpellsInputEntry _$result;
    try {
      _$result =
          _$v ??
          _$SetEntrySpellsInputEntry._(
            mentoredByEntryId: mentoredByEntryId,
            poolSelections: _poolSelections?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'poolSelections';
        _poolSelections?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SetEntrySpellsInputEntry',
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
