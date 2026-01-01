import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  final box = GetStorage();

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? writeChar;

  bool isConnecting = false;
  bool isReconnecting = false;
  RxBool isScanning = false.obs;

  String statusText = "Idle";
  
  // Add signal strength tracking
  RxInt rssi = (-100).obs;
  RxString signalStrength = "No Signal".obs;

  static const String serviceUuid = "12345678-1234-1234-1234-123456789abc";
  static const String charUuid = "abcdefab-1234-5678-1234-abcdefabcdef";
  static const String savedDeviceId = "saved_device_id";

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  Timer? _rssiTimer;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 300), () {
      autoConnectSavedDevice();
    });
  }

  @override
  void onClose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    _rssiTimer?.cancel();
    super.onClose();
  }

  /// SCAN
  Future<void> scanDevices() async {
    if (isScanning.value) return;
    
    statusText = "Scanning...";
    isScanning.value = true;
    update();

    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    await FlutterBluePlus.turnOn();
    await FlutterBluePlus.stopScan();

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  /// STOP SCAN
  Future<void> stopScan() async {
    if (!isScanning.value) return;
    await FlutterBluePlus.stopScan();
    isScanning.value = false;
    statusText = connectedDevice != null ? "Connected" : "Idle";
    update();
  }

  /// AUTO CONNECT SAVED DEVICE ON STARTUP
  void autoConnectSavedDevice() async {
    final savedId = box.read(savedDeviceId);
    if (savedId != null && connectedDevice == null) {
      if (isConnecting || isReconnecting) return;
      
      try {
        statusText = "Searching for saved device...";
        update();
        
        await scanDevices();
        
        _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
          for (var r in results) {
            if (r.device.remoteId.toString() == savedId) {
              await _scanSubscription?.cancel();
              await connectToDevice(r.device);
              return;
            }
          }
        });
        
        Future.delayed(const Duration(seconds: 10), () async {
          if (connectedDevice == null) {
            await _scanSubscription?.cancel();
            await stopScan();
            statusText = "Device not found";
            update();
          }
        });
        
      } catch (e) {
        statusText = "Search failed";
        update();
      }
    }
  }

  /// Update signal strength
  void _updateSignalStrength() {
    if (rssi.value >= -50) {
      signalStrength.value = "Excellent";
    } else if (rssi.value >= -70) {
      signalStrength.value = "Good";
    } else if (rssi.value >= -85) {
      signalStrength.value = "Fair";
    } else {
      signalStrength.value = "Poor";
    }
  }

  /// Start monitoring RSSI when connected
  void _startRssiMonitoring(BluetoothDevice device) {
    _rssiTimer?.cancel();
    
    // Update RSSI immediately
    if (connectedDevice != null) {
      connectedDevice!.readRssi().then((value) {
        rssi.value = value;
        _updateSignalStrength();
      }).catchError((_) {});
    }
    
    // Monitor RSSI every 3 seconds
    _rssiTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (connectedDevice != null) {
        connectedDevice!.readRssi().then((value) {
          rssi.value = value;
          _updateSignalStrength();
        }).catchError((_) {
          // If we can't read RSSI, device might be disconnected
          if (connectedDevice != null) {
            connectedDevice = null;
            writeChar = null;
            statusText = "Disconnected";
            timer.cancel();
            update();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  /// CONNECT
  Future<void> connectToDevice(BluetoothDevice device) async {
    if (isConnecting || connectedDevice?.remoteId == device.remoteId) return;

    try {
      isConnecting = true;
      statusText = "Connecting...";
      update();

      await _scanSubscription?.cancel();
      await stopScan();

      if (connectedDevice != null) {
        await connectedDevice!.disconnect();
      }

      await _connectionSubscription?.cancel();

      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      statusText = "Discovering services...";
      update();

      final services = await device.discoverServices();
      
      bool foundService = false;
      for (var service in services) {
        if (service.uuid.toString() == serviceUuid) {
          for (var char in service.characteristics) {
            if (char.uuid.toString() == charUuid) {
              writeChar = char;
              foundService = true;
              break;
            }
          }
          if (foundService) break;
        }
      }

      if (!foundService) {
        throw Exception("Required service/characteristic not found");
      }

      connectedDevice = device;
      box.write(savedDeviceId, device.remoteId.toString());
      statusText = "Connected";
      isConnecting = false;
      
      // Start RSSI monitoring
      _startRssiMonitoring(device);
      update();

      _connectionSubscription = device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          connectedDevice = null;
          writeChar = null;
          statusText = "Disconnected";
          isConnecting = false;
          _rssiTimer?.cancel();
          update();
        } else if (state == BluetoothConnectionState.connected) {
          statusText = "Connected";
          update();
        }
      });

    } catch (e) {
      statusText = "Connection Failed";
      isConnecting = false;
      update();
      
      try {
        await device.disconnect();
      } catch (_) {}
    }
  }

  /// SEND DATA
  Future<void> sendData(String data) async {
    if (writeChar == null) return;
    try {
      await writeChar!.write(utf8.encode(data));
    } catch (e) {
      statusText = "Send failed";
      update();
    }
  }

  /// CLEAR SAVED DEVICE
  void clearSavedDevice() async {
    await _scanSubscription?.cancel();
    await _connectionSubscription?.cancel();
    _rssiTimer?.cancel();
    
    box.remove(savedDeviceId);
    if (connectedDevice != null) {
      try {
        await connectedDevice!.disconnect();
      } catch (_) {}
    }
    connectedDevice = null;
    writeChar = null;
    statusText = "Idle";
    isConnecting = false;
    isReconnecting = false;
    update();
  }
  
  /// Get signal icon based on RSSI
  IconData getSignalIcon() {
    if (rssi.value >= -50) {
      return Icons.signal_wifi_4_bar;
    } else if (rssi.value >= -70) {
      return Icons.network_wifi_3_bar;
    } else if (rssi.value >= -85) {
      return Icons.network_wifi_2_bar;
    } else {
      return Icons.network_wifi_1_bar;
    }
  }
  
  /// Get signal color based on RSSI
  Color getSignalColor() {
    if (rssi.value >= -50) {
      return Colors.green;
    } else if (rssi.value >= -70) {
      return Colors.amber;
    } else if (rssi.value >= -85) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}