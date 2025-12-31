import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFFD54F);
  static const Color primaryDark = Color(0xFFF9A825);
  static const Color primaryLight = Color(0xFFFFECB3);

  // Secondary Colors
  static const Color secondary = Color(0xFF2196F3);
  static const Color secondaryDark = Color(0xFF1976D2);
  static const Color secondaryLight = Color(0xFF64B5F6);

  // Background Colors
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color card = Color(0xFF252525);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0xFF757575);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Pressure Colors
  static const Color pressureLow = Color(0xFFFF9800);
  static const Color pressureMedium = Color(0xFFFFC107);
  static const Color pressureHigh = Color(0xFF4CAF50);
  static const Color pressureVeryHigh = Color(0xFFF44336);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFD54F), Color(0xFFF9A825)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
