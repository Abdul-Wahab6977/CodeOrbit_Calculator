import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/calculator_controller.dart';
import 'screens/calculator_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const CalculatorApp());
}

/// App root. Wires up the [CalculatorController] via Provider and
/// configures adaptable light/dark Material 3 themes.
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorController(),
      child: MaterialApp(
        title: 'Calculator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system, // Adapts to the device's setting.
        home: const CalculatorScreen(),
      ),
    );
  }
}
