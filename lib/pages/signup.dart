import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  initState() {
    super.initState();
    registerFirstVisit();
  }

  Future<void> registerFirstVisit() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('hasVisited', true);
  }

  // gets data from signup form page
  Future<void> _getSignupFormData(Map<UserData, String> formData) async {
    signUpData = {...formData};

    setState(() {
      activeFormIndex = 1;
    });
  } // end _getSignupFormData

  void _selectRoute(String route) {
    signUpData[UserData.busRoute] = route;
    setState(() {
      activeFormIndex = 2;
    });
  } // end _selectRoute

  void _selectStop(String busStop) async {
    signUpData[UserData.busStop] = busStop;
    await _createStudentAccount();
  } // end _selectStop

  Future<void> _createStudentAccount() async {
    try {
      // create firebase auth account
      User? user = await AuthService().createUserWithEmailAndPassword(
        email: signUpData[UserData.email]!,
        password: signUpData[UserData.password]!,
      );

      signUpData[UserData.userId] = user!.uid;
      signUpData.remove(UserData.password);

      // data sent to firestore db
      final data = {
        'fullName': signUpData[UserData.fullName],
        'email': signUpData[UserData.email],
        'studentId': signUpData[UserData.studentId],
        'isApproved': 'false',
        'busRoute': signUpData[UserData.busRoute],
        'busStop': signUpData[UserData.busStop],
        'userType': 'user',
      };

      // save user data in user collection in firestore
      await FirestoreService().addUserData(
        id: signUpData[UserData.userId]!,
        userData: data,
      );

      // save user data in local storage
      await PersistantStorage().persistUserData(signUpData);

      // now push accounted creation successfull page
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const SuccessPage(),
        ),
      );

      // below error handling
    } catch (err) {
      if (!mounted) return;
      CustomSnackBarBuilder().showCustomSnackBar(
        context,
        snackBarType: CustomSnackbar.error,
        text: 'Error id: Signup-90 \n$err ',
      );
    }
  } // end _createStudentAccount

  @override
  Widget build(BuildContext context) {
    Widget content = SignupForm(
      onClickSignup: _getSignupFormData,
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
