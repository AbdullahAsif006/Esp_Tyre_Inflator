import 'tyre_reading.dart';

class InflationSession {
  final String sessionId;
  final String vehicleNumber;
  final String vehicleType;
  final List<TyreReading> tyreReadings;
  final DateTime startTime;
  final DateTime endTime;
  final double totalAmount;
  final String mode;

  InflationSession({
    required this.sessionId,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.tyreReadings,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    this.mode = 'MANUAL',
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'tyreReadings': tyreReadings
          .map(
            (t) => {
              'position': t.position,
              'currentPressure': t.currentPressure,
              'targetPressure': t.targetPressure,
              'isComplete': t.isComplete,
            },
          )
          .toList(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'totalAmount': totalAmount,
      'mode': mode,
    };
  }

  static InflationSession fromMap(Map<String, dynamic> map) {
    return InflationSession(
      sessionId: map['sessionId'],
      vehicleNumber: map['vehicleNumber'],
      vehicleType: map['vehicleType'],
      tyreReadings: (map['tyreReadings'] as List)
          .map(
            (t) => TyreReading(
              position: t['position'],
              currentPressure: t['currentPressure'].toDouble(),
              targetPressure: t['targetPressure'].toDouble(),
              isComplete: t['isComplete'],
            ),
          )
          .toList(),
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      totalAmount: map['totalAmount'].toDouble(),
      mode: map['mode'],
    );
  }
}
