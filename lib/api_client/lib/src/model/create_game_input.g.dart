// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_game_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateGameInput extends CreateGameInput {
  @override
  final int scenarioId;
  @override
  final int? ducatLimit;
  @override
  final String? boardSize;

  factory _$CreateGameInput([void Function(CreateGameInputBuilder)? updates]) =>
      (CreateGameInputBuilder()..update(updates))._build();

  _$CreateGameInput._({
    required this.scenarioId,
    this.ducatLimit,
    this.boardSize,
  }) : super._();
  @override
  CreateGameInput rebuild(void Function(CreateGameInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateGameInputBuilder toBuilder() => CreateGameInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateGameInput &&
        scenarioId == other.scenarioId &&
        ducatLimit == other.ducatLimit &&
        boardSize == other.boardSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scenarioId.hashCode);
    _$hash = $jc(_$hash, ducatLimit.hashCode);
    _$hash = $jc(_$hash, boardSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateGameInput')
          ..add('scenarioId', scenarioId)
          ..add('ducatLimit', ducatLimit)
          ..add('boardSize', boardSize))
        .toString();
  }
}

class CreateGameInputBuilder
    implements Builder<CreateGameInput, CreateGameInputBuilder> {
  _$CreateGameInput? _$v;

  int? _scenarioId;
  int? get scenarioId => _$this._scenarioId;
  set scenarioId(int? scenarioId) => _$this._scenarioId = scenarioId;

  int? _ducatLimit;
  int? get ducatLimit => _$this._ducatLimit;
  set ducatLimit(int? ducatLimit) => _$this._ducatLimit = ducatLimit;

  String? _boardSize;
  String? get boardSize => _$this._boardSize;
  set boardSize(String? boardSize) => _$this._boardSize = boardSize;

  CreateGameInputBuilder() {
    CreateGameInput._defaults(this);
  }

  CreateGameInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scenarioId = $v.scenarioId;
      _ducatLimit = $v.ducatLimit;
      _boardSize = $v.boardSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateGameInput other) {
    _$v = other as _$CreateGameInput;
  }

  @override
  void update(void Function(CreateGameInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateGameInput build() => _build();

  _$CreateGameInput _build() {
    final _$result =
        _$v ??
        _$CreateGameInput._(
          scenarioId: BuiltValueNullFieldError.checkNotNull(
            scenarioId,
            r'CreateGameInput',
            'scenarioId',
          ),
          ducatLimit: ducatLimit,
          boardSize: boardSize,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
