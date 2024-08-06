import 'package:flutter/material.dart';
import 'package:ubts_fyp/pages/home.dart';
import 'package:ubts_fyp/widgets/wide_button.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      color: const Color.fromARGB(255, 253, 129, 59),
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
    );
  }
}
