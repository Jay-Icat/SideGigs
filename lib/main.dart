import 'package:flutter/material.dart';
import 'theme/glass_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_gigs_screen.dart';
import 'screens/get_gigs_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const SideGigsApp());
}

class SideGigsApp extends StatelessWidget {
  const SideGigsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SideGigs - Super Glass Marketplace',
      debugShowCheckedModeBanner: false,
      theme: GlassTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/post-gigs': (context) => const PostGigsScreen(),
        '/get-gigs': (context) => const GetGigsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
