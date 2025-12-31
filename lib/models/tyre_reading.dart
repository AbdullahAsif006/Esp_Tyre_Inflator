class TyreReading {
  final String position;
  final double currentPressure;
  final double targetPressure;
  final bool isInflating;
  final bool isComplete;

  TyreReading({
    required this.position,
    required this.currentPressure,
    required this.targetPressure,
    this.isInflating = false,
    this.isComplete = false,
  });

  TyreReading copyWith({
    String? position,
    double? currentPressure,
    double? targetPressure,
    bool? isInflating,
    bool? isComplete,
  }) {
    return TyreReading(
      position: position ?? this.position,
      currentPressure: currentPressure ?? this.currentPressure,
      targetPressure: targetPressure ?? this.targetPressure,
      isInflating: isInflating ?? this.isInflating,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class VehicleTyrePositions {
  static const List<String> car = ['FL', 'FR', 'RL', 'RR'];
  static const List<String> bike = ['FRONT', 'REAR'];

  static List<String> getPositionsForVehicle(String vehicleType) {
    switch (vehicleType) {
      case 'CAR':
        return car;
      case 'BIKE':
        return bike;
      default:
        return car;
    }
  }

  static String getDisplayName(String position) {
    return position;
  }
}
