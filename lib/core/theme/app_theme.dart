import 'package:flutter/material.dart';

class AppTheme {
  static const Color _bg = Color(0xFF0B0D12);
  static const Color _surface = Color(0xFF131720);
  static const Color _surfaceAlt = Color(0xFF191F2A);
  static const Color _accent = Color(0xFF4CC9F0);

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: _bg,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: _accent,
        surface: _surface,
      ),
      cardTheme: const CardThemeData(
        color: _surfaceAlt,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xDD0B0D12),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: _surfaceAlt,
        border: OutlineInputBorder(),
      ),
    );
  }
}
