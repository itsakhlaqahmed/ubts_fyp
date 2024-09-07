import 'package:flutter/material.dart';

class ColorTheme {
  // primary
  static Color primary = const Color.fromARGB(255, 1, 117, 97);
  static Color primaryShade1 = const Color.fromARGB(255, 1, 97, 81);
  static Color primaryTint1 = Color.fromARGB(255, 0, 168, 140);
  static Color primaryDisabled = Colors.black;
  static Color onPrimaryText = Colors.white;

  //secondary color
  static Color secondary = Colors.black;
  static Color onSecondaryText = Colors.white;

  static Color primaryWithOpacity(int opacity) {
    return Color.fromARGB(opacity, 1, 117, 97);
  }

  static Color secondaryWithOpacity(int opacity) {
    return Color.fromARGB(255, 253, 129, opacity);
  }
}
