import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/driver/driver_home.dart';
import 'package:ubts_fyp/pages/user/home.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/services/persistant_storage.dart';
import 'package:ubts_fyp/services/user_db.dart';
import 'package:ubts_fyp/widgets/common/custom_snackbar.dart';
import 'package:ubts_fyp/widgets/common/text_field.dart';
import 'package:ubts_fyp/widgets/common/wide_button.dart';
// import 'package:ubts/pages/home.dart';
// import 'package:ubts/services/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onClickLogin,
  });

  final Function onClickLogin;

  @override
  State<LoginForm> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _password = '';
  Map<UserData, String> _userData = {};

  bool _isLoading = false;

  void _submitForm() async {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      await _signInWithEmailAndPassword();
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    await AuthService().signOut();
    try {
      setState(() {
        _isLoading = true;
      });
      User? user = await AuthService().signInWithEmailAndPassword(
        email: _userName,
        password: _password,
      );

      if (user != null) {
        var response = await FirestoreService().getUserData(
          db: 'users',
          userId: user.uid,
        );

        // if data isn't found users collection, try in drivers
        if (response != null) {
          _userData = {
            UserData.userId: user.uid,
            UserData.userType: 'user',
            UserData.fullName: response["fullName"] ?? 'null',
            UserData.email: response["email"] ?? 'null',
            UserData.isApproved: response["isApproved"] ?? 'null',
            UserData.studentId: response["studentId"] ?? 'null',
            UserData.busRoute: response["busRoute"] ?? 'null',
            UserData.busStop: response["busStop"] ?? 'null',
          };
        } else {
          response = await FirestoreService().getUserData(
            db: 'drivers',
            userId: user.uid,
          );

          log('******************************');
          log(user.uid);
          log(response.toString());

          // acc isn't in drivers collec throw error
          if (response == null) {
            await AuthService().currentUser?.delete();
            throw 'The user doesn\'t exist';
          }

          // else if found
          _userData = {
            UserData.userId: user.uid,
            UserData.userType: 'driver',
            UserData.fullName: response["name"] ?? 'null',
            UserData.email: response["email"] ?? 'null',
            UserData.studentId: response["phone"] ?? 'null',
          };
        }

        await PersistantStorage().persistUserData(_userData);
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            if (_userData[UserData.userType] == 'driver') {
              return DriverHome(user: _userData);
            }
            return Home(
              user: _userData,
            );
          },
        ),
      );
    } catch (err) {
      log('err 301');
      log(err.toString());
      if (!mounted) return;
      CustomSnackBarBuilder().showCustomSnackBar(
        context,
        snackBarType: CustomSnackbar.error,
        text: err.toString(),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ---------- form related functions ----------

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  void onSaveEmail(String? value) {
    // can't be null cos we will validate form before saving
    _userName = value!;
  }

  void onSavePassword(String? value) {
    // can't be null cos we will validate form before saving
    _password = value!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            label: 'Student Id/Email',
            placeholderText: 'Enter your email or student ID',
            placeholderIcon: Icons.document_scanner_outlined,
            onSave: onSaveEmail,
            onValidation: _validateInput,
          ),
          const SizedBox(
            height: 24,
          ),
          CustomTextFormField(
            label: 'Password',
            placeholderText: 'Enter your password',
            placeholderIcon: Icons.key,
            hideText: true,
            onSave: onSavePassword,
            onValidation: _validateInput,
          ),
          const SizedBox(
            height: 72,
          ),
          WideButton(
            buttonText: 'Login',
            isLoading: _isLoading,
            onSubmitForm: _submitForm,
          ),
        ],
      ),
    );
  }
}
