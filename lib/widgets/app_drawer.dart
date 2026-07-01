import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../main.dart';
import '../screens/account_screen.dart';
import '../screens/cards_screen.dart';
import '../screens/gangs_screen.dart';
import '../screens/settings_screen.dart';

enum AppDrawerRoute { home, cards, gangs, rules, account, settings }

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.current});

  final AppDrawerRoute current;

  void _navigate(BuildContext context, AppDrawerRoute route, Widget? screen) {
    Navigator.pop(context);
    if (route != current && screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFFB1986C) : const Color(0xFF8B1A1A);
    final borderColor = isDark
        ? const Color(0xFFB1986C).withOpacity(0.25)
        : const Color(0xFF2C2418).withOpacity(0.15);

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1A1612) : const Color(0xFFF0EDE6),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: context.textColor),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Spacer(),
                  CustomPaint(size: const Size(16, 26), painter: _DaggerPainter(accent)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 12, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Carnevale',
                          style: GoogleFonts.cinzel(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: context.textColor,
                          ),
                        ),
                        Text(
                          'COMPANION',
                          style: GoogleFonts.cinzel(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                            color: context.subtleTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: context.subtleTextColor),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NavItem(
                    label: 'Home',
                    active: current == AppDrawerRoute.home,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.home, null),
                  ),
                  _NavItem(
                    label: 'Cards',
                    active: current == AppDrawerRoute.cards,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.cards, const CardsScreen()),
                  ),
                  _NavItem(
                    label: 'Gangs',
                    active: current == AppDrawerRoute.gangs,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.gangs, const GangsScreen()),
                  ),
                  _NavItem(
                    label: 'Rules',
                    active: current == AppDrawerRoute.rules,
                    accent: accent,
                    onTap: () => Navigator.pop(context),
                  ),
                  _NavItem(
                    label: 'Account',
                    active: current == AppDrawerRoute.account,
                    accent: accent,
                    onTap: () => _navigate(context, AppDrawerRoute.account, const AccountScreen()),
                  ),
                  _NavItem(
                    label: 'Settings',
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
                isDark ? 'DARK THEME' : 'LIGHT THEME',
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
    final line = accent.withOpacity(0.5);
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

class _DaggerPainter extends CustomPainter {
  _DaggerPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final midX = size.width / 2;
    canvas.drawLine(Offset(midX, 2), Offset(midX, size.height - 4), paint);
    canvas.drawLine(
      Offset(midX - 5, size.height * 0.34),
      Offset(midX + 5, size.height * 0.34),
      paint,
    );
    canvas.drawCircle(Offset(midX, size.height - 2), 1.6, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _DaggerPainter oldDelegate) => oldDelegate.color != color;
}
