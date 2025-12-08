import 'package:flutter/material.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const SmartCalcApp());
}

class SmartCalcApp extends StatelessWidget {
  const SmartCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCalc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}