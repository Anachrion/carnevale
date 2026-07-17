// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/game_home_screen.dart';
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
    if (uri.path == '/reset-password') {
      final token = uri.queryParameters['reset_password_token'];
      if (token == null || token.isEmpty) return;
      _lastHandledLink = uri;
      _lastHandledAt = now;
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ResetPasswordScreen(token: token)),
      );
      return;
    }
    if (uri.path == '/join') {
      final code = uri.queryParameters['code'];
      if (code == null || code.isEmpty) return;
      _lastHandledLink = uri;
      _lastHandledAt = now;
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => GameHomeScreen(initialJoinCode: code)),
      );
      return;
    }
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
