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

import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/glass_panel.dart';
import 'cards_screen.dart';
import 'game_home_screen.dart';
import 'gangs_screen.dart';
import 'rules_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.home),
      body: AppBackground(
        blurScrim: false,
        safeArea: false,
        child: SafeArea(
          child: Stack(
            children: [
              // The header + menu are scaled to fit whatever height the screen offers, so the
              // page never scrolls: full size (centered) on tall screens, gently scaled down on
              // shorter ones. FittedBox does the responsive scaling for us.
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) => Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const _Header(),
                              const SizedBox(height: 24),
                              // Cap the menu width so the buttons stay compact
                              // and horizontally centered on wide/landscape
                              // screens instead of stretching full-bleed.
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 600,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    children: [
                                      _MenuItem(
                                        imagePath:
                                            'assets/images/cards_icon.png',
                                        title: l10n.navCards,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const CardsScreen(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _MenuItem(
                                        imagePath:
                                            'assets/images/list_icon.png',
                                        imageScale: 1.2,
                                        title: l10n.navGangs,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const GangsScreen(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _MenuItem(
                                        imagePath:
                                            'assets/images/games_icon.png',
                                        imageScale: 1.3,
                                        title: l10n.navGames,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const GameHomeScreen(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _MenuItem(
                                        imagePath:
                                            'assets/images/book_icon.png',
                                        title: l10n.navRules,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const RulesScreen(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _MenuItem(
                                        imagePath:
                                            'assets/images/gear_icon.png',
                                        imageScale: 1.2,
                                        title: l10n.settingsTitle,
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SettingsScreen(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Drawer button stays pinned top-left, independent of the scaled content.
              Positioned(
                top: 8,
                left: 8,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: context.textColor, size: 28),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 160,
          child: Image.asset(
            'assets/images/mask.png',
            fit: BoxFit.contain,
            alignment: Alignment.center,
            color: isLight ? AppPalette.red : null,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -14),
          child: Text(
            'CARNEVALE',
            style: GoogleFonts.cinzel(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: context.textColor,
              letterSpacing: 10,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -8),
          child: SizedBox(
            width: 180,
            height: 25,
            child: Image.asset(
              'assets/images/divider.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              color: isLight ? AppPalette.red : AppPalette.mutedGold,
              colorBlendMode: BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.title,
    required this.imagePath,
    this.imageScale = 1.0,
    this.onTap,
  });

  final String title;
  final String imagePath;
  final double imageScale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Transform.scale(
                    scale: imageScale,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppPalette.red
                          : AppPalette.mutedGold,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: context.textColor,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: context.accentColor, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
