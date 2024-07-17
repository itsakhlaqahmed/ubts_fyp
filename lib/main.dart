import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/pages/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // handle erro
  }
  runApp(const MainApp());
}

var lightTheme = ThemeData.light().colorScheme.copyWith();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // final colorTheme = ThemeData(textTheme: );

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Onboarding(),
    );
  }
}
