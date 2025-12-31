// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import '../models/tyre_reading.dart';

class TyreControlGroup extends StatelessWidget {
  final List<TyreReading> tyreReadings;
  final String vehicleType;
  final Function(String, double) onPressureChanged;
  final bool isInflating;

  const TyreControlGroup({
    super.key,
    required this.tyreReadings,
    required this.vehicleType,
    required this.onPressureChanged,
    required this.isInflating,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: vehicleType == 'CAR' ? 2 : 1,
        childAspectRatio: vehicleType == 'CAR' ? 1.2 : 1.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: tyreReadings.length,
      itemBuilder: (context, index) {
        final tyre = tyreReadings[index];
        return _buildTyreCard(tyre, context);
      },
    );
  }

  Widget _buildTyreCard(TyreReading tyre, BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Position Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tyre.position,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            // Current Pressure
            Text(
              '${tyre.currentPressure.toStringAsFixed(0)} PSI',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(tyre),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(tyre),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

            const SizedBox(height: 16),

            // Target Pressure Control
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: tyre.targetPressure > 20
                      ? () => onPressureChanged(
                          tyre.position,
                          tyre.targetPressure - 1,
                        )
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      'TARGET',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${tyre.targetPressure.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'PSI',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: tyre.targetPressure < 50
                      ? () => onPressureChanged(
                          tyre.position,
                          tyre.targetPressure + 1,
                        )
                      : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TyreReading tyre) {
    if (tyre.isInflating) return Colors.blue;
    if (tyre.isComplete) return Colors.green;
    if (tyre.currentPressure >= tyre.targetPressure) return Colors.green;
    if (tyre.currentPressure > 0) return Colors.orange;
    return Colors.grey;
  }

  String _getStatusText(TyreReading tyre) {
    if (tyre.isInflating) return 'INFLATING';
    if (tyre.isComplete) return 'COMPLETE';
    if (tyre.currentPressure >= tyre.targetPressure) return 'READY';
    if (tyre.currentPressure > 0) return 'IN PROGRESS';
    return 'NOT STARTED';
  }
}
