import 'package:flutter/material.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/success.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/widgets/bus_route.dart';
import 'package:ubts_fyp/widgets/bus_stop.dart';
import 'package:ubts_fyp/widgets/custom_snackbar.dart';
import 'package:ubts_fyp/widgets/signup_form.dart';
import 'package:ubts_fyp/models/bus_stop.dart';
import 'package:ubts_fyp/services/user_db.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Map<UserData, String> signUpData = {
    UserData.userType: 'user',
  };
  int activeFormIndex = 0;

  var busStops = const [
    BusStop(from: 'Baldia Town', to: 'Steel Town'),
    BusStop(from: 'Korangi ', to: 'Landhi'),
    BusStop(from: 'Saddar Town', to: 'Nazimabad'),
    BusStop(from: 'Baldia Town', to: 'Steel'),
  ];

  Future<bool?> _clickCreateAccount(Map<UserData, String> formData) async {
    signUpData = {
      ...formData,
      UserData.isApproved: 'false',
    };

    final user = await AuthService().createUserWithEmailAndPassword(
      email: formData[UserData.email]!,
      password: formData[UserData.password]!,
    );

    signUpData.remove(UserData.password);

    if (user != null) {
      signUpData[UserData.userId] = user.uid;

      setState(() {
        activeFormIndex = 1;
      });
      return true;
    }

    return null;
  } // end _clickCreateAccount

  void _selectRoute(String route) {
    signUpData[UserData.busRoute] = route;
    setState(() {
      activeFormIndex = 2;
    });
  } // end _selectRoute

  void _selectStop(String busStop) async {
    signUpData[UserData.busStop] = busStop;

    try {
      // _saveUserData();
      if (!mounted) return;
      CustomSnackBarBuilder().showCustomSnackBar(
        context,
        snackBarType: CustomSnackbar.success,
        text: 'Success',
      );

      await PersistantStorage().persistUserData(signUpData);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const SuccessPage(),
        ),
      );
    } catch (err) {
      CustomSnackBarBuilder().showCustomSnackBar(
        context,
        snackBarType: CustomSnackbar.error,
        text: 'Error id: Signup-90 \n$err ',
      );
    }
  } // end _selectStop

  Future<void> _saveUserData() async {
    Map<String, dynamic> data = {
      'fullName': signUpData[UserData.fullName],
      'email': signUpData[UserData.email],
      'studentId': signUpData[UserData.studentId],
      'busRoute': signUpData[UserData.busRoute],
      'busStop': signUpData[UserData.busStop],
      'isApproved': 'false',
      'userType': signUpData[UserData.userType]
    };

    await FirestoreService().addUserData(
      id: signUpData[UserData.userId]!,
      userData: data,
    );
  } // end _saveUserData

  @override
  Widget build(BuildContext context) {
    Widget content = SignupForm(
      onClickSignup: _clickCreateAccount,
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
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                  color: const Color.fromARGB(255, 253, 129, 59),
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
