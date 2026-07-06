import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/glass_panel.dart';
import 'cards_screen.dart';
import 'game_home_screen.dart';
import 'gangs_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.home),
      body: AppBackground(
        blurScrim: false,
        safeArea: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(),
              Padding(
                padding: const EdgeInsets.fromLTRB(72, 80, 72, 32),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.style_outlined,
                      imagePath: 'assets/images/cards_icon.png',
                      title: 'Cards',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CardsScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _MenuItem(
                      icon: Icons.flag_outlined,
                      imagePath: 'assets/images/list_icon.png',
                      imageScale: 1.2,
                      title: 'Gangs',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GangsScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _MenuItem(
                      icon: Icons.sports_esports_outlined,
                      imagePath: 'assets/images/games_icon.png',
                      imageScale: 1.10,
                      title: 'Games',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameHomeScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _MenuItem(
                      icon: Icons.menu_book_outlined,
                      imagePath: 'assets/images/book_icon.png',
                      title: 'Rules',
                    ),
                    const SizedBox(height: 12),
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      imagePath: 'assets/images/gear_icon.png',
                      imageScale: 1.2,
                      title: 'Settings',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                    ),
                  ],
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
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 64, 0, 32),
              child: Column(
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
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              icon: Icon(Icons.menu, color: context.textColor, size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    this.imagePath,
    this.imageScale = 1.0,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? imagePath;
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
                  child: imagePath != null
                      ? Transform.scale(
                          scale: imageScale,
                          child: Image.asset(
                            imagePath!,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? AppPalette.red
                                : AppPalette.mutedGold,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        )
                      : Icon(icon, color: context.textColor, size: 26),
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
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppPalette.gold
                      : AppPalette.red,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
