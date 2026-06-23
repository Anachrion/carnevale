import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kBackground = Color(0xFFF0EDE6);
const _kCardBackground = Color(0xFFF5F2EE);
const _kRed = Color(0xFF8B1A1A);
const _kGold = Color(0xFFC4A050);
const _kDarkText = Color(0xFF2C2418);
const _kSubtleText = Color(0xFF7A6E62);
const _kNewsCard = Color(0xFF5A6B78);
const _kCircle = Color(0xFFE5E1DA);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_light.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _Header(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.style_outlined,
                        title: 'Cards',
                        subtitle: 'Browse all cards\nand profiles.',
                      ),
                      const SizedBox(height: 12),
                      _MenuItem(
                        icon: Icons.flag_outlined,
                        title: 'Gangs',
                        subtitle: 'Create, save and\nmanage your lists.',
                      ),
                      const SizedBox(height: 12),
                      _MenuItem(
                        icon: Icons.menu_book_outlined,
                        title: 'Rules',
                        subtitle: 'Learn the game\nand find answers.',
                      ),
                      const SizedBox(height: 12),
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'Settings, preferences\nand more.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/mask.png', height: 160),
              const SizedBox(height: 10),
              Text(
                'CARNEVALE',
                style: GoogleFonts.cinzel(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: _kDarkText,
                  letterSpacing: 5,
                ),
              ),
              const SizedBox(height: 12),
              _GoldDivider(),
            ],
          ),
        ),
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
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: _kCardBackground.withOpacity(0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(color: _kCircle, shape: BoxShape.circle),
                  child: Icon(icon, color: _kDarkText, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.cinzel(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _kDarkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 13,
                          color: _kSubtleText,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: _kGold, size: 22),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
