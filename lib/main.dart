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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settingsService.load();
  await authService.load();
  // Card images load off the critical path: init() fetches the manifest over the network, so
  // awaiting it here would let a captive-portal / black-hole network hang on the splash screen
  // before the first frame. Kick init() -> sync() off unawaited instead; faces stream in once
  // their local copy lands, and provider() falls back to network URLs until then. No-op on web.
  unawaited(CardImageService().init().then((_) => CardImageService().sync()));
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
    if (uri == _lastHandledLink) return;
    if (uri.path == '/reset-password') {
      final token = uri.queryParameters['reset_password_token'];
      if (token == null || token.isEmpty) return;
      _lastHandledLink = uri;
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ResetPasswordScreen(token: token)),
      );
      return;
    }
    if (uri.path == '/join') {
      final code = uri.queryParameters['code'];
      if (code == null || code.isEmpty) return;
      _lastHandledLink = uri;
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
