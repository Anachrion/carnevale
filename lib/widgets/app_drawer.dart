// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../screens/account_screen.dart';
import '../screens/cards_screen.dart';
import '../screens/game_home_screen.dart';
import '../screens/gangs_screen.dart';
import '../screens/rules_screen.dart';
import '../screens/settings_screen.dart';

enum AppDrawerRoute { home, cards, gangs, game, rules, account, settings }

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.current});

  final AppDrawerRoute current;

  void _navigate(BuildContext context, AppDrawerRoute route, Widget? screen) {
    Navigator.pop(context);
    if (route == AppDrawerRoute.home) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    } else if (route != current && screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = context.accentColor;
    final l10n = AppLocalizations.of(context);
    final borderColor = isDark
        ? AppPalette.mutedGold.withValues(alpha: 0.25)
        : AppPalette.ink.withValues(alpha: 0.15);

    return Drawer(
      backgroundColor: isDark ? AppPalette.backgroundDark : AppPalette.background,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: AnimatedBuilder(
                animation: authService,
                builder: (context, _) {
                  final user = authService.currentUser;
                  if (user != null) {
                    return SizedBox(
                      width: double.infinity,
                      child: Text(
                        user.username,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _navigate(context, AppDrawerRoute.account, const AccountScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.actionLogIn,
                        style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, letterSpacing: 1, fontSize: 13),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1, thickness: 1, color: borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NavItem(
                    label: l10n.navHome,
                    active: current == AppDrawerRoute.home,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.home, null),
                  ),
                  _NavItem(
                    label: l10n.navCards,
                    active: current == AppDrawerRoute.cards,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.cards, const CardsScreen()),
                  ),
                  _NavItem(
                    label: l10n.navGangs,
                    active: current == AppDrawerRoute.gangs,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.gangs, const GangsScreen()),
                  ),
                  _NavItem(
                    label: l10n.navGames,
                    active: current == AppDrawerRoute.game,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.game, const GameHomeScreen()),
                  ),
                  _NavItem(
                    label: l10n.navRules,
                    active: current == AppDrawerRoute.rules,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.rules, const RulesScreen()),
                  ),
                  _NavItem(
                    label: l10n.settingsTitle,
                    active: current == AppDrawerRoute.settings,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.settings, const SettingsScreen()),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: borderColor),
            const Spacer(),
            _ThemeToggle(accent: accent),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 20, 14),
          child: Row(
            children: [
              Container(width: 4, height: 22, color: active ? accent : Colors.transparent),
              const SizedBox(width: 20),
              Text(
                label.toUpperCase(),
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: active ? accent : context.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          _Ornament(accent: accent),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                isDark
                    ? AppLocalizations.of(context).drawerDarkTheme
                    : AppLocalizations.of(context).drawerLightTheme,
                style: GoogleFonts.cinzel(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: context.subtleTextColor,
                ),
              ),
              const Spacer(),
              Switch(
                value: isDark,
                activeThumbColor: accent,
                onChanged: (v) =>
                    settingsService.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Ornament extends StatelessWidget {
  const _Ornament({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final line = accent.withValues(alpha: 0.5);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 48, height: 1, color: line),
        const SizedBox(width: 6),
        Container(width: 4, height: 4, decoration: BoxDecoration(color: line, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Container(width: 48, height: 1, color: line),
      ],
    );
  }
}
