// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get appTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFD54F),
        secondary: Color(0xFF2196F3),
        background: Color.fromARGB(255, 121, 190, 224),
        onBackground: Colors.white,
        surface: Color.fromARGB(255, 66, 87, 97),
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFD54F),
        foregroundColor: Color(0xFF37474F),
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: Color.fromARGB(151, 33, 131, 161),
        elevation: 4,
        margin: EdgeInsets.all(8),
      ),
      scaffoldBackgroundColor: const Color(0xFF37474F),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF455A64),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD54F),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
