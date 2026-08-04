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

import '../app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/ability_service.dart';
import '../services/api_client.dart';
import '../services/card_image_service.dart';
import '../services/equipment_service.dart';
import '../services/profile_service.dart';
import '../services/settings_service.dart';
import '../services/spell_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_toast.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import '../widgets/settings_controls.dart';
import 'account_screen.dart';
import 'account_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final l10n = AppLocalizations.of(context);
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
                    l10n.settingsAppearance,
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.accentColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SettingRow(
                    label: l10n.settingsLanguage,
                    child: _OptionPicker<Locale?>(
                      value: settingsService.locale,
                      // null = follow the device; the two supported languages after it.
                      options: const [null, Locale('en'), Locale('fr')],
                      labelBuilder: (loc) => _localeLabel(l10n, loc),
                      onChanged: settingsService.setLocale,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SettingRow(
                    label: l10n.settingsThemeMode,
                    child: _OptionPicker<ThemeMode>(
                      value: settingsService.themeMode,
                      options: const [
                        ThemeMode.system,
                        ThemeMode.light,
                        ThemeMode.dark,
                      ],
                      labelBuilder: (m) => _themeModeLabel(l10n, m),
                      onChanged: settingsService.setThemeMode,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SettingRow(
                    label: l10n.settingsCardFlip,
                    child: _OptionPicker<CardFlipStyle>(
                      value: settingsService.cardFlipStyle,
                      options: const [CardFlipStyle.flip, CardFlipStyle.swipe],
                      labelBuilder: (s) => _cardFlipStyleLabel(l10n, s),
                      onChanged: settingsService.setCardFlipStyle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SettingRow(
                    label: l10n.settingsBothFaces,
                    child: _OptionPicker<bool>(
                      value: settingsService.bothFacesLandscape,
                      options: const [true, false],
                      labelBuilder: (v) =>
                          v ? l10n.settingsOn : l10n.settingsOff,
                      onChanged: settingsService.setBothFacesLandscape,
                    ),
                  ),
                  // Web streams faces straight from the backend (browser cache), so there is no
                  // local cache to sync — this section is mobile only.
                  if (!kIsWeb) ...[
                    const SizedBox(height: 28),
                    Text(
                      l10n.settingsCardImages,
                      style: GoogleFonts.cinzel(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: context.accentColor,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SettingRow(
                      label: l10n.settingsDownload,
                      child: _OptionPicker<CardDownloadMode>(
                        value: settingsService.cardDownloadMode,
                        options: const [
                          CardDownloadMode.onDemand,
                          CardDownloadMode.always,
                          CardDownloadMode.wifiOnly,
                        ],
                        labelBuilder: (m) => _cardDownloadModeLabel(l10n, m),
                        onChanged: settingsService.setCardDownloadMode,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _CardImageSync(),
                  ],
                  const SizedBox(height: 28),
                  Text(
                    l10n.settingsPrinting,
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.accentColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _PrintableSheets(),
                  const SizedBox(height: 28),
                  Text(
                    l10n.settingsAccount,
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
                        return SettingRow(
                          label: l10n.settingsNotLoggedIn,
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AccountScreen(),
                              ),
                            ),
                            child: Text(
                              l10n.actionLogIn,
                              style: GoogleFonts.cinzel(
                                color: context.accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }
                      // Signed in: username editing, password reset and log out now live on their
                      // own page. This row is the entry point — it shows who you are and pushes
                      // AccountSettingsScreen on tap.
                      return _AccountNavRow(
                        username: user.username,
                        email: user.email,
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.settingsAbout,
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.accentColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GlassActionButton(
                    icon: Icons.info_outline,
                    label: l10n.settingsAboutButton,
                    color: AppPalette.toggleBlue,
                    onPressed: _showAbout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens the custom, glass-styled About dialog (see [_AboutDialog]). We fetch the version here so
  /// the dialog itself can stay a plain, synchronous widget.
  ///
  /// The version is best-effort: package_info_plus is a plugin, and a platform that fails to answer
  /// (a web build whose plugin registrant went stale, say) used to throw straight out of the button
  /// handler, so the dialog never opened at all. Losing the version line is a far better failure
  /// than losing the credits, licences and legal links the dialog exists to show.
  Future<void> _showAbout() async {
    String? version;
    try {
      final info = await PackageInfo.fromPlatform();
      version = '${info.version} (${info.buildNumber})';
    } catch (_) {
      version = null;
    }
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => _AboutDialog(version: version),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ScreenHeader(
      title: AppLocalizations.of(context).settingsTitle,
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
    );
  }
}

// Label helpers now take the localizations object rather than reading hardcoded English. Language
// names are shown as endonyms (each in its own language), which is the convention and needs no ARB
// key; only the "system default" option is translated.
String _localeLabel(AppLocalizations l10n, Locale? locale) => switch (locale?.languageCode) {
  'en' => 'English',
  'fr' => 'Français',
  _ => l10n.settingsLanguageSystem,
};

String _themeModeLabel(AppLocalizations l10n, ThemeMode m) => switch (m) {
  ThemeMode.system => l10n.settingsThemeSystem,
  ThemeMode.light => l10n.settingsThemeLight,
  ThemeMode.dark => l10n.settingsThemeDark,
};

String _cardFlipStyleLabel(AppLocalizations l10n, CardFlipStyle s) => switch (s) {
  CardFlipStyle.flip => l10n.settingsCardFlipFlip,
  CardFlipStyle.swipe => l10n.settingsCardFlipSwipe,
};

String _cardDownloadModeLabel(AppLocalizations l10n, CardDownloadMode m) => switch (m) {
  CardDownloadMode.onDemand => l10n.settingsDownloadOnDemand,
  CardDownloadMode.always => l10n.settingsDownloadAlways,
  CardDownloadMode.wifiOnly => l10n.settingsDownloadWifiOnly,
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

/// The custom, glass-styled "About" popup that replaces Flutter's stock [showAboutDialog]. Renders
/// the app identity, credits, source links and trademark legalese on a frosted panel matching the
/// rest of the app, while a "View licenses" action still opens the framework's auto-generated
/// [LicensePage] so open-source attribution stays maintenance-free.
class _AboutDialog extends StatelessWidget {
  const _AboutDialog({required this.version});

  /// Null when the platform could not report it; the version line is then simply omitted.
  final String? version;

  void _openLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Carnevale',
      applicationVersion: version,
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset('assets/images/mask.png', width: 48, height: 48),
      ),
      applicationLegalese: AppLocalizations.of(context).aboutLegalese,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final accent = context.accentColor;
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        child: GlassPanel(
          opaque: true,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/mask.png',
                    width: 64,
                    height: 64,
                    // Match the app's mask treatment: deep red in light theme, native gold in dark.
                    color: isLight ? AppPalette.red : null,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Carnevale',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                    letterSpacing: 4,
                  ),
                ),
                if (version != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    version!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ebGaramond(
                      fontSize: 13,
                      color: context.subtleTextColor,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                // Reuse the home screen's ornamental divider, tinted the same accent per theme.
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 22,
                    child: Image.asset(
                      'assets/images/divider.png',
                      fit: BoxFit.cover,
                      color: isLight ? AppPalette.red : AppPalette.mutedGold,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.aboutDescription,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 15,
                    color: context.textColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.aboutCredits,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.aboutLegalese,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 13,
                    color: context.subtleTextColor,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.aboutSourceHeading,
                  style: GoogleFonts.cinzel(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accent,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                _SourceLink(
                  label: l10n.aboutSourceApp,
                  url: 'https://github.com/Anachrion/carnevale',
                ),
                _SourceLink(
                  label: l10n.aboutSourceServer,
                  url: 'https://github.com/Anachrion/carnevale-backend',
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.aboutLegalHeading,
                  style: GoogleFonts.cinzel(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accent,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                _SourceLink(
                  label: l10n.aboutPrivacyPolicy,
                  url: 'https://carnevale-app.com/privacy',
                ),
                _SourceLink(
                  label: l10n.aboutAccountDeletion,
                  url: 'https://carnevale-app.com/account-deletion',
                ),
                const SizedBox(height: 22),
                GlassActionButton(
                  icon: Icons.description_outlined,
                  label: l10n.aboutViewLicenses,
                  color: AppPalette.toggleBlue,
                  onPressed: () => _openLicenses(context),
                ),
                const SizedBox(height: 6),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.actionClose,
                      style: GoogleFonts.cinzel(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
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

/// A tappable "open in browser" row used in the About dialog to link out to the source repos.
class _SourceLink extends StatelessWidget {
  const _SourceLink({required this.label, required this.url});

  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentColor;
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(Icons.open_in_new, size: 15, color: accent),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.cinzel(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: accent,
                decoration: TextDecoration.underline,
                decorationColor: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The signed-in entry point in the Settings ACCOUNT section: a tappable glass row showing the
/// current username and email that pushes [AccountSettingsScreen] where the account is managed.
class _AccountNavRow extends StatelessWidget {
  const _AccountNavRow({required this.username, required this.email});

  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cinzel(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: context.subtleTextColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: context.accentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Settings entry for the printable card sheets: a blurb plus a button opening the backend's
/// `/cards` page in the browser, where the newest per-faction PDF can be downloaded.
///
/// Deliberately a link out rather than an in-app download — the sheets are print-shop A4/Letter
/// PDFs, so the browser (and the OS print dialog behind it) is where they are actually useful, and
/// it saves the app a file-picker/share flow it needs nowhere else.
class _PrintableSheets extends StatelessWidget {
  const _PrintableSheets();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsPrintBlurb,
            style: GoogleFonts.cinzel(
              fontSize: 12,
              color: context.subtleTextColor,
            ),
          ),
          const SizedBox(height: 12),
          GlassActionButton(
            icon: Icons.picture_as_pdf_outlined,
            label: l10n.settingsPrintButton,
            color: AppPalette.toggleBlue,
            onPressed: () => launchUrl(
              Uri.parse('${ApiClient.origin}/cards'),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
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
    SpellService().reset();
    // Fire-and-forget: the service owns the work and publishes progress on syncStatus. `refresh`
    // re-pulls the manifest first; only missing/outdated faces download, so this resumes rather
    // than restarting an interrupted sync.
    CardImageService().sync(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsSyncBlurb,
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
                        ? l10n.settingsSyncUpToDate
                        : l10n.settingsSyncedCount(total),
                  );
                });
              }
              // Show the download cost up front so a sync on a metered connection is a choice, not
              // a surprise (S-5). Zero pending = nothing to fetch; the label just reads "Sync Cards".
              final pending = CardImageService().pendingDownload();
              final label = pending.count == 0
                  ? l10n.settingsSyncCards
                  : l10n.settingsSyncCardsWithCount(
                      '${pending.count}${_formatBytes(pending.bytes)}');
              return GlassActionButton(
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
    final l10n = AppLocalizations.of(context);
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
          total > 0 ? l10n.settingsSyncDownloading(done, total) : l10n.settingsSyncChecking,
          style: GoogleFonts.cinzel(
            fontSize: 12,
            color: context.subtleTextColor,
          ),
        ),
      ],
    );
  }
}

