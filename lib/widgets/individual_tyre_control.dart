// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class IndividualTyreControl extends StatelessWidget {
  final String position;
  final double currentPressure;
  final double targetPressure;
  final Function(double) onPressureChanged;

  const IndividualTyreControl({
    super.key,
    required this.position,
    required this.currentPressure,
    required this.targetPressure,
    required this.onPressureChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.07;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF8E1), // Light gold
              Color(0xFFFFECB3), // Gold
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tyre Position
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFFFD54F).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  position,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Current Pressure
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFFFD54F), width: 2),
                ),
                child: Text(
                  '${currentPressure.toStringAsFixed(0)} PSI',
                  style: TextStyle(
                    fontSize: 24,
                    color: _getPressureColor(currentPressure, targetPressure),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Target Pressure Container
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFFFD54F), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFD54F).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'TARGET PRESSURE',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5D4037),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Large Pressure Value
                    Text(
                      '${targetPressure.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D4037),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      'PSI',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF5D4037).withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // +/- Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Decrease Button
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF7043), Color(0xFFF4511E)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFF4511E).withOpacity(0.4),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: targetPressure > AppConstants.minPressure
                                ? () => onPressureChanged(targetPressure - 1)
                                : null,
                            icon: Icon(Icons.remove, size: 24),
                            color: Colors.white,
                            iconSize: buttonSize,
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.all(buttonSize * 0.3),
                            ),
                          ),
                        ),

                        SizedBox(width: buttonSize * 1.2),

                        // Increase Button
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF43A047).withOpacity(0.4),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: targetPressure < AppConstants.maxPressure
                                ? () => onPressureChanged(targetPressure + 1)
                                : null,
                            icon: Icon(Icons.add, size: 24),
                            color: Colors.white,
                            iconSize: buttonSize,
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.all(buttonSize * 0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPressureColor(double current, double target) {
    if (current == 0) return Color(0xFF757575);
    if (current < target - 2) return Color(0xFFF57C00);
    if (current >= target) return Color(0xFF388E3C);
    return Color(0xFF1976D2);
  }
}
