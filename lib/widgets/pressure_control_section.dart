import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'pressure_display.dart';

class PressureControlSection extends StatelessWidget {
  final double currentPressure;
  final double targetPressure;
  final bool isInflating;
  final ValueChanged<double> onTargetChanged;
  final VoidCallback onToggleInflation;

  const PressureControlSection({
    super.key,
    required this.currentPressure,
    required this.targetPressure,
    required this.isInflating,
    required this.onTargetChanged,
    required this.onToggleInflation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pressure Display (UPDATED)
        PressureDisplay(
          currentPressure: currentPressure,
          targetPressure: targetPressure,
        ),

        const SizedBox(height: 12),

        // Control Buttons
        _buildButtonRow(),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Decrease
            Expanded(
              child: ElevatedButton(
                onPressed: targetPressure > AppConstants.minPressure
                    ? () => onTargetChanged(targetPressure - 1)
                    : null,
                style: _buttonStyle(Colors.red),
                child: _buttonContent(Icons.remove, 'DEC'),
              ),
            ),

            const SizedBox(width: 8),

            // Start / Stop
            Expanded(
              child: ElevatedButton(
                onPressed: onToggleInflation,
                style: _buttonStyle(isInflating ? Colors.red : Colors.green),
                child: _buttonContent(
                  isInflating ? Icons.stop : Icons.play_arrow,
                  isInflating ? 'STOP' : 'START',
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Increase
            Expanded(
              child: ElevatedButton(
                onPressed: targetPressure < AppConstants.maxPressure
                    ? () => onTargetChanged(targetPressure + 1)
                    : null,
                style: _buttonStyle(Colors.green),
                child: _buttonContent(Icons.add, 'INC'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buttonContent(IconData icon, String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
