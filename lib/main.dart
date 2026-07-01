import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/settings_service.dart';

final settingsService = SettingsService();
final authService = AuthService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settingsService.load();
  await authService.load();
  runApp(const CarnevaleApp());
}

class CarnevaleApp extends StatefulWidget {
  const CarnevaleApp({super.key});

  @override
  State<CarnevaleApp> createState() => _CarnevaleAppState();
}

class _CarnevaleAppState extends State<CarnevaleApp> {
  @override
  void initState() {
    super.initState();
    settingsService.addListener(_onSettingsChanged);
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
      title: 'Carnevale',
      debugShowCheckedModeBanner: false,
      themeMode: settingsService.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0EDE6),
        textTheme: GoogleFonts.cinzelTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1612),
        textTheme: GoogleFonts.cinzelTextTheme(ThemeData.dark().textTheme),
      ),
      home: const HomeScreen(),
    );
  }
}
