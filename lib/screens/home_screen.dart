import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_drawer.dart';
import 'cards_screen.dart';
import 'game_home_screen.dart';
import 'gangs_screen.dart';
import 'settings_screen.dart';

const _kBackground = Color(0xFFF0EDE6);
const _kCardBackground = Color(0xFFF5F2EE);
const _kRed = Color(0xFF8B1A1A);
const _kGold = Color(0xFFC4A050);
const _kNewsCard = Color(0xFF5A6B78);
const _kCircle = Color(0xFFE5E1DA);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      drawer: const AppDrawer(current: AppDrawerRoute.home),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/bg_dark.png'
                    : 'assets/images/bg_light.png',
              ),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
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
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CardsScreen())),
                          ),
                          const SizedBox(height: 12),
                          _MenuItem(
                            icon: Icons.flag_outlined,
                            imagePath: 'assets/images/list_icon.png',
                            title: 'Gangs',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GangsScreen())),
                          ),
                          const SizedBox(height: 12),
                          _MenuItem(
                            icon: Icons.sports_esports_outlined,
                            title: 'Game',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameHomeScreen())),
                          ),
                          const SizedBox(height: 12),
                          _MenuItem(icon: Icons.menu_book_outlined, imagePath: 'assets/images/book_icon.png', title: 'Rules'),
                          const SizedBox(height: 12),
                          _MenuItem(
                            icon: Icons.settings_outlined,
                            imagePath: 'assets/images/gear_icon.png',
                            title: 'Settings',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                          ),
                        ],
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
                      color: isLight ? _kRed : null,
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
                      color: isLight ? _kRed : const Color(0xFFB1986C),
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

class _GoldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 64, height: 1, color: _kGold),
        const SizedBox(width: 8),
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(color: _kGold, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Container(width: 64, height: 1, color: _kGold),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    this.imagePath,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.dark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x10000000), Color(0x88000000)],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_kCardBackground.withOpacity(0.30), _kCardBackground.withOpacity(0.75)],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFB1986C).withOpacity(0.45)
                  : Colors.white.withOpacity(0.3),
              width: 1.0,
            ),
          ),
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
                      ? Image.asset(
                          imagePath!,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          color: Theme.of(context).brightness == Brightness.light
                              ? _kRed
                              : const Color(0xFFB1986C),
                          colorBlendMode: BlendMode.srcIn,
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
                  color: Theme.of(context).brightness == Brightness.dark ? _kGold : _kRed,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kNewsCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.campaign_outlined, color: Colors.white70, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'News & Updates',
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Stay informed about the\nlatest Carnevale news.',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.white60, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
