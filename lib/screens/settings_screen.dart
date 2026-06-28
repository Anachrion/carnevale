import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

const _kBackground = Color(0xFFF0EDE6);
const _kDarkText = Color(0xFF2C2418);
const _kGold = Color(0xFFC4A050);
const _kCardBg = Color(0xFFF5F2EE);

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
                            child: DropdownButton<ThemeMode>(
                              value: settingsService.themeMode,
                              dropdownColor: _kCardBg,
                              style: GoogleFonts.cinzel(fontSize: 14, color: _kDarkText),
                              underline: const SizedBox.shrink(),
                              icon: const Icon(Icons.expand_more, color: _kGold, size: 20),
                              onChanged: (mode) {
                                if (mode != null) settingsService.setThemeMode(mode);
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: ThemeMode.system,
                                  child: Text('Follow System'),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.light,
                                  child: Text('Light'),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.dark,
                                  child: Text('Dark'),
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
            icon: const Icon(Icons.arrow_back, color: _kDarkText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Text(
            'Settings',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _kDarkText,
              letterSpacing: 3,
            ),
          ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: _kCardBg.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.cinzel(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _kDarkText,
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
