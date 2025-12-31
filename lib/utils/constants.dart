import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Tyre Inflator';
  static const String appVersion = '1.0.0';

  // Pressure Constants
  static const double defaultPressure = 32.0;
  static const double minPressure = 20.0;
  static const double maxPressure = 50.0;
  static const double pressureStep = 1.0;

  // Vehicle Defaults
  static const String defaultVehicleType = 'BIKE';
  static const Map<String, double> defaultVehiclePressures = {
    'BIKE': 32.0,
    'CAR': 35.0,
    'TRUCK': 45.0,
  };

  // Time Constants
  static const Duration inflationSimulationDelay = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 2);

  // UI Constants
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;

  // Animation Constants
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;

  // Storage Keys
  static const String sessionStorageKey = 'tyre_inflator_sessions';
  static const String settingsStorageKey = 'tyre_inflator_settings';
  static const String vehicleHistoryKey = 'vehicle_history';

  // Validation
  static const int maxVehicleNumberLength = 20;
  static final RegExp vehicleNumberRegex = RegExp(r'^[A-Z0-9\s\-]+$');

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  // Units
  static const String pressureUnit = 'PSI';
  static const String temperatureUnit = '°C';

  // Mock Data
  static const int mockDailyTyreCount = 12;
  static const int mockDailyVehicleCount = 8;
  static const double mockDailyAmount = 240.0;
}
