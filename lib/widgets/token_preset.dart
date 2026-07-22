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

/// Curated buffs that live on a model's *special rules*, keyed by the exact special-rule name — a
/// rule's text doesn't say "this is a buff", so which ones matter has to be hand-picked. Start small
/// and grow after in-game review. These are offered gang-wide (see [predefinedPresetsForGang]).
const Map<String, TokenPreset> kSpecialRulePresets = {
  // Capodecina — a game-long re-roll aura granted to friendly models, so it isn't toggleable.
  'Fight For the Guild!': TokenPreset(
    label: 'Fight for the Guild',
    color: api.TokenColorEnum.azure,
    toggleable: false,
  ),
};

/// The predefined tokens offered for a gang, gathered gang-wide because buffs land on models other
/// than their source: a spell buff can be cast on an ally, a support model's aura covers the whole
/// gang. So every model's Predefined tab shows the same set — every spell any model knows, plus every
/// curated special-rule buff present in the gang. Deduped by label; curated buffs listed first.
List<TokenPreset> predefinedPresetsForGang(
  Iterable<api.ListEntry> entries,
  Iterable<api.Profile> profiles,
) {
  final out = <TokenPreset>[];
  final seen = <String>{};
  void add(TokenPreset p) {
    if (seen.add(p.label)) out.add(p);
  }

  // Curated special-rule buffs — only those actually present on a profile that's in this gang.
  final gangRefIds = entries.map((e) => e.entryId).toSet();
  for (final p in profiles) {
    if (!p.cardReferences.any((c) => gangRefIds.contains(c.id))) continue;
    for (final r in p.specialRules) {
      final preset = kSpecialRulePresets[r.name];
      if (preset != null) add(preset);
    }
  }
  // Then every spell known anywhere in the gang (a spell buff can be applied to any model).
  for (final e in entries) {
    for (final s in knownSpellsFor(e)) {
      add(TokenPreset(
        label: s.name,
        color: api.TokenColorEnum.amethyst,
        toggleable: true,
      ));
    }
  }
  return out;
}
