import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/pages/signup.dart';
import 'package:ubts_fyp/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'UBTS',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
          ),
        ),
        centerTitle: true,
      ),
      body: Animate(
        effects: const [
          ScaleEffect(
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
              curve: Curves.easeOutCubic,
              begin: Offset(0, 0)),
        ],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 72,
                ),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Login to continue',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        // fontSize: 20,
                      ),
                ),
                const SizedBox(
                  height: 72,
                ),
                LoginForm(
                  onClickLogin: () {},
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Don\'t have an account? Create now!',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
