import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ubts_fyp/firebase_options.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/widgets/bus_route.dart';
import 'package:ubts_fyp/widgets/bus_stop.dart';
import 'package:ubts_fyp/widgets/custom_snackbar.dart';
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
  Map<User, String> signUpData = {};
  int activeFormIndex = 0;
  String? _userId;

  var busStops = const [
    BusStop(from: 'Baldia Town', to: 'Steel Town'),
    BusStop(from: 'Korangi ', to: 'Landhi'),
    BusStop(from: 'Saddar Town', to: 'Nazimabad'),
    BusStop(from: 'Baldia Town', to: 'Steel'),
  ];

  void _clickSignup(Map<User, String> formData) async {
    signUpData = {
      ...formData,
    };

    setState(() {
      activeFormIndex = 1;
    });
  }

  void _selectRoute(String route) {
    signUpData = {
      ...signUpData,
      User.busRoute: route,
    };
    setState(() {
      activeFormIndex = 2;
    });
  }

  void _selectStop(String busStop) {
    signUpData = {
      ...signUpData,
      User.busStop: busStop,
    };

    _saveUserData();
  }

  Future<void> _saveUserData() async {
    Map<String, dynamic> data = Map.fromEntries(
      signUpData.entries.map(
        (key) => MapEntry(
          key.toString(),
          key.value,
        ),
      ),
    );

    try {
    //   await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
      FirestoreService().addUserData(
        id: 'id2',
        userData: data,
      );
      CustomSnackBarBuilder().showCustomSnackBar(
        context,
        snackBarType: CustomSnackbar.success,
        text: 'Success',
      );
  var a = await FirestoreService().getUserData(
        userId: 'id2',
      );
    } catch (err) {
      CustomSnackBarBuilder().showCustomSnackBar(
        context,
        snackBarType: CustomSnackbar.error,
        text: err.toString(),
      );
    }
  }

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
        leading: activeFormIndex == 0
            ? null
            : IconButton(
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
