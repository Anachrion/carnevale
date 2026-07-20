// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_upgrade_input_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryUpgradeInputEntry extends EntryUpgradeInputEntry {
  @override
  final bool upgradeSelected;

  factory _$EntryUpgradeInputEntry([
    void Function(EntryUpgradeInputEntryBuilder)? updates,
  ]) => (EntryUpgradeInputEntryBuilder()..update(updates))._build();

  _$EntryUpgradeInputEntry._({required this.upgradeSelected}) : super._();
  @override
  EntryUpgradeInputEntry rebuild(
    void Function(EntryUpgradeInputEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EntryUpgradeInputEntryBuilder toBuilder() =>
      EntryUpgradeInputEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryUpgradeInputEntry &&
        upgradeSelected == other.upgradeSelected;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, upgradeSelected.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EntryUpgradeInputEntry',
    )..add('upgradeSelected', upgradeSelected)).toString();
  }
}

class EntryUpgradeInputEntryBuilder
    implements Builder<EntryUpgradeInputEntry, EntryUpgradeInputEntryBuilder> {
  _$EntryUpgradeInputEntry? _$v;

  bool? _upgradeSelected;
  bool? get upgradeSelected => _$this._upgradeSelected;
  set upgradeSelected(bool? upgradeSelected) =>
      _$this._upgradeSelected = upgradeSelected;

  EntryUpgradeInputEntryBuilder() {
    EntryUpgradeInputEntry._defaults(this);
  }

  EntryUpgradeInputEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _upgradeSelected = $v.upgradeSelected;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryUpgradeInputEntry other) {
    _$v = other as _$EntryUpgradeInputEntry;
  }

  @override
  void update(void Function(EntryUpgradeInputEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryUpgradeInputEntry build() => _build();

  _$EntryUpgradeInputEntry _build() {
    final _$result =
        _$v ??
        _$EntryUpgradeInputEntry._(
          upgradeSelected: BuiltValueNullFieldError.checkNotNull(
            upgradeSelected,
            r'EntryUpgradeInputEntry',
            'upgradeSelected',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
