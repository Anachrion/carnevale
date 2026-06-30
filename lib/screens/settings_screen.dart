import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

const _kBackground = Color(0xFFF0EDE6);
const _kGold = Color(0xFFC4A050);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    settingsService.addListener(_rebuild);
  }

  @override
  void dispose() {
    settingsService.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
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
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(color: Colors.black.withValues(alpha: 0.05)),
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                        children: [
                          Text(
                            'APPEARANCE',
                            style: GoogleFonts.cinzel(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _kGold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _SettingRow(
                            label: 'Theme',
                            child: _ThemePicker(
                              value: settingsService.themeMode,
                              onChanged: (mode) => settingsService.setThemeMode(mode),
                            ),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: context.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Text(
            'Settings',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: context.textColor,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({required this.value, required this.onChanged});
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  static const _options = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];

  String _label(ThemeMode m) => switch (m) {
    ThemeMode.system => 'Follow System',
    ThemeMode.light  => 'Light',
    ThemeMode.dark   => 'Dark',
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? const Color(0xFFB1986C) : const Color(0xFF8B1A1A);

    return GestureDetector(
      onTap: () async {
        final box = context.findRenderObject() as RenderBox;
        final overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
        final position = RelativeRect.fromRect(
          Rect.fromPoints(
            box.localToGlobal(Offset.zero, ancestor: overlay),
            box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );
        final result = await showMenu<ThemeMode>(
          context: context,
          position: position,
          elevation: 8,
          color: isDark ? const Color(0xFF0E1828) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: accentColor.withOpacity(0.45), width: 1.0),
          ),
          items: _options.map((m) {
            final selected = m == value;
            return PopupMenuItem<ThemeMode>(
              value: m,
              child: Text(
                _label(m),
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  color: selected ? accentColor : context.textColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        );
        if (result != null) onChanged(result);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _label(value),
            style: GoogleFonts.cinzel(fontSize: 14, color: context.textColor),
          ),
          const SizedBox(width: 4),
          Icon(Icons.expand_more, color: accentColor, size: 20),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x10000000), Color(0x88000000)],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFF5F2EE).withValues(alpha: 0.30),
                      const Color(0xFFF5F2EE).withValues(alpha: 0.75),
                    ],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? const Color(0xFFB1986C).withValues(alpha: 0.45)
                  : Colors.white.withValues(alpha: 0.3),
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.cinzel(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: context.textColor,
                ),
              ),
              const Spacer(),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
