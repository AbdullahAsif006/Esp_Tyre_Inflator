import '../models/tyre_reading.dart';

class CalculationService {
  static const double bikeRatePerPSI = 5.0;
  static const double carRatePerPSI = 10.0;
  static const double truckRatePerPSI = 15.0;

  static double calculateAmount(
    List<TyreReading> tyreReadings,
    String vehicleType,
  ) {
    double totalPressureDiff = 0;

    for (var tyre in tyreReadings) {
      if (tyre.currentPressure < tyre.targetPressure) {
        totalPressureDiff += (tyre.targetPressure - tyre.currentPressure);
      }
    }

    double ratePerPSI = _getRatePerPSI(vehicleType);
    return totalPressureDiff * ratePerPSI;
  }

  static double _getRatePerPSI(String vehicleType) {
    switch (vehicleType.toUpperCase()) {
      case 'BIKE':
        return bikeRatePerPSI;
      case 'CAR':
        return carRatePerPSI;
      case 'TRUCK':
        return truckRatePerPSI;
      default:
        return carRatePerPSI;
    }
  }

  static double calculateTotalPressureNeeded(List<TyreReading> tyreReadings) {
    double totalNeeded = 0;

    for (var tyre in tyreReadings) {
      if (tyre.currentPressure < tyre.targetPressure) {
        totalNeeded += (tyre.targetPressure - tyre.currentPressure);
      }
    }

    return totalNeeded;
  }

  static bool isInflationComplete(List<TyreReading> tyreReadings) {
    return tyreReadings.every(
      (tyre) => tyre.currentPressure >= tyre.targetPressure || tyre.isComplete,
    );
  }

  static double getCompletionPercentage(List<TyreReading> tyreReadings) {
    if (tyreReadings.isEmpty) return 0.0;

    double totalTarget = 0;
    double totalCurrent = 0;

    for (var tyre in tyreReadings) {
      totalTarget += tyre.targetPressure;
      totalCurrent += tyre.currentPressure;
    }

    return totalTarget > 0 ? (totalCurrent / totalTarget) * 100 : 0.0;
  }
}
