import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const TyreInflatorApp());
}

class TyreInflatorApp extends StatelessWidget {
  const TyreInflatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tyre Inflator',
      theme: AppTheme.appTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
