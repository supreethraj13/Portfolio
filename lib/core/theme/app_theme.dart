import 'package:flutter/material.dart';

class AppTheme {
  static const Color _darkBg = Color(0xFF080A12);
  static const Color _darkSurface = Color(0xFF121826);
  static const Color _darkSurfaceAlt = Color(0xFF1A2333);
  static const Color _darkOutline = Color(0xFF2A3650);
  static const Color _lightBg = Color(0xFFF4F7FF);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightSurfaceAlt = Color(0xFFEAF0FF);
  static const Color _lightOutline = Color(0xFFD0DBF3);
  static const Color _accent = Color(0xFF7C9CFF);
  static const Color _secondary = Color(0xFF35D7C3);

  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark(
      primary: _accent,
      secondary: _secondary,
      surface: _darkSurface,
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
      scaffoldBackgroundColor: _darkBg,
      canvasColor: _darkBg,
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFFD9E4FF),
        displayColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: _darkSurfaceAlt,
        elevation: 0.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _darkOutline),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xCC0B1120),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      dividerTheme: const DividerThemeData(color: _darkOutline),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFF1A2740),
        selectedColor: const Color(0xFF22345A),
        disabledColor: const Color(0xFF1A2740),
        side: const BorderSide(color: _darkOutline),
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
          side: const BorderSide(color: _darkOutline),
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
        fillColor: _darkSurfaceAlt,
        hintStyle: TextStyle(color: Color(0xFF96A4C2)),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _darkOutline),
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

  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      primary: _accent,
      secondary: _secondary,
      surface: _lightSurface,
      error: Color(0xFFC62828),
      onPrimary: Colors.white,
      onSecondary: Color(0xFF002A24),
      onSurface: Color(0xFF101422),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
    );

    return base.copyWith(
      scaffoldBackgroundColor: _lightBg,
      canvasColor: _lightBg,
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF202A3E),
        displayColor: const Color(0xFF111725),
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 0.3,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _lightOutline),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xEFFFFFFF),
        foregroundColor: Color(0xFF101422),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      dividerTheme: const DividerThemeData(color: _lightOutline),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: _lightSurfaceAlt,
        selectedColor: const Color(0xFFDCE7FF),
        disabledColor: _lightSurfaceAlt,
        side: const BorderSide(color: _lightOutline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(
          color: Color(0xFF1B2740),
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
          foregroundColor: const Color(0xFF1B2A45),
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: _lightOutline),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF263A62),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        hintStyle: TextStyle(color: Color(0xFF6E7891)),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _accent, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0xFFC62828)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF27344E),
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
