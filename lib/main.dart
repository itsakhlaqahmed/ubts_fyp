import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ubts_fyp/pages/user/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // print("******* $firebase *******");
  } catch (e) {
    // handle erro
    // print('error');
  }
  FlutterNativeSplash.remove();
  runApp(const MainApp());
}

var lightTheme = ThemeData.light().colorScheme.copyWith(
      primary: ColorTheme.primaryTint1,
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
      // home: const DriverMapScreen(userData: {}, busId: ''),
      home: const Onboarding(),
    );
  }
}
