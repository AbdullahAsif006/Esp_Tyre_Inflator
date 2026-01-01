// ignore_for_file: prefer_final_fields, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/shared_app_bar.dart';
import '../services/ble_controller.dart';
import 'vehicle_inflation_page.dart'; // Add this import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State variables
  double _currentPressure = 0;
  double _targetPressure = 32;
  bool _isInflating = false;
  String? _selectedVehicleType = 'CAR';
  String? _vehicleNumber;
  final TextEditingController _vehicleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure BleController is initialized
    if (!Get.isRegistered<BleController>()) {
      Get.put(BleController());
    }
  }

  @override
  void dispose() {
    _vehicleController.dispose();
    super.dispose();
  }

  void _onTargetPressureChanged(double newPressure) {
    setState(() {
      _targetPressure = newPressure.clamp(
        AppConstants.minPressure,
        AppConstants.maxPressure,
      );
    });
  }

  void _toggleInflation() {
    setState(() {
      _isInflating = !_isInflating;
      if (_isInflating) {
        // Start inflation logic
      } else {
        // Stop inflation logic
      }
    });
  }

  void _onVehicleTypeChanged(String type) {
    setState(() {
      _selectedVehicleType = type;
    });
  }

  void _onVehicleNumberChanged(String value) {
    setState(() {
      _vehicleNumber = value.isNotEmpty ? value : null;
    });
  }

  void _navigateToVehicleInflation() {
    if (_vehicleNumber != null && _vehicleNumber!.isNotEmpty && _selectedVehicleType != null) {
      Get.to(() => VehicleInflationPage(
        vehicleNumber: _vehicleNumber!,
        vehicleType: _selectedVehicleType!,
      ));
    } else {
      // Show error message if vehicle number is empty
      Get.snackbar(
        'Error',
        'Please enter a vehicle number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildPressureBox(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'PSI',
                  style: TextStyle(fontSize: 14, color: color.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        title: 'Tyre Inflator',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                // Pressure Control Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Pressure Display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Current Pressure (Always 0)
                            _buildPressureBox(
                              'CURRENT',
                              '${_currentPressure.toStringAsFixed(0)} PSI',
                              Colors.blue,
                            ),
                            const SizedBox(width: 16),
                            // Target Pressure (Editable)
                            _buildPressureBox(
                              'TARGET',
                              '${_targetPressure.toStringAsFixed(0)} PSI',
                              Colors.green,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Control Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    _targetPressure > AppConstants.minPressure
                                        ? () => _onTargetPressureChanged(
                                              _targetPressure - 1,
                                            )
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.remove, size: 20),
                                    SizedBox(width: 4),
                                    Text('DEC'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _toggleInflation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _isInflating ? Colors.red : Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _isInflating
                                          ? Icons.stop
                                          : Icons.play_arrow,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(_isInflating ? 'STOP' : 'START'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    _targetPressure < AppConstants.maxPressure
                                        ? () => _onTargetPressureChanged(
                                              _targetPressure + 1,
                                            )
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, size: 20),
                                    SizedBox(width: 4),
                                    Text('INC'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Vehicle Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'VEHICLE SELECTION',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),

                        // Vehicle Type
                        Row(
                          children: ['BIKE', 'CAR'].map((type) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedVehicleType ==
                                            type
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.secondary
                                        : Theme.of(context).colorScheme.surface,
                                    foregroundColor:
                                        _selectedVehicleType == type
                                            ? Colors.white
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () => _onVehicleTypeChanged(type),
                                  child: Text(type),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        // Vehicle Number Input
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _vehicleController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Vehicle Number',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                                onChanged: (value) {
                                  final upperValue = value.toUpperCase();
                                  if (value != upperValue) {
                                    _vehicleController.value =
                                        _vehicleController.value.copyWith(
                                      text: upperValue,
                                      selection: TextSelection.collapsed(
                                        offset: upperValue.length,
                                      ),
                                    );
                                  }
                                  _onVehicleNumberChanged(upperValue);
                                },
                                textCapitalization:
                                    TextCapitalization.characters,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _vehicleNumber != null &&
                                      _vehicleNumber!.isNotEmpty
                                  ? _navigateToVehicleInflation
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('GO'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stats Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'TODAY\'S STATS',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _buildStatBox('Tyres', '12')),
                            const SizedBox(width: 20),
                            Expanded(child: _buildStatBox('Vehicles', '8')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// App constants class
class AppConstants {
  static const double minPressure = 0;
  static const double maxPressure = 50;
}