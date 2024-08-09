import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/pages/signup.dart';
import 'package:ubts_fyp/widgets/onboarding_screen.dart';
import 'package:ubts_fyp/data/onboarding_screen_data.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _activePageIndex = 0;
  late PageController _pagecontroller;
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  @override
  void initState() {
    _pagecontroller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pagecontroller.dispose();
    super.dispose();
  }

  Future<void> checkFirstVisit() async {
    final prefs = await _sharedPreferences;
    bool hasVisited = prefs.getBool('hasVisited') ?? false;

    if (hasVisited) {
      navigateToLogin();
      return;
    }
  }

  void nextPage() async {
    if (_activePageIndex >= screenData.length - 1) {
      navigateToSignup();
    }

    _pagecontroller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.bounceIn,
    );
  }

  void navigateToLogin() async {
    final prefs = await _sharedPreferences;
    prefs.setBool('hasVisited', true);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void navigateToSignup() async {
    final prefs = await _sharedPreferences;
    prefs.setBool('hasVisited', true);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkFirstVisit();
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
          key: ValueKey(index),
          data: screenData[index],
          activePageIndex: _activePageIndex,
          totalScreens: screenData.length,
          onClickNext: nextPage,
          onSkip: navigateToSignup,
        );
      },
    );
  }
}
