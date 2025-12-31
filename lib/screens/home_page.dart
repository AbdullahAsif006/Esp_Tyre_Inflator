// ignore_for_file: prefer_final_fields, deprecated_member_use

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'vehicle_inflation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _vehicleNumber;
  String _selectedVehicleType = 'BIKE';
  final TextEditingController _vehicleController = TextEditingController();
  bool _isInflating = false;
  double _targetPressure = AppConstants.defaultPressure;
  double _currentPressure = 0.0; // Always starts at 0

  void _navigateToVehicleInflation() {
    if (_vehicleNumber != null && _vehicleNumber!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VehicleInflationPage(
            vehicleNumber: _vehicleNumber!,
            vehicleType: _selectedVehicleType,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter vehicle number')),
      );
    }
  }

  void _onVehicleNumberChanged(String value) {
    setState(() {
      _vehicleNumber = value;
    });
  }

  void _onVehicleTypeChanged(String type) {
    setState(() {
      _selectedVehicleType = type;
    });
  }

  void _toggleInflation() {
    setState(() {
      _isInflating = !_isInflating;

      if (_isInflating) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inflation started'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inflation stopped'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _onTargetPressureChanged(double newPressure) {
    setState(() {
      _targetPressure = newPressure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tyre Inflator"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
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
                                  backgroundColor: _isInflating
                                      ? Colors.red
                                      : Colors.green,
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
                                    backgroundColor:
                                        _selectedVehicleType == type
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
                              onPressed:
                                  _vehicleNumber != null &&
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

                // Stats Card - UPDATED: Tyre and Vehicle count with spacing
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
                        // Tyre and Vehicle count with spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Tyre Count Box
                            Expanded(child: _buildStatBox('Tyres', '12')),

                            // Spacing between boxes - UPDATED: Increased spacing
                            const SizedBox(width: 20),

                            // Vehicle Count Box
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
}
