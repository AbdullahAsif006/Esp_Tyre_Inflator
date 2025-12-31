import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/ble_controller.dart';

class BleConnectionPage extends StatefulWidget {
  const BleConnectionPage({super.key});

  @override
  State<BleConnectionPage> createState() => _BleConnectionPageState();
}

class _BleConnectionPageState extends State<BleConnectionPage> {
  late final BleController bleController;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controller
    if (Get.isRegistered<BleController>()) {
      bleController = Get.find<BleController>();
    } else {
      bleController = Get.put(BleController());
    }
    
    // Start scanning on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScanning();
    });
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
    });
    bleController.scanDevices();
  }

  void _stopScanning() {
    FlutterBluePlus.stopScan();
    setState(() {
      _isScanning = false;
    });
  }

  void _toggleScan() {
    if (_isScanning) {
      _stopScanning();
    } else {
      _startScanning();
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    await bleController.connectToDevice(device);
  }

  void _turnLedOn() async {
    await bleController.sendData("ON");
    Get.snackbar(
      'Success',
      'LED ON command sent',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void _turnLedOff() async {
    await bleController.sendData("OFF");
    Get.snackbar(
      'Success',
      'LED OFF command sent',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to Device'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
        actions: [
          // Connection status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: bleController.connectedDevice != null
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: bleController.connectedDevice != null ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  bleController.connectedDevice != null
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  size: 16,
                  color: bleController.connectedDevice != null ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  bleController.connectedDevice != null ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: bleController.connectedDevice != null ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _isScanning
          ? FloatingActionButton(
              onPressed: _stopScanning,
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          _buildStatusCard(),
          
          const SizedBox(height: 20),
          
          // Scan Control Card
          _buildScanControlCard(),
          
          const SizedBox(height: 20),
          
          // Scan Results
          _buildScanResults(),
          
          const SizedBox(height: 20),
          
          // LED Controls (only when connected)
          if (bleController.connectedDevice != null) _buildLedControlCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      color: bleController.connectedDevice != null
          ? Colors.green.withOpacity(0.05)
          : Colors.orange.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  bleController.connectedDevice != null
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth,
                  color: bleController.connectedDevice != null
                      ? Colors.green
                      : Colors.orange,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bleController.statusText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: bleController.connectedDevice != null
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            if (bleController.connectedDevice != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 10),
                  Text(
                    'Device: ${bleController.connectedDevice!.platformName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'ID: ${bleController.connectedDevice!.remoteId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      bleController.clearSavedDevice();
                      _startScanning();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, size: 20),
                        SizedBox(width: 8),
                        Text('CLEAR & DISCONNECT'),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanControlCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SCAN FOR DEVICES',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            
            ElevatedButton(
              onPressed: _toggleScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isScanning ? Colors.red : Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isScanning ? Icons.stop : Icons.search,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isScanning ? 'STOP SCANNING' : 'START SCANNING',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            if (_isScanning)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Scanning for devices...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
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

  Widget _buildScanResults() {
    return StreamBuilder<List<ScanResult>>(
      stream: bleController.scanResults,
      initialData: const [],
      builder: (context, snapshot) {
        final results = snapshot.data ?? [];
        final devices = results.map((r) => r.device).toList();
        
        // Remove duplicates by ID
        final uniqueDevices = <BluetoothDevice>[];
        for (var device in devices) {
          if (!uniqueDevices.any((d) => d.remoteId == device.remoteId)) {
            uniqueDevices.add(device);
          }
        }
        
        if (uniqueDevices.isEmpty) {
          return _buildNoDevicesFound();
        }
        
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FOUND DEVICES (${uniqueDevices.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Chip(
                      label: Text('${uniqueDevices.length} found'),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: uniqueDevices.length,
                  separatorBuilder: (context, index) => const Divider(height: 8),
                  itemBuilder: (context, index) {
                    final device = uniqueDevices[index];
                    final isConnected = bleController.connectedDevice?.remoteId == device.remoteId;
                    final deviceName = device.platformName.isEmpty 
                        ? "Unknown Device" 
                        : device.platformName;
                    
                    return ListTile(
                      leading: Icon(
                        Icons.bluetooth,
                        color: isConnected ? Colors.green : Colors.blue,
                      ),
                      title: Text(
                        deviceName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isConnected ? Colors.green : null,
                        ),
                      ),
                      subtitle: Text(
                        device.remoteId.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: isConnected
                          ? const Chip(
                              label: Text('Connected'),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            )
                          : ElevatedButton(
                              onPressed: () => _connectToDevice(device),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: const Text('CONNECT'),
                            ),
                      onTap: () => _connectToDevice(device),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoDevicesFound() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          children: [
            Icon(
              Icons.bluetooth_disabled,
              size: 60,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No devices found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click START SCANNING to search for devices',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedControlCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LED CONTROL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Control the LED on your ESP32 device',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _turnLedOn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('TURN LED ON'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _turnLedOff,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.lightbulb),
                    label: const Text('TURN LED OFF'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}