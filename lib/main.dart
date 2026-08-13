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

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/scan_target.dart';
import 'screens/game_home_screen.dart';
import 'screens/gangs_screen.dart';
import 'screens/home_screen.dart';
import 'screens/reset_password_screen.dart';
import 'services/auth_service.dart';
import 'services/card_image_service.dart';
import 'services/settings_service.dart';

final settingsService = SettingsService();
final authService = AuthService();
final navigatorKey = GlobalKey<NavigatorState>();

/// Lets a screen know when a route pushed above it is popped and it becomes visible again — used by
/// GameSessionScreen to re-establish its live watch after another game is opened over it (A-5).
final routeObserver = RouteObserver<PageRoute<dynamic>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settingsService.load();
  await authService.load();
  // Card images load off the critical path: init() fetches the manifest over the network, so
  // awaiting it here would let a captive-portal / black-hole network hang on the splash screen
  // before the first frame. Kick init() -> maybeAutoSync() off unawaited instead. maybeAutoSync
  // bulk-downloads only when the user's download-mode setting allows it (default: on demand, i.e.
  // not here — faces then cache lazily as they're viewed). No-op on web.
  unawaited(
    CardImageService().init().then((_) => CardImageService().maybeAutoSync()),
  );
  runApp(const CarnevaleApp());
}

class CarnevaleApp extends StatefulWidget {
  const CarnevaleApp({super.key});

  @override
  State<CarnevaleApp> createState() => _CarnevaleAppState();
}

/// Opens whatever a link or a scan turned out to point at.
///
/// Shared by both doors so a destination behaves identically however it was reached. Navigation
/// goes through [navigatorKey] rather than a passed context: a deep link arrives with no context at
/// all, and the QR scanner's own context is about to be popped along with its screen.
void openScanTarget(ScanTarget target) {
  final navigator = navigatorKey.currentState;
  if (navigator == null) return;
  switch (target) {
    case ResetPasswordTarget(:final token):
      navigator.push(
        MaterialPageRoute(builder: (_) => ResetPasswordScreen(token: token)),
      );
    case JoinGameTarget(:final code):
      navigator.push(
        MaterialPageRoute(builder: (_) => GameHomeScreen(initialJoinCode: code)),
      );
    case NewGameTarget(:final setup):
      navigator.push(
        MaterialPageRoute(builder: (_) => GameHomeScreen(initialSetup: setup)),
      );
    case GangTextTarget(:final text):
      // A sheet, not a screen: the import flow already exists as one, and pushing the gangs list
      // underneath first means backing out of the sheet lands somewhere sensible rather than on
      // whatever the scanner happened to cover.
      navigator.push(
        MaterialPageRoute(
          builder: (_) => GangsScreen(initialImportText: text),
        ),
      );
  }
}

class _CarnevaleAppState extends State<CarnevaleApp> {
  final _appLinks = AppLinks();
  Uri? _lastHandledLink;
  DateTime? _lastHandledAt;

  @override
  void initState() {
    super.initState();
    settingsService.addListener(_onSettingsChanged);
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // app_links' web implementation can throw here (observed in release web builds);
    // deep link detection is a nice-to-have, not something that should crash startup.
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) _handleDeepLink(initialLink);
      _appLinks.uriLinkStream.listen(_handleDeepLink);
    } catch (e) {
      debugPrint('Deep link initialization failed: $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    // Dedup only a rapid duplicate of the same link (app_links can deliver one twice); a deliberate
    // re-tap of the same link later must still work, so this is a short time window, not forever (A-5).
    final now = DateTime.now();
    if (uri == _lastHandledLink &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!) < const Duration(seconds: 2)) {
      return;
    }
    // An unrecognised link (including a bare /new-game carrying no settings) is left alone rather
    // than opening an empty screen — same as any URL the app was never meant to handle.
    final target = targetForUri(uri);
    if (target == null) return;
    _lastHandledLink = uri;
    _lastHandledAt = now;
    openScanTarget(target);
  }

  @override
  void dispose() {
    settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      title: 'Carnevale',
      debugShowCheckedModeBanner: false,
      // null locale = follow the device (resolved against supportedLocales); a pinned value from
      // settings overrides it. Rebuilds via _onSettingsChanged when the user switches language.
      locale: settingsService.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: settingsService.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppPalette.background,
        textTheme: GoogleFonts.cinzelTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppPalette.backgroundDark,
        textTheme: GoogleFonts.cinzelTextTheme(ThemeData.dark().textTheme),
      ),
      home: const HomeScreen(),
    );
  }
}
