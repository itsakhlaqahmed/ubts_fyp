import 'package:flutter/material.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Center(
          child: Image.asset(
            'assets/welcome_banner.png',
            // height: 60,
            width: 200,
          ),
        ),
      ),
    );
  }
}
