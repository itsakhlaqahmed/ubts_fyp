import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ubts_fyp/pages/home.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/pages/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    var a = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("**********" + a.toString());
  } catch (e) {
    // handle erro
    print('error');
  }
  runApp(const MainApp());
}

var lightTheme = ThemeData.light().colorScheme.copyWith(
      primary: const Color(0xFFFD813B),
    );

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // final colorTheme = ThemeData(textTheme: );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.getTextTheme('Poppins'),
        colorScheme: lightTheme,
      ),
      home: const Onboarding(),
    );
  }
}
