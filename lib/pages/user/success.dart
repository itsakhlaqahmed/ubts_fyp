import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/pages/user/home.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';
import 'package:ubts_fyp/widgets/common/wide_button.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Animate(
          effects: const [
            SlideEffect(
              duration: Duration(milliseconds: 200),
              begin: Offset(3, 0),
              curve: Curves.easeOutCubic,
            )
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/congrats animation.gif',
                      colorBlendMode: BlendMode.multiply,
                      height: 400,
                      width: 400,
                    ),
                    Image.asset(
                      'assets/sucess.png',
                      fit: BoxFit.cover,
                      height: 400,
                      // width: 300,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 48,
                ),
                Text(
                  'Congratulations! 🎉',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorTheme.primary,
                      ),
                ),
                const SizedBox(
                  height: 48,
                ),
                const Text(
                  'Application submitted!\nYou\'ll be notified soon.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                WideButton(
                    onSubmitForm: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    },
                    buttonText: 'Continue to app...')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
