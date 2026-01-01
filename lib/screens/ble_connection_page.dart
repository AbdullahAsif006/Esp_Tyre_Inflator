import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/shared_app_bar.dart';
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
    
    bleController.isScanning.listen((scanning) {
      if (mounted) {
        setState(() {
          _isScanning = scanning;
        });
      }
    });
  }

  void _startScanning() {
    bleController.scanDevices();
  }

  void _stopScanning() {
    bleController.stopScan();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        title: 'Connect to Device',
        showBackButton: true,
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
    return GetBuilder<BleController>(
      builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(controller),
              const SizedBox(height: 20),
              _buildScanControlCard(),
              const SizedBox(height: 20),
              _buildScanResults(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(BleController controller) {
    return Card(
      elevation: 4,
      color: controller.connectedDevice != null
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
                  controller.connectedDevice != null
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth,
                  color: controller.connectedDevice != null
                      ? Colors.green
                      : Colors.orange,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    controller.statusText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: controller.connectedDevice != null
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            if (controller.connectedDevice != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 10),
                  Text(
                    'Device: ${controller.connectedDevice!.platformName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'ID: ${controller.connectedDevice!.remoteId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      controller.clearSavedDevice();
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
        
        final uniqueDevices = <BluetoothDevice>[];
        for (var device in devices) {
          if (!uniqueDevices.any((d) => d.remoteId == device.remoteId)) {
            uniqueDevices.add(device);
          }
        }
        
        final filteredDevices = uniqueDevices.where((device) {
          final deviceName = device.platformName;
          return deviceName.toLowerCase().startsWith('airtek');
        }).toList();
        
        if (filteredDevices.isEmpty) {
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
                      'FOUND DEVICES (${filteredDevices.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Chip(
                      label: Text('${filteredDevices.length} found'),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDevices.length,
                  separatorBuilder: (context, index) => const Divider(height: 8),
                  itemBuilder: (context, index) {
                    final device = filteredDevices[index];
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
}