// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/home_page.dart';
import 'screens/ble_connection_page.dart'; // Add this import
import 'core/app_theme.dart';
import 'services/ble_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize GetStorage
    await GetStorage.init();
  } catch (e) {
    print("GetStorage initialization error: $e");
  }

  runApp(const TyreInflatorApp());
}

class TyreInflatorApp extends StatelessWidget {
  const TyreInflatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tyre Inflator',
      theme: AppTheme.appTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      getPages: [
        // Add named routes here
        GetPage(
          name: '/',
          page: () => const HomePage(),
        ),
        GetPage(
          name: '/ble-connection',
          page: () => const BleConnectionPage(),
        ),
        // Add other pages/routes here as needed
      ],
    );
  }
}