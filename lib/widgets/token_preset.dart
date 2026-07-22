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
/// (this colour/label, this `toggleable`) onto the model — it's a shortcut for the Custom builder,
/// nothing more: no link back to what produced it, no engine, no duration (see CARNEVALEB-16).
class TokenPreset {
  const TokenPreset({
    required this.label,
    required this.color,
    required this.toggleable,
  });

  final String label;
  final api.TokenColorEnum color;

  /// Per-preset: a per-turn/round buff is toggleable; a game-long one (a Capodecina aura) is not.
  final bool toggleable;
}

/// Curated spell buffs, by exact catalog name — a spell's text doesn't say "buff", so which ones
/// matter is hand-picked. A buff is cast on an ally, so it's offered on any model of the *casting*
/// gang. Teal, so a glance reads "friendly". Grow after in-game review.
const Set<String> kBuffSpellNames = {
  'Bloodlust',
  'Protection of the Eye',
  'Eldritch Armour',
  'Defender of Destiny',
  'Cantrip of the Stars',
  'Blessing of the Sky',
  'Glimpse of Glory',
  'Renewed Vigour',
  'Walk Between Worlds',
  'They Sleep Underwater',
};

/// Curated spell debuffs, by exact catalog name. A debuff is cast on the *enemy*, so it appears in
/// the target's own Predefined list, sourced from the *opposing* gang's spells. Crimson = "on me, and
/// it's not mine".
const Set<String> kDebuffSpellNames = {
  "Marksman's Fortune",
  'Curse of the Rent',
  'Sunder Armour',
};

/// Curated buffs that live on a model's *special rules*, keyed by the exact special-rule name. Offered
/// gang-wide (a support model's aura covers its allies). Start small; grow after in-game review.
const Map<String, TokenPreset> kSpecialRulePresets = {
  // Capodecina — a game-long re-roll aura granted to friendly models, so it isn't toggleable.
  'Fight For the Guild!': TokenPreset(
    label: 'Fight for the Guild',
    color: api.TokenColorEnum.azure,
    toggleable: false,
  ),
};

const _buffColor = api.TokenColorEnum.teal;
const _debuffColor = api.TokenColorEnum.crimson;

/// The predefined tokens offered on a model of the current player's gang:
/// - curated special-rule buffs present on an in-gang profile ([ownProfiles]),
/// - spell buffs the player's own gang ([ownEntries]) can cast on it,
/// - spell debuffs the *opposing* gang ([opponentEntries]) can cast on it.
///
/// Spell buffs/debuffs are gathered gang-wide, since a buff lands on any ally and a debuff on any
/// enemy. Deduped by label; special-rule buffs first, then spell buffs, then incoming debuffs.
List<TokenPreset> predefinedPresetsFor({
  required Iterable<api.ListEntry> ownEntries,
  required Iterable<api.Profile> ownProfiles,
  required Iterable<api.ListEntry> opponentEntries,
}) {
  final out = <TokenPreset>[];
  final seen = <String>{};
  void add(TokenPreset p) {
    if (seen.add(p.label)) out.add(p);
  }

  // Special-rule buffs — only those actually present on a profile that's in this gang.
  final ownRefIds = ownEntries.map((e) => e.entryId).toSet();
  for (final p in ownProfiles) {
    if (!p.cardReferences.any((c) => ownRefIds.contains(c.id))) continue;
    for (final r in p.specialRules) {
      final preset = kSpecialRulePresets[r.name];
      if (preset != null) add(preset);
    }
  }
  // Spell buffs this gang can cast.
  for (final e in ownEntries) {
    for (final s in knownSpellsFor(e)) {
      if (kBuffSpellNames.contains(s.name)) {
        add(TokenPreset(label: s.name, color: _buffColor, toggleable: true));
      }
    }
  }
  // Spell debuffs the opposing gang can cast on this model.
  for (final e in opponentEntries) {
    for (final s in knownSpellsFor(e)) {
      if (kDebuffSpellNames.contains(s.name)) {
        add(TokenPreset(label: s.name, color: _debuffColor, toggleable: true));
      }
    }
  }
  return out;
}
