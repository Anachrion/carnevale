// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_position_input_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EntryPositionInputEntry extends EntryPositionInputEntry {
  @override
  final int position;

  factory _$EntryPositionInputEntry([
    void Function(EntryPositionInputEntryBuilder)? updates,
  ]) => (EntryPositionInputEntryBuilder()..update(updates))._build();

  _$EntryPositionInputEntry._({required this.position}) : super._();
  @override
  EntryPositionInputEntry rebuild(
    void Function(EntryPositionInputEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EntryPositionInputEntryBuilder toBuilder() =>
      EntryPositionInputEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryPositionInputEntry && position == other.position;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EntryPositionInputEntry',
    )..add('position', position)).toString();
  }
}

class EntryPositionInputEntryBuilder
    implements
        Builder<EntryPositionInputEntry, EntryPositionInputEntryBuilder> {
  _$EntryPositionInputEntry? _$v;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  EntryPositionInputEntryBuilder() {
    EntryPositionInputEntry._defaults(this);
  }

  EntryPositionInputEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryPositionInputEntry other) {
    _$v = other as _$EntryPositionInputEntry;
  }

  @override
  void update(void Function(EntryPositionInputEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EntryPositionInputEntry build() => _build();

  _$EntryPositionInputEntry _build() {
    final _$result =
        _$v ??
        _$EntryPositionInputEntry._(
          position: BuiltValueNullFieldError.checkNotNull(
            position,
            r'EntryPositionInputEntry',
            'position',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
