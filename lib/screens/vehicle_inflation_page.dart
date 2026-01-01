import 'package:flutter/material.dart';
import '../widgets/shared_app_bar.dart'; // Add this import
import '../models/tyre_reading.dart';

class VehicleInflationPage extends StatefulWidget {
  final String vehicleNumber;
  final String vehicleType;

  const VehicleInflationPage({
    super.key,
    required this.vehicleNumber,
    required this.vehicleType,
  });

  @override
  State<VehicleInflationPage> createState() => _VehicleInflationPageState();
}

class _VehicleInflationPageState extends State<VehicleInflationPage> {
  List<TyreReading> _tyreReadings = [];

  @override
  void initState() {
    super.initState();
    _initializeTyreReadings();
  }

  void _initializeTyreReadings() {
    final positions = widget.vehicleType == 'CAR'
        ? ['FL', 'FR', 'RL', 'RR']
        : ['FRONT', 'REAR'];

    setState(() {
      _tyreReadings = positions
          .map((position) => TyreReading(
                position: position,
                currentPressure: 0.0,
                targetPressure: 30.0, // Default to 30 PSI for all vehicles
              ))
          .toList();
    });
  }

  void _updateTyrePressure(String position, double newPressure) {
    setState(() {
      _tyreReadings = _tyreReadings.map((tyre) {
        if (tyre.position == position) {
          return tyre.copyWith(targetPressure: newPressure);
        }
        return tyre;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: SharedAppBar(
        title: 'Vehicle: ${widget.vehicleNumber}',
        showBackButton: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Vehicle Type Indicator - Compact
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.vehicleType == 'CAR'
                        ? Icons.directions_car
                        : Icons.two_wheeler,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.vehicleType} MODE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content - Takes available space
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: _buildMainContent(screenHeight, screenWidth),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(double screenHeight, double screenWidth) {
    final isCar = widget.vehicleType == 'CAR';
    final imagePath =
        isCar ? 'assets/car_tyre_layout.png' : 'assets/bike_tyre_layout.png';

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Tyre Layout Image - Positioned based on vehicle type
          Container(
            width: double.infinity,
            height: double.infinity,
            child: isCar
                ? Center(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.35,
                    ),
                  )
                : Column(
                    children: [
                      // Padding for bike image
                      SizedBox(
                          height: screenHeight * 0.04), // 4% padding from top
                      Center(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          width: screenWidth * 0.6,
                          height: screenHeight * 0.25,
                        ),
                      ),
                    ],
                  ),
          ),

          // Tyre Controls
          ..._buildTyreControls(isCar, screenWidth, screenHeight),
        ],
      ),
    );
  }

  List<Widget> _buildTyreControls(
      bool isCar, double screenWidth, double screenHeight) {
    if (isCar) {
      return [
        // Front Left (FL) - Top Left
        Positioned(
          left: 4,
          top: screenHeight * 0.05,
          child: _buildTyreControlWidget('FL'),
        ),
        // Front Right (FR) - Top Right
        Positioned(
          right: 4,
          top: screenHeight * 0.05,
          child: _buildTyreControlWidget('FR'),
        ),
        // Rear Left (RL) - Bottom Left
        Positioned(
          left: 4,
          bottom: screenHeight * 0.08,
          child: _buildTyreControlWidget('RL'),
        ),
        // Rear Right (RR) - Bottom Right
        Positioned(
          right: 4,
          bottom: screenHeight * 0.08,
          child: _buildTyreControlWidget('RR'),
        ),
      ];
    } else {
      return [
        // Front - Right side, positioned below the bike image
        Positioned(
          right: screenWidth * 0.1,
          top: screenHeight *
              0.35, // Positioned below the bike image with padding
          child: _buildTyreControlWidget('FRONT'),
        ),
        // Rear - Left side, positioned below the bike image
        Positioned(
          left: screenWidth * 0.1,
          top: screenHeight *
              0.35, // Positioned below the bike image with padding
          child: _buildTyreControlWidget('REAR'),
        ),
      ];
    }
  }

  Widget _buildTyreControlWidget(String position) {
    // FIX: Using try-catch to handle potential errors
    try {
      final tyreIndex = _tyreReadings.indexWhere((t) => t.position == position);

      if (tyreIndex == -1) {
        // Return default widget if tyre not found
        return _buildTyreControlContainer(
          position: position,
          currentPressure: 0.0,
          targetPressure: 30.0, // Default to 30 PSI
        );
      }

      final tyre = _tyreReadings[tyreIndex];
      return _buildTyreControlContainer(
        position: tyre.position,
        currentPressure: tyre.currentPressure,
        targetPressure: tyre.targetPressure,
      );
    } catch (e) {
      // Fallback widget in case of any error
      return _buildTyreControlContainer(
        position: position,
        currentPressure: 0.0,
        targetPressure: 30.0, // Default to 30 PSI
      );
    }
  }

  Widget _buildTyreControlContainer({
    required String position,
    required double currentPressure,
    required double targetPressure,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Position Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              position,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Current Pressure
          _buildPressureDisplay(
            'CURRENT',
            currentPressure.toStringAsFixed(0),
            Colors.blue,
          ),

          const SizedBox(height: 6),

          // Target Pressure
          _buildPressureDisplay(
            'TARGET',
            targetPressure.toStringAsFixed(0),
            Colors.green,
          ),

          const SizedBox(height: 8),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrease Button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: IconButton(
                  onPressed: targetPressure > 20
                      ? () => _updateTyrePressure(position, targetPressure - 1)
                      : null,
                  icon: const Icon(Icons.remove, size: 14),
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(width: 10),

              // Increase Button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: IconButton(
                  onPressed: targetPressure < 50
                      ? () => _updateTyrePressure(position, targetPressure + 1)
                      : null,
                  icon: const Icon(Icons.add, size: 14),
                  color: Colors.green,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPressureDisplay(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Text(
            '$value PSI',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
