import 'package:flutter/material.dart';
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
    // if (isValid) {
    //   _formKey.currentState!.save();
    //   _signInWithEmailAndPassword();
    // }
  }

  // Future<void> _signInWithEmailAndPassword() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await AuthService().signInWithEmailAnsPassword(
  //       email: _userName,
  //       password: _password,
  //     );
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => const Home(),
  //       ),
  //     );
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

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

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
          CustomTextField(
            label: 'Student Id/Email',
            placeholderText: 'Enter your email or student ID',
            placeholderIcon: Icons.document_scanner_outlined,
            onSave: onSaveEmail,
            onValidation: _validateInput,
          ),
          const SizedBox(
            height: 24,
          ),
          CustomTextField(
            label: 'Password',
            placeholderText: 'Enter your password',
            placeholderIcon: Icons.key,
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
