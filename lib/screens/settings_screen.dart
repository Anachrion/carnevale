import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../services/ability_service.dart';
import '../services/auth_service.dart';
import '../services/card_image_service.dart';
import '../services/equipment_service.dart';
import '../services/profile_service.dart';
import '../services/settings_service.dart';
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
                    child: _OptionPicker<ThemeMode>(
                      value: settingsService.themeMode,
                      options: const [
                        ThemeMode.system,
                        ThemeMode.light,
                        ThemeMode.dark,
                      ],
                      labelBuilder: _themeModeLabel,
                      onChanged: settingsService.setThemeMode,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingRow(
                    label: 'Card flip',
                    child: _OptionPicker<CardFlipStyle>(
                      value: settingsService.cardFlipStyle,
                      options: const [CardFlipStyle.flip, CardFlipStyle.swipe],
                      labelBuilder: _cardFlipStyleLabel,
                      onChanged: settingsService.setCardFlipStyle,
                    ),
                  ),
                  // Web streams faces straight from the backend (browser cache), so there is no
                  // local cache to sync — this section is mobile only.
                  if (!kIsWeb) ...[
                    const SizedBox(height: 28),
                    Text(
                      'CARD IMAGES',
                      style: GoogleFonts.cinzel(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: context.accentColor,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SettingRow(
                      label: 'Download',
                      child: _OptionPicker<CardDownloadMode>(
                        value: settingsService.cardDownloadMode,
                        options: const [
                          CardDownloadMode.onDemand,
                          CardDownloadMode.always,
                          CardDownloadMode.wifiOnly,
                        ],
                        labelBuilder: _cardDownloadModeLabel,
                        onChanged: settingsService.setCardDownloadMode,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _CardImageSync(),
                  ],
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

String _themeModeLabel(ThemeMode m) => switch (m) {
  ThemeMode.system => 'Follow System',
  ThemeMode.light => 'Light',
  ThemeMode.dark => 'Dark',
};

String _cardFlipStyleLabel(CardFlipStyle s) => switch (s) {
  CardFlipStyle.flip => 'Flip',
  CardFlipStyle.swipe => 'Swipe',
};

String _cardDownloadModeLabel(CardDownloadMode m) => switch (m) {
  CardDownloadMode.onDemand => 'On demand',
  CardDownloadMode.always => 'Always',
  CardDownloadMode.wifiOnly => 'Wi-Fi only',
};

/// " · ~12 MB" style suffix for a download-size hint, or "" when the manifest reported no sizes.
String _formatBytes(int bytes) {
  if (bytes <= 0) return '';
  final mb = bytes / (1024 * 1024);
  if (mb >= 1) return ' · ~${mb.toStringAsFixed(0)} MB';
  final kb = bytes / 1024;
  return ' · ~${kb.toStringAsFixed(0)} KB';
}

/// A tap-to-open dropdown that shows the current [value] and lets the user pick another
/// [options] entry, styled to match the settings surface.
class _OptionPicker<T> extends StatelessWidget {
  const _OptionPicker({
    required this.value,
    required this.options,
    required this.labelBuilder,
    required this.onChanged,
  });

  final T value;
  final List<T> options;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

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
        final result = await showMenu<T>(
          context: context,
          position: position,
          elevation: 8,
          color: isDark ? AppPalette.controlNavyDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: accentColor.withValues(alpha: 0.45),
              width: 1.0,
            ),
          ),
          items: options.map((o) {
            final selected = o == value;
            return PopupMenuItem<T>(
              value: o,
              child: Text(
                labelBuilder(o),
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
            labelBuilder(value),
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

/// Settings control that downloads missing/outdated card faces into the on-disk cache, showing
/// live progress. Mobile only (the parent hides it on web).
///
/// All progress state lives on [CardImageService.syncStatus], not here, so a sync started from this
/// screen keeps running and keeps reporting even if you navigate away and back — the button simply
/// mirrors whatever the service is doing.
class _CardImageSync extends StatefulWidget {
  const _CardImageSync();

  @override
  State<_CardImageSync> createState() => _CardImageSyncState();
}

class _CardImageSyncState extends State<_CardImageSync> {
  ValueNotifier<CardSyncStatus?> get _status => CardImageService().syncStatus;

  /// True while a sync this screen started is still running; used to toast exactly once on finish.
  bool _sawSync = false;

  /// Faces the in-flight sync had to fetch (its final total), captured while progress is live so we
  /// can tell "already up to date" (0) from "downloaded some" after it goes idle.
  int _pendingTotal = 0;

  void _start() {
    if (_status.value != null) return; // already syncing
    _sawSync = true;
    _pendingTotal = 0;
    // Re-syncing means "get me the latest": also drop the in-memory catalog caches so freshly
    // published stats and illustrations reload on the next screen open, not just the images (S-3).
    ProfileService().reset();
    AbilityService().reset();
    EquipmentService().reset();
    // Fire-and-forget: the service owns the work and publishes progress on syncStatus. `refresh`
    // re-pulls the manifest first; only missing/outdated faces download, so this resumes rather
    // than restarting an interrupted sync.
    CardImageService().sync(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Download any card images that are missing or out of date on this device.',
            style: GoogleFonts.cinzel(
              fontSize: 12,
              color: context.subtleTextColor,
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<CardSyncStatus?>(
            valueListenable: _status,
            builder: (context, status, _) {
              if (status != null) {
                _pendingTotal = status.total;
                return _SyncProgress(done: status.done, total: status.total);
              }
              // Idle. If a sync this screen started just finished, tell the user how it went —
              // distinguishing "nothing to do" from "downloaded N".
              if (_sawSync) {
                _sawSync = false;
                final total = _pendingTotal;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  showAppToast(
                    context,
                    total == 0
                        ? 'All cards are already up to date'
                        : 'Synced $total card image${total == 1 ? '' : 's'}',
                  );
                });
              }
              // Show the download cost up front so a sync on a metered connection is a choice, not
              // a surprise (S-5). Zero pending = nothing to fetch; the label just reads "Sync Cards".
              final pending = CardImageService().pendingDownload();
              final label = pending.count == 0
                  ? 'Sync Cards'
                  : 'Sync Cards (${pending.count}${_formatBytes(pending.bytes)})';
              return _AccountButton(
                icon: Icons.cloud_download_outlined,
                label: label,
                color: AppPalette.toggleBlue,
                onPressed: _start,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SyncProgress extends StatelessWidget {
  const _SyncProgress({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total > 0 ? done / total : null,
            minHeight: 6,
            backgroundColor: accent.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(accent),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          total > 0 ? 'Downloading $done / $total' : 'Checking for updates…',
          style: GoogleFonts.cinzel(
            fontSize: 12,
            color: context.subtleTextColor,
          ),
        ),
      ],
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
