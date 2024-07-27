import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubts_fyp/pages/home.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/widgets/custom_snackbar.dart';
import 'package:ubts_fyp/widgets/text_field.dart';
import 'package:ubts_fyp/widgets/wide_button.dart';
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
  bool _isLoading = false;

  void _submitForm() {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      _signInWithEmailAndPassword();
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      User? user = 
      await AuthService().signInWithEmailAndPassword(
        email: _userName,
        password: _password,
      );

      

      if (!mounted) return;
      CustomSnackBarBuilder().showCustomSnackBar(
        context,
        snackBarType: CustomSnackbar.success,
        text: 'You have been logged in successfully',
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } catch (err) {
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
