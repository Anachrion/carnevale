import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_toast.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import 'account_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loggingOut = false;
  bool _sendingReset = false;

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

  Future<void> _logOut() async {
    setState(() => _loggingOut = true);
    await authService.logOut();
    if (!mounted) return;
    setState(() => _loggingOut = false);
    showAppToast(context, 'Logged out');
  }

  Future<void> _sendResetEmail(String email) async {
    setState(() => _sendingReset = true);
    try {
      await authService.forgotPassword(email);
      if (mounted) showAppToast(context, 'Password reset email sent!');
    } on AuthException catch (e) {
      if (mounted) showAppToast(context, e.message);
    } finally {
      if (mounted) setState(() => _sendingReset = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.settings),
      body: AppBackground(
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
                      color: context.accentColor,
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
                  const SizedBox(height: 28),
                  Text(
                    'ACCOUNT',
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.accentColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: authService,
                    builder: (context, _) {
                      final user = authService.currentUser;
                      if (user == null) {
                        return _SettingRow(
                          label: 'Not logged in',
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AccountScreen(),
                              ),
                            ),
                            child: Text(
                              'Log In',
                              style: GoogleFonts.cinzel(
                                color: context.accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }
                      final logoutColor = context.accentColor;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SettingRow(
                            label: 'Signed in as',
                            child: Text(
                              user.email,
                              style: GoogleFonts.cinzel(
                                color: context.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _UsernameEditor(
                            key: ValueKey(user.username),
                            initialUsername: user.username,
                          ),
                          const SizedBox(height: 12),
                          _AccountButton(
                            icon: Icons.vpn_key_outlined,
                            label: 'Reset Password',
                            color: AppPalette.toggleBlue,
                            onPressed: _sendingReset
                                ? null
                                : () => _sendResetEmail(user.email),
                            loading: _sendingReset,
                          ),
                          const SizedBox(height: 12),
                          _AccountButton(
                            icon: Icons.logout,
                            label: 'Log Out',
                            color: logoutColor,
                            tintColor: AppPalette.red,
                            onPressed: _loggingOut ? null : _logOut,
                            loading: _loggingOut,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ScreenHeader(
      title: 'Settings',
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
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
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = context.accentColor;

    return GestureDetector(
      onTap: () async {
        final box = context.findRenderObject() as RenderBox;
        final overlay =
            Navigator.of(context).overlay!.context.findRenderObject()
                as RenderBox;
        final position = RelativeRect.fromRect(
          Rect.fromPoints(
            box.localToGlobal(Offset.zero, ancestor: overlay),
            box.localToGlobal(
              box.size.bottomRight(Offset.zero),
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        );
        final result = await showMenu<ThemeMode>(
          context: context,
          position: position,
          elevation: 8,
          color: isDark ? AppPalette.controlNavyDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: accentColor.withValues(alpha: 0.45), width: 1.0),
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
    return GlassPanel(
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
    );
  }
}

class _AccountButton extends StatelessWidget {
  const _AccountButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.tintColor,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color? tintColor;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = tintColor ?? color;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          tint.withValues(alpha: 0.10),
                          tint.withValues(alpha: 0.30),
                        ]
                      : [
                          tint.withValues(alpha: 0.06),
                          tint.withValues(alpha: 0.16),
                        ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.6),
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: loading
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: color,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: GoogleFonts.cinzel(
                            color: color,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameEditor extends StatefulWidget {
  const _UsernameEditor({super.key, required this.initialUsername});

  final String initialUsername;

  @override
  State<_UsernameEditor> createState() => _UsernameEditorState();
}

class _UsernameEditorState extends State<_UsernameEditor> {
  late final _controller = TextEditingController(text: widget.initialUsername);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _changed {
    final trimmed = _controller.text.trim();
    return trimmed.isNotEmpty && trimmed != widget.initialUsername;
  }

  Future<void> _save() async {
    if (!_changed) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await authService.updateUsername(_controller.text.trim());
      if (mounted) showAppToast(context, 'Username updated!');
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingRow(
          label: 'Username',
          child: SizedBox(
            width: 170,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _save(),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cinzel(
                      color: context.textColor,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _saving
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.accentColor,
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.check,
                          size: 20,
                          color: _changed
                              ? context.accentColor
                              : context.subtleTextColor.withValues(alpha: 0.3),
                        ),
                        onPressed: _changed ? _save : null,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
              ],
            ),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              _error!,
              style: TextStyle(color: context.dangerColor, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
