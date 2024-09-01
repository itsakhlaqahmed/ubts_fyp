import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/driver/driver_home.dart';
import 'package:ubts_fyp/pages/home.dart';
import 'package:ubts_fyp/pages/signup.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/widgets/login/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  initState() {
    isAuth();
    super.initState();
  }

  Future<void> isAuth() async {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    var user = AuthService().currentUser;

    final localData = await PersistantStorage().fetchLocalUser();

    if (user != null && localData[UserData.userType] != null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) {
            return localData[UserData.userType] == 'driver'
                ? const DriverHome()
                : const Home();
          },
        ),
      );
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'UBTS',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                  color: const Color.fromARGB(255, 253, 129, 59),
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
            child: SingleChildScrollView(
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
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
