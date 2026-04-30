import 'package:flutter/material.dart';

class AppTheme {
  static const Color _bg = Color(0xFF080A12);
  static const Color _surface = Color(0xFF121826);
  static const Color _surfaceAlt = Color(0xFF1A2333);
  static const Color _accent = Color(0xFF7C9CFF);
  static const Color _secondary = Color(0xFF35D7C3);
  static const Color _outline = Color(0xFF2A3650);

  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark(
      primary: _accent,
      secondary: _secondary,
      surface: _surface,
      error: Color(0xFFFF7B8B),
      onPrimary: Colors.white,
      onSecondary: Color(0xFF041013),
      onSurface: Color(0xFFE8EEFF),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      scaffoldBackgroundColor: _bg,
      canvasColor: _bg,
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFFD9E4FF),
        displayColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: _surfaceAlt,
        elevation: 0.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _outline),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xCC080A12),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      dividerTheme: const DividerThemeData(color: _outline),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFF1A2740),
        selectedColor: const Color(0xFF22345A),
        disabledColor: const Color(0xFF1A2740),
        side: const BorderSide(color: _outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(
          color: Color(0xFFEAF0FF),
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE3EBFF),
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: _outline),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFDCE7FF),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: _surfaceAlt,
        hintStyle: TextStyle(color: Color(0xFF96A4C2)),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _accent, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0xFFFF7B8B)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1A2333),
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFFEAF0FF),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
