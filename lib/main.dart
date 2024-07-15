import 'package:flutter/material.dart';
import 'package:ubts_fyp/pages/onboarding.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Onboarding(),
    );
  }
}
