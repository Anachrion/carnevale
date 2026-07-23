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

/// A model whose special rule *grants* a labelled effect at the table — either a **Mask** (given to
/// another friendly model, once per game, kept all game) or a **choice** the model makes on itself at
/// the start of its activation (re-picked each round). Both collapse to the same thing in the app: a
/// pick from a curated option list that drops a static, non-editable token carrying the granted
/// effect's label. The two axes that differ are the flags below.
///
/// We only display the effect as a token label — stats/abilities aren't applied (the app shows stats
/// as cards, not a live engine). The token itself is an ordinary [api.Token] persisted through the
/// normal token endpoint, so a grant syncs across devices and to the opponent like any other marker;
/// only this catalog (which model grants what) lives in the client, identical on every build.
class GrantSource {
  const GrantSource({
    required this.rule,
    required this.targetsOther,
    required this.oncePerGame,
    required this.options,
  });

  /// The special-rule name that identifies the model (matched against [api.Profile.specialRules]).
  final String rule;

  /// A Mask targets *another* friendly model; a choice targets the model itself.
  final bool targetsOther;

  /// A Mask is given once per game (the button is consumed until undone); a choice is re-picked every
  /// round, replacing the previous pick in place.
  final bool oncePerGame;

  /// The granted-effect labels offered. A single option (Francisco's Oath) skips the variant step.
  final List<String> options;
}

/// The colour every grant token carries — the same azure the rule-buff presets use, so a granted
/// effect reads as one of that family on the tile.
const api.TokenColorEnum grantColor = api.TokenColorEnum.azure;

/// Every mask giver and choice model, keyed by the special rule that drives the grant. Labels are the
/// *granted effect* (what the model actually gains), kept within the token's 40-char limit.
const List<GrantSource> kGrantSources = [
  // --- Masks: given to another friendly model, once per game, kept all game ---
  GrantSource(
    rule: 'Fanged Visage', // Artisan Elena
    targetsOther: true,
    oncePerGame: true,
    options: [
      'Frenzied + Vamp. Attack (2), WP 0',
      'First Strike (1) + Vamp. Attack (1)',
    ],
  ),
  GrantSource(
    rule: 'Mask of Many Faces', // Il Mentore
    targetsOther: true,
    oncePerGame: true,
    options: [
      'Pickpocket + Slippery (2)',
      'Aerial Attack + Infiltrate',
    ],
  ),
  GrantSource(
    rule: 'The Mask Makes the Noble', // Marco Leontus
    targetsOther: true,
    oncePerGame: true,
    options: [
      '+2 Command Points',
      'Boat Crew + Bodyguard (Leader)',
    ],
  ),
  GrantSource(
    rule: 'Armourer', // Master Gerhard
    targetsOther: true,
    oncePerGame: true,
    options: [
      'Universal Shielding (2)',
      '+1 Dmg vs 0-WP targets',
    ],
  ),
  GrantSource(
    rule: 'Mask of Dagon', // Solus Hydraea
    targetsOther: true,
    oncePerGame: true,
    options: [
      'Water Creature + Monster',
      'Fear (0) + +1 ATTACK',
    ],
  ),
  GrantSource(
    rule: 'Take the Oath', // Francisco De Lorme — single effect, no variant
    targetsOther: true,
    oncePerGame: true,
    options: [
      '+2 WP, Companion, shared WP 6"',
    ],
  ),

  // --- Choices: made on self at the start of activation, re-picked each round ---
  GrantSource(
    rule: 'Split Personalities', // The Mask Maker
    targetsOther: false,
    oncePerGame: false,
    options: [
      'Fear (-2)',
      'Slippery',
      'Vampiric Attack (2)',
      'Water Creature',
    ],
  ),
  GrantSource(
    rule: 'Auxiliary Systems', // Master of Arcane Security
    targetsOther: false,
    oncePerGame: false,
    options: [
      '+2 Movement',
      '+2 Dexterity',
      '+2 Protection',
    ],
  ),
];

final Map<String, GrantSource> _byRule = {
  for (final g in kGrantSources) g.rule: g,
};

/// The grant a profile provides, or null if it isn't a mask giver / choice model. Matched on the
/// model's special rules (its named rule), so a duplicate copy of the model resolves the same.
GrantSource? grantSourceFor(api.Profile profile) {
  for (final r in profile.specialRules) {
    final g = _byRule[r.name];
    if (g != null) return g;
  }
  return null;
}

/// The stable token id a giver's grant carries wherever it lands (on a Mask's target, or on a choice
/// model itself). Encoding the *giver's* entry id in the id is what lets the client re-derive, from
/// the persisted tokens alone, whether a once-per-game Mask has been used and which model wears it —
/// and lets a choice re-pick overwrite the same token in place.
String grantTokenId(int giverEntryId) => 'grant:$giverEntryId';

/// Whether a token was dropped by a grant (a Mask or a choice), by its id convention. Such tokens are
/// managed only through the grant modal — rendered non-editable on the tile and hidden from the
/// Custom token tab.
bool isGrantToken(api.Token token) => token.id.startsWith('grant:');

/// The giver entry id encoded in a grant token's id, or null if it isn't a grant token / is malformed.
int? grantGiverId(api.Token token) {
  if (!isGrantToken(token)) return null;
  return int.tryParse(token.id.substring('grant:'.length));
}

/// Whether [target] may be given a Mask by the giver at [giverEntryId]. Enforces the printed
/// restrictions: not the giver itself; not already wearing a Mask; and not an ineligible model —
/// "Unique characters without Faction (Gifted)" (a Unique keyword on a non-Gifted model) or "Mindless
/// characters" (the Mindless ability).
bool canWearMask(
  api.Profile targetProfile,
  api.ListEntry target, {
  required int giverEntryId,
}) {
  if (target.id == giverEntryId) return false;
  if (target.state?.tokens.any(isGrantToken) ?? false) return false;
  final uniqueNonGifted =
      targetProfile.keywords.contains('Unique') && targetProfile.faction != 'gifted';
  if (uniqueNonGifted) return false;
  if (targetProfile.abilities.any((a) => a.startsWith('Mindless'))) return false;
  return true;
}
