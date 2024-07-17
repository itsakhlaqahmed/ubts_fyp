import 'package:flutter/material.dart';
import 'package:ubts_fyp/widgets/bus_route.dart';
import 'package:ubts_fyp/widgets/bus_stop.dart';
import 'package:ubts_fyp/widgets/signup_form.dart';
import 'package:ubts_fyp/models/bus_stop.dart';
import 'package:ubts_fyp/models/bus_route.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/firestore_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Map<String, String> signupData = {};
  int activeFormIndex = 0;
  String? _userId;

  var busStops = [
    BusStop(from: 'Baldia Town', to: 'Steel Town'),
    BusStop(from: 'Baldia Town', to: 'Steel Town'),
    BusStop(from: 'Baldia Town', to: 'Steel Town'),
    BusStop(from: 'Baldia Town', to: 'Steel Town'),
  ];

  void _clickSignup(Map<String, String> formData) async {
    signupData = {
      ...formData,
    };

    setState(() {
      activeFormIndex = 1;
    });

  }

  void _selectRoute(String route) {
    signupData = {
      ...signupData,
      'route': route,
    };
    setState(() {
      activeFormIndex = 2;
    });
  }

  void _selectStop(String busStop) {
    signupData = {
      ...signupData,
      'busStop': busStop,
    };
    setState(() {
      activeFormIndex = 3;
    });

    // _saveUserData();
  }

  // Future<void> _saveUserData() async {}

  // Future<void> _createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     await AuthService().createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     _userId = AuthService().currentUser?.uid;
  //   } catch (err) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).clearSnackBars();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           err.toString(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Widget content = SignupForm(
      onClickSignup: _clickSignup,
    );

    switch (activeFormIndex) {
      case 0:
        break;
      case 1:
        content = BusRoutePanel(
          onSelectRoute: _selectRoute,
        );
        break;
      case 2:
        content = BusStopPanel(
          busStops: busStops,
          onSelectBusStop: _selectStop,
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              setState(() {
                if (activeFormIndex > 0) {
                  activeFormIndex -= 1;
                }
              });
            },
            icon: const Icon(Icons.arrow_back)),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'UBTS',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                content,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
