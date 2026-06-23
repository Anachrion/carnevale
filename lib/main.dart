import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CarnevaleApp());
}

class CarnevaleApp extends StatelessWidget {
  const CarnevaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnevale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0EDE6),
        textTheme: GoogleFonts.cinzelTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}
