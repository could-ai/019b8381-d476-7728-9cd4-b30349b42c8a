import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/player_screen.dart';

void main() {
  runApp(const AFStreamingApp());
}

class AFStreamingApp extends StatelessWidget {
  const AFStreamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AF Streaming',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.dark),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/player': (context) => const PlayerScreen(),
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    var baseTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE50914), // Netflix Red-ish
        brightness: brightness,
        surface: const Color(0xFF121212),
      ),
      scaffoldBackgroundColor: const Color(0xFF000000),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
