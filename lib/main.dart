import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/pages/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ubts_fyp/widgets/animation_example.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    var a = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("*************************************************8" + a.toString());
  } catch (e) {
    // handle erro
    print('error');
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
      // home: AnimationExample(),
    );
  }
}
