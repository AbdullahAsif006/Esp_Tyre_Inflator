import 'package:flutter/material.dart';

class PressureDisplay extends StatelessWidget {
  final double currentPressure;
  final double targetPressure;

  const PressureDisplay({
    super.key,
    required this.currentPressure,
    required this.targetPressure,
  });

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'PRESSURE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: onSurfaceColor,
              ),
            ),
            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // CURRENT
                _pressureBox(
                  label: 'CURRENT',
                  value: currentPressure,
                  valueColor: Colors.white,
                  context: context,
                ),

                // TARGET
                _pressureBox(
                  label: 'TARGET',
                  value: targetPressure,
                  valueColor: Colors.green[300]!,
                  context: context,
                  borderColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Difference
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getDifferenceColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getDifferenceIcon(),
                    size: 16,
                    color: _getDifferenceColor(),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${_difference().toStringAsFixed(0)} PSI ${_differenceText()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getDifferenceColor(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pressureBox({
    required String label,
    required double value,
    required Color valueColor,
    required BuildContext context,
    Color? borderColor,
  }) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor ?? Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Text(
            '${value.toStringAsFixed(0)} PSI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  double _difference() => (targetPressure - currentPressure).abs();

  String _differenceText() {
    if (currentPressure == 0) return 'NEEDED';
    if (currentPressure < targetPressure) return 'NEEDED';
    if (currentPressure > targetPressure) return 'OVER';
    return 'PERFECT';
  }

  Color _getDifferenceColor() {
    if (currentPressure == 0) return Colors.orange;
    if (currentPressure < targetPressure - 2) return Colors.orange;
    if (currentPressure < targetPressure) return Colors.blue;
    if (currentPressure > targetPressure) return Colors.red;
    return Colors.green;
  }

  IconData _getDifferenceIcon() {
    if (currentPressure == 0) return Icons.warning;
    if (currentPressure < targetPressure) return Icons.arrow_upward;
    if (currentPressure > targetPressure) return Icons.arrow_downward;
    return Icons.check_circle;
  }
}
