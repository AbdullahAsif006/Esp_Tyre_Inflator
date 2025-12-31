import 'package:flutter/material.dart';

class VehicleInfoSection extends StatelessWidget {
  final String? vehicleNumber;
  final String selectedVehicleType;
  final TextEditingController vehicleController;
  final ValueChanged<String> onVehicleNumberChanged;
  final ValueChanged<String> onVehicleTypeChanged;
  final VoidCallback onNavigateToVehicleInflation;

  const VehicleInfoSection({
    super.key,
    required this.vehicleNumber,
    required this.selectedVehicleType,
    required this.vehicleController,
    required this.onVehicleNumberChanged,
    required this.onVehicleTypeChanged,
    required this.onNavigateToVehicleInflation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Vehicle Type
        _buildVehicleTypeSection(context),
        const SizedBox(height: 12),

        // Vehicle Input
        _buildVehicleInputSection(context),
      ],
    );
  }

  Widget _buildVehicleTypeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VEHICLE TYPE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: ['BIKE', 'CAR'].map((type) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedVehicleType == type
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.surface,
                        foregroundColor: selectedVehicleType == type
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => onVehicleTypeChanged(type),
                      child: Text(type),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInputSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VEHICLE INFORMATION',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: vehicleController,
              decoration: InputDecoration(
                hintText: 'Enter Vehicle Number',
                border: const OutlineInputBorder(),
                suffixIcon: vehicleNumber != null && vehicleNumber!.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          selectedVehicleType == 'CAR'
                              ? Icons.directions_car
                              : Icons.two_wheeler,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: onNavigateToVehicleInflation,
                      )
                    : null,
              ),
              onChanged: onVehicleNumberChanged,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onNavigateToVehicleInflation();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
