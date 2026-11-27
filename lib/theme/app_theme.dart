import 'package:flutter/material.dart';

/// Palette constants for the ocean-teal / warm-coral identity.
const Color oceanTeal = Color(0xFF0F766E);
const Color oceanTealContainer = Color(0xFFCCFBF1);
const Color warmCoral = Color(0xFFF97362);
const Color darkBackground = Color(0xFF0B1416);
const Color darkSurface = Color(0xFF142024);

class AppTheme {
  const AppTheme._();

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: oceanTeal,
      brightness: brightness,
      secondary: warmCoral,
    ).copyWith(
      primary: isDark ? oceanTealContainer : oceanTeal,
      secondary: warmCoral,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? darkBackground : const Color(0xFFF7FAF9),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? darkSurface : oceanTeal,
        foregroundColor: isDark ? oceanTealContainer : Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(64, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withValues(alpha: 0.6),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
