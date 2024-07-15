import 'package:flutter/material.dart';
import 'package:ubts_fyp/pages/home.dart';
import 'package:ubts_fyp/pages/onboarding_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final List<Map<String, String>> screenData = [
    {
      'title': 'Effortless Bus Tracking',
      'description':
          'Easily track your university bus in real-time with just a few taps.',
      'image': 'assets/onboarding1.png',
    },
    {
      'title': 'Get Driver Detail',
      'description':
          'Instantly access driver information for a smooth journey.',
      'image': 'assets/onboarding2.png',
    },
    {
      'title': 'Secure Information',
      'description': 'Your data is safe and secure with us.',
      'image': 'assets/onboarding3.png',
    },
  ];

  int _activePageIndex = 0;
  late PageController _pagecontroller;

  @override
  void initState() {
    _pagecontroller = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pagecontroller.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_activePageIndex >= screenData.length - 1) {
      navigateToHome();
    }

    _pagecontroller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.bounceIn,
    );
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pagecontroller,
      onPageChanged: (index) {
        setState(() {
          _activePageIndex = index;
        });
      },
      itemCount: 3,
      itemBuilder: (BuildContext ctx, index) {
        return OnboardingScreen(
          data: screenData[index],
          activePageIndex: _activePageIndex,
          totalScreens: screenData.length,
          onClickNext: nextPage,
          onSkip: navigateToHome,
        );
      },
    );
  }
}
