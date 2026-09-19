import 'package:flutter/material.dart';

class GlassTheme {
  // Background & Core Colors
  static const Color background = Color(0xFF070A12);
  static const Color backgroundSecondary = Color(0xFF0D1424);
  
  // Vibrant Neon Glow Accents
  static const Color cyanAccent = Color(0xFF00F0FF);
  static const Color violetAccent = Color(0xFF8B5CF6);
  static const Color pinkAccent = Color(0xFFFF2E93);
  static const Color emeraldAccent = Color(0xFF10B981);
  static const Color amberAccent = Color(0xFFF59E0B);
  
  // Opacity helper compatible with Flutter 3.47+ without deprecation warnings
  static Color op(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }

  // Glass Surface Defaults
  static Color get glassWhite => op(Colors.white, 0.08);
  static Color get glassBorder => op(Colors.white, 0.16);
  static Color get glassHighlight => op(Colors.white, 0.28);
  static Color get glassDark => op(Colors.black, 0.30);

  static const double blurSigma = 18.0;
  static const double defaultRadius = 24.0;

  // Dual-stop realistic specular reflection gradient for glass containers
  static LinearGradient glassGradient({
    double alpha1 = 0.14,
    double alpha2 = 0.04,
  }) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        op(Colors.white, alpha1),
        op(Colors.white, alpha2),
      ],
    );
  }

  // Border gradient with brighter specular light on top-left
  static LinearGradient glassBorderGradient({
    double topAlpha = 0.32,
    double bottomAlpha = 0.08,
  }) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        op(Colors.white, topAlpha),
        op(Colors.white, bottomAlpha),
      ],
    );
  }

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00F0FF),
      Color(0xFF7C3AED),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B5CF6),
      Color(0xFFFF2E93),
    ],
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF00F0FF),
    ],
  );

  // Box Shadows with silky smooth diffusion
  static List<BoxShadow> glassShadow({Color? glowColor}) {
    return [
      BoxShadow(
        color: op(Colors.black, 0.40),
        blurRadius: 28,
        offset: const Offset(0, 12),
      ),
      if (glowColor != null)
        BoxShadow(
          color: op(glowColor, 0.28),
          blurRadius: 36,
          spreadRadius: -4,
          offset: const Offset(0, 4),
        ),
    ];
  }

  // ThemeData configuration
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: cyanAccent,
        secondary: violetAccent,
        surface: Color(0xFF111827),
        error: Color(0xFFEF4444),
      ),
      fontFamily: 'Segoe UI',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFFE2E8F0),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
