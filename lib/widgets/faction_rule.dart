import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import 'faction_badge.dart';
import 'themed_dialog_card.dart';

/// A faction's signature Command Ability (the first page of each faction sheet). Every faction has
/// exactly one, and all of them are Pulse Command Abilities, so that label is shown uniformly in the
/// dialog rather than stored per rule.
///
/// This is fixed rulebook text keyed by faction slug — the same place [AppPalette] keeps each
/// faction's colour and icon — so it ships with the app rather than being served by the catalog API.
class FactionSpecialRule {
  const FactionSpecialRule({
    required this.factionName,
    required this.abilityName,
    required this.description,
    this.note,
  });

  /// The faction as printed, e.g. "The Guild" (the enum slug is only 'guild').
  final String factionName;

  /// The Command Ability's name, e.g. "Mob Mentality".
  final String abilityName;

  /// The ability's effect, verbatim from the faction sheet. Paragraphs are split on blank lines.
  final String description;

  /// A standing faction rule shown above the ability, where one exists — only the Gifted carry one.
  final String? note;
}

/// Faction special rules keyed by the faction enum slug (HasFaction::FACTIONS on the backend).
/// Every faction is covered; callers still treat a missing entry as "this faction has no rule
/// button" so an unrecognised slug degrades quietly rather than throwing.
const Map<String, FactionSpecialRule> factionSpecialRules = {
  'guild': FactionSpecialRule(
    factionName: 'The Guild',
    abilityName: 'Mob Mentality',
    description:
        'For every friendly character in line of sight to this character '
        '(including this character), add a re-roll to your Mob Mentality Pool.\n\n'
        'Until the end of the round, any friendly character may use these re-rolls '
        'on any roll - one re-roll per dice.',
  ),
  'patricians': FactionSpecialRule(
    factionName: 'Patricians',
    abilityName: 'Let the Masquerata Begin',
    description:
        'This character gains 1 AP for this turn.\n\n'
        'If this character has the Councillor keyword, roll a dice. On a 7+ this '
        'Command Ability doesn\'t use a Command Point.',
  ),
  'strigoi': FactionSpecialRule(
    factionName: 'Strigoi',
    abilityName: 'Necrotic Mist',
    description:
        'Until the end of the round, all friendly characters within 6" of this '
        'character count as being in Cover.',
  ),
  'vatican': FactionSpecialRule(
    factionName: 'The Vatican',
    abilityName: 'Heavenly Father Guide Us',
    description:
        'This character replenishes 2 Will Points and every other friendly character '
        'within 3" replenishes 1 Will Point.',
  ),
  'doctors': FactionSpecialRule(
    factionName: 'The Doctors',
    abilityName: 'Nexus Link Reconfiguration',
    description:
        'Pick 2 friendly characters within 6" (including the character using the '
        'Command Ability).\n\n'
        'One character loses all of their Will Points. For every Will Point lost, the '
        'other character replenishes 2 Will Points.',
  ),
  'rashaar': FactionSpecialRule(
    factionName: 'Rashaar',
    abilityName: 'Soul Drain',
    description:
        'Make a Basic MIND Roll.\n\n'
        'The number of Aces is the number of Life Points lost by any one character '
        '(friendly or enemy) in base contact. Replenish that many Will Points.',
  ),
  'gifted': FactionSpecialRule(
    factionName: 'Gifted',
    abilityName: "What's My Cue?",
    note:
        'Any character with the Faction (Gifted) keyword can be taken in any gang.',
    description:
        'Use this Command Ability at the start of the round, before rolling '
        'initiative. The character you have chosen to roll initiative uses this '
        'ability.\n\n'
        'Instead of rolling, you decide which player gets to take first turn this round.',
  ),
};

/// Popup showing a faction's Command Ability — the faction badge and name, the ability name under a
/// "Pulse Command Ability" label, and its effect. Opened from the faction-rule button above the
/// gang list. A no-op for a faction with no rule on file (e.g. Rashaar), so callers can hide the
/// button on [factionSpecialRules] membership and never reach here otherwise.
void showFactionRuleDialog(BuildContext context, String faction) {
  final rule = factionSpecialRules[faction];
  if (rule == null) return;
  final color = AppPalette.factionColors[faction] ?? context.accentColor;
  showDialog(
    context: context,
    builder: (context) => ThemedDialogCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FactionBadge(faction: faction, color: color, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  rule.factionName,
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: context.subtleTextColor.withValues(alpha: 0.3),
            thickness: 0.5,
          ),
          const SizedBox(height: 12),
          if (rule.note != null) ...[
            Text(
              rule.note!,
              style: TextStyle(
                fontSize: 13,
                color: context.subtleTextColor,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            rule.abilityName,
            style: GoogleFonts.cinzel(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Pulse Command Ability',
            style: GoogleFonts.cinzel(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: context.accentColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            rule.description,
            style: TextStyle(
              fontSize: 13,
              color: context.textColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}
