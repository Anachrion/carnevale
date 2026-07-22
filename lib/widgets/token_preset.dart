// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:carnevale_api/carnevale_api.dart' as api;

import 'spell_chips.dart';

/// A ready-made token offered in the Edit modal's Predefined tab. Tapping it drops an ordinary token
/// ([text] label, [color], [toggleable]) onto the model — a shortcut for the Custom builder, nothing
/// more: no link back to what produced it, no engine, no duration (see CARNEVALEB-16).
///
/// [source] is the exact catalog name (a spell or a special rule) that gates the preset: a **buff**
/// is offered when the current player's own gang has it, a **debuff** when the *opposing* gang has it
/// (a debuff is cast on the enemy, so it appears in the target's list). [label] overrides the token's
/// text when the catalog name is too long or differs from what should read on the tile.
class TokenPreset {
  const TokenPreset(
    this.source, {
    this.label,
    this.faction,
    required this.color,
    this.toggleable = false,
    this.debuff = false,
    this.count,
  });

  /// The catalog spell/special-rule name that a gang must have for this preset to be offered. When
  /// [faction] is set this is just the identity/label fallback — sourcing goes by faction instead.
  final String source;

  /// If set, the preset is offered by the gang's *faction* rather than a specific spell/rule — for a
  /// faction-wide ability the catalog doesn't model per-model (e.g. a Strigoi command ability).
  final String? faction;

  /// The token's label; defaults to [source] when null. See [text].
  final String? label;
  final api.TokenColorEnum color;

  /// Per-preset: a per-turn/round effect is toggleable; a game-long one is not.
  final bool toggleable;

  /// Sourced from the opposing gang (cast on us) rather than our own.
  final bool debuff;

  /// A counter preset's starting value; null when the preset isn't a counter.
  final int? count;

  /// The label the dropped token carries.
  String get text => label ?? source;
}

// Colour-codes the kind: a spell buff, an ability/special-rule buff, and (either kind of) debuff.
const _spellBuff = api.TokenColorEnum.teal;
const _ruleBuff = api.TokenColorEnum.azure;
const _debuff = api.TokenColorEnum.crimson;

/// Every predefined token, keyed by the exact catalog name it's sourced from. Buffs are offered on
/// models of the gang that has the spell/rule; debuffs on the opposing side's models. Curated by hand
/// (a spell/rule's text doesn't say "buff") — grow after in-game review.
const List<TokenPreset> kPredefinedPresets = [
  // --- Spell buffs (own gang) ---
  TokenPreset('Bloodlust', color: _spellBuff, toggleable: true),
  TokenPreset('Protection of the Eye', color: _spellBuff, toggleable: true),
  TokenPreset('Eldritch Armour', color: _spellBuff, toggleable: true),
  TokenPreset('Defender of Destiny', color: _spellBuff, toggleable: true),
  TokenPreset('Cantrip of the Stars', color: _spellBuff, toggleable: true),
  TokenPreset('Blessing of the Sky', color: _spellBuff, toggleable: true),
  TokenPreset('Glimpse of Glory', color: _spellBuff, toggleable: true),
  TokenPreset('Renewed Vigour', color: _spellBuff, toggleable: true),
  TokenPreset('Walk Between Worlds', color: _spellBuff, toggleable: true),
  TokenPreset('They Sleep Underwater', color: _spellBuff, toggleable: true),

  // --- Spell debuffs (opposing gang) ---
  TokenPreset("Marksman's Fortune", color: _debuff, toggleable: true, debuff: true),
  TokenPreset('Curse of the Rent', color: _debuff, toggleable: true, debuff: true),
  TokenPreset('Sunder Armour', color: _debuff, toggleable: true, debuff: true),

  // --- Guild special rules ---
  TokenPreset('Fight For the Guild!', label: 'Fight for the Guild', color: _ruleBuff),
  TokenPreset('Toughen Up', color: _ruleBuff, toggleable: true),
  TokenPreset('Start the Horrorshow!', color: _ruleBuff, toggleable: true),
  TokenPreset("Don't Let Them Take You!", color: _ruleBuff),
  TokenPreset("Strike When They're Vulnerable", color: _ruleBuff, toggleable: true),
  TokenPreset('Full Tilt!', color: _ruleBuff, toggleable: true),
  TokenPreset('Thieves Guild Training', color: _ruleBuff),
  TokenPreset('Rally to the Light!', color: _ruleBuff, toggleable: true),
  TokenPreset('Hearty Fish Soup', color: _ruleBuff, toggleable: true),
  TokenPreset('Prey Upon', color: _ruleBuff),
  TokenPreset('Go For the Eyes', color: _ruleBuff),
  TokenPreset('Intimidation', color: _ruleBuff, toggleable: true),
  TokenPreset('Fancy a Tipple?', color: _ruleBuff, toggleable: true),
  TokenPreset('Bring it Down!', color: _ruleBuff),
  TokenPreset('Extortion', color: _ruleBuff, toggleable: true),
  TokenPreset('Get to the Roof', color: _ruleBuff),

  // --- Other special rules (buffs unless marked) ---
  TokenPreset('Protective Bubble - 1AP', label: 'Protective Bubble', color: _ruleBuff, toggleable: true),
  TokenPreset('Justice Served', color: _debuff, debuff: true),
  TokenPreset('Always Scheming', color: _ruleBuff, toggleable: true),
  TokenPreset('All According to Plan', color: _ruleBuff, toggleable: true),
  TokenPreset('Vindictive', color: _debuff, debuff: true),
  TokenPreset('You there! Do something!', color: _ruleBuff, toggleable: true),
  TokenPreset('Take Arms', color: _ruleBuff, toggleable: true),
  TokenPreset('Aim Fire!', color: _ruleBuff, toggleable: true),
  TokenPreset('The Monster Behind the Mask', color: _ruleBuff, toggleable: true),
  TokenPreset('Venetian Drive', color: _ruleBuff, toggleable: true),
  TokenPreset('Coordinated Attack', color: _ruleBuff, toggleable: true),
  TokenPreset('Take Aim!', color: _ruleBuff, toggleable: true),
  TokenPreset('The Other, Other White Meat', color: _ruleBuff, toggleable: true),
  TokenPreset('We Trained For This', color: _ruleBuff, toggleable: true),
  TokenPreset('Barbary Discipline', color: _ruleBuff, toggleable: true),
  TokenPreset('Sadism', color: _ruleBuff, toggleable: true),
  TokenPreset('Gun Laying', color: _ruleBuff, toggleable: true),
  TokenPreset("There's Coin in it for You", color: _ruleBuff, toggleable: true),
  TokenPreset('Fury of Dagon', color: _ruleBuff, toggleable: true),
  TokenPreset('Shield to the Enlightened', color: _ruleBuff, toggleable: true),
  TokenPreset('Hide of The Deep', color: _ruleBuff, toggleable: true),
  TokenPreset('Blessing of Dagon', color: _ruleBuff, toggleable: true),
  TokenPreset('Fanaticism For Dagon', color: _ruleBuff, toggleable: true),
  TokenPreset('Bolster Your Faith', color: _ruleBuff, toggleable: true),
  TokenPreset('Prove Yourselves to Dagon!', color: _ruleBuff, toggleable: true),
  TokenPreset('Gift of the Elder Gods', color: _ruleBuff, toggleable: true),
  TokenPreset('Hypnotic Song', color: _ruleBuff, toggleable: true),
  TokenPreset('Writhe Inside', color: _ruleBuff),
  TokenPreset('Clairvoyancy', color: _ruleBuff, toggleable: true),
  TokenPreset('Blood Frenzy', color: _ruleBuff, toggleable: true),
  TokenPreset('Defensive Lines', color: _ruleBuff, toggleable: true),
  TokenPreset('Natural Camouflage', color: _ruleBuff, toggleable: true),
  TokenPreset('Romani Fury', color: _ruleBuff, toggleable: true),
  TokenPreset('African Bewitching', color: _ruleBuff, toggleable: true),
  TokenPreset('Eastern Swiftness', color: _ruleBuff, toggleable: true),
  TokenPreset('Bankroll', color: _ruleBuff, toggleable: true),
  TokenPreset('Lunar Might', color: _ruleBuff),
  TokenPreset('Judgement', color: _debuff, debuff: true),
  TokenPreset('Rejuvenated', color: _ruleBuff, toggleable: true),
  TokenPreset('Mind Gazing', color: _ruleBuff, toggleable: true),
  TokenPreset('Unliving Curse', color: _ruleBuff),
  TokenPreset('Electrical Stimulation', color: _ruleBuff),
  TokenPreset('Protective Field', color: _ruleBuff, toggleable: true),
  TokenPreset('Biological Studies', color: _ruleBuff, toggleable: true),
  // Elixir is the Doctor of Poisons' single rule; in play they pick one variant for the game, so
  // offer all three labels off it (the "(3)" on Acrobatic is part of the buff and kept).
  TokenPreset('Elixir', label: 'Elixir Acrobatic (3)', color: _ruleBuff),
  TokenPreset('Elixir', label: 'Elixir Engage', color: _ruleBuff),
  TokenPreset('Elixir', label: 'Elixir Slippery', color: _ruleBuff),
  TokenPreset('Overcharged Discipline', color: _ruleBuff),
  TokenPreset('Void Walker', color: _ruleBuff),
  TokenPreset('Regenerating', color: _ruleBuff, toggleable: true),
  TokenPreset('He Will Strengthen You and Protect You', color: _ruleBuff, toggleable: true),
  TokenPreset('Gates of Heaven', color: _ruleBuff, toggleable: true),
  TokenPreset('Fear the Lord', color: _ruleBuff, toggleable: true),
  TokenPreset('For the Glory of God', color: _ruleBuff, toggleable: true),
  TokenPreset('Fight Until the Last', color: _ruleBuff),
  TokenPreset('Put it Through the Heart!', color: _ruleBuff, toggleable: true),
  TokenPreset('Walk Through The Fire And You Will Not Be Burned', label: 'Holy Flame', color: _ruleBuff, toggleable: true),
  TokenPreset('Look With Satisfaction Upon My Enemies', color: _ruleBuff, toggleable: true),
  TokenPreset('Hasten Your Steps, The Unfaithful Must Be Cleansed', label: 'Hasten', color: _ruleBuff, toggleable: true),
  TokenPreset('Spurring Incense - 1AP', label: 'Spurring Incense', color: _ruleBuff, toggleable: true),

  // --- Counter special rules (a running total that grows or spends; tap to step it) ---
  TokenPreset('Gifts of Dried Meats', color: _ruleBuff, count: 3),
  TokenPreset('Impaler', color: _ruleBuff, count: 0),
  // The End is Near boosts one of three stats each turn; offer all three off the one rule.
  TokenPreset('The End is Near', label: 'The End is Near — Mv.', color: _ruleBuff, count: 0),
  TokenPreset('The End is Near', label: 'The End is Near — Dex.', color: _ruleBuff, count: 0),
  TokenPreset('The End is Near', label: 'The End is Near — Att.', color: _ruleBuff, count: 0),

  // --- Faction abilities (not modelled per-model in the catalog; offered by the gang's faction) ---
  // Necrotic Mist — a Strigoi command ability, available whenever the gang is Strigoi.
  TokenPreset('Necrotic Mist', faction: 'strigoi', color: _ruleBuff, toggleable: true),
];

// Every spell + special-rule name a gang has, across its in-gang models — the pool a preset's
// [TokenPreset.source] is checked against.
Set<String> _possessedNames(
  Iterable<api.ListEntry> entries,
  Iterable<api.Profile> profiles,
) {
  final names = <String>{};
  for (final e in entries) {
    for (final s in knownSpellsFor(e)) {
      names.add(s.name);
    }
  }
  final refIds = entries.map((e) => e.entryId).toSet();
  for (final p in profiles) {
    if (!p.cardReferences.any((c) => refIds.contains(c.id))) continue;
    for (final r in p.specialRules) {
      names.add(r.name);
    }
  }
  return names;
}

/// The predefined tokens offered on a model of the current player's gang: buffs the player's own gang
/// ([ownEntries] / [ownProfiles]) has, plus debuffs the opposing gang ([opponentEntries] /
/// [opponentProfiles]) has (a debuff is cast on us, so it's sourced from the caster's side). Deduped
/// by label, in list order.
List<TokenPreset> predefinedPresetsFor({
  required Iterable<api.ListEntry> ownEntries,
  required Iterable<api.Profile> ownProfiles,
  required String ownFaction,
  required Iterable<api.ListEntry> opponentEntries,
  required Iterable<api.Profile> opponentProfiles,
  required String opponentFaction,
}) {
  final ownNames = _possessedNames(ownEntries, ownProfiles);
  final oppNames = _possessedNames(opponentEntries, opponentProfiles);
  final out = <TokenPreset>[];
  final seen = <String>{};
  for (final p in kPredefinedPresets) {
    // A buff is checked against our side, a debuff against the opposing side (it's cast on us).
    final bool has;
    if (p.faction != null) {
      has = (p.debuff ? opponentFaction : ownFaction) == p.faction;
    } else {
      has = (p.debuff ? oppNames : ownNames).contains(p.source);
    }
    if (!has) continue;
    if (seen.add(p.text)) out.add(p);
  }
  return out;
}
