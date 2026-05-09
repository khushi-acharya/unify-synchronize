import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/profile_page.dart';
import 'utils/theme_notifier.dart';

void main() {
  runApp(const SynchroniseApp());
}

class SynchroniseApp extends StatefulWidget {
  const SynchroniseApp({super.key});

  @override
  State<SynchroniseApp> createState() => _SynchroniseAppState();
}

class _SynchroniseAppState extends State<SynchroniseApp> {
  @override
  void initState() {
    super.initState();
    // Rebuild the whole app whenever the theme mode changes
    ThemeNotifier.instance.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    ThemeNotifier.instance.removeListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synchronise',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeNotifier.instance.value,

      // ── Dark theme (original) ───────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1ECFB3),
          secondary: Color(0xFF1ECFB3),
          surface: Color(0xFF181C27),
          background: Color(0xFF0F1117),
        ),
        fontFamily: 'sans-serif',
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFFB0B8CC)),
          bodyMedium: TextStyle(color: Color(0xFF8892A4)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1117),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // ── Light theme ─────────────────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0EA58C),
          secondary: Color(0xFF0EA58C),
          surface: Color(0xFFFFFFFF),
          background: Color(0xFFF4F6FA),
        ),
        fontFamily: 'sans-serif',
        textTheme: const TextTheme(
          displayLarge:
              TextStyle(color: Color(0xFF0F1117), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF3A4155)),
          bodyMedium: TextStyle(color: Color(0xFF5C6478)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F6FA),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0F1117)),
          titleTextStyle: TextStyle(
              color: Color(0xFF0F1117),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),

      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/explore': (context) => const ExplorePage(),
        '/dashboard': (context) => const DashboardPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
