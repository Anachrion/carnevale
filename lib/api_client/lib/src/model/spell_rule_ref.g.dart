// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spell_rule_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SpellRuleRef extends SpellRuleRef {
  @override
  final String name;
  @override
  final String description;

  factory _$SpellRuleRef([void Function(SpellRuleRefBuilder)? updates]) =>
      (SpellRuleRefBuilder()..update(updates))._build();

  _$SpellRuleRef._({required this.name, required this.description}) : super._();
  @override
  SpellRuleRef rebuild(void Function(SpellRuleRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SpellRuleRefBuilder toBuilder() => SpellRuleRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SpellRuleRef &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SpellRuleRef')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class SpellRuleRefBuilder
    implements Builder<SpellRuleRef, SpellRuleRefBuilder> {
  _$SpellRuleRef? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  SpellRuleRefBuilder() {
    SpellRuleRef._defaults(this);
  }

  SpellRuleRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SpellRuleRef other) {
    _$v = other as _$SpellRuleRef;
  }

  @override
  void update(void Function(SpellRuleRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SpellRuleRef build() => _build();

  _$SpellRuleRef _build() {
    final _$result =
        _$v ??
        _$SpellRuleRef._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'SpellRuleRef',
            'name',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'SpellRuleRef',
            'description',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
