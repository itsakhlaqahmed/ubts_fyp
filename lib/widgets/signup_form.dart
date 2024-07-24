import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/widgets/custom_snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ubts_fyp/widgets/text_field.dart';
import 'package:ubts_fyp/widgets/wide_button.dart';

// AIzaSyCUccOgqZ2hXFluNq5lQMDolyt7wWFiDfs

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.onClickSignup,
  });

  final Function(Map<User, String> formData) onClickSignup;

  @override
  State<StatefulWidget> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  Map<User, String> _userData = {};
  bool _isLoading = false;

  Future<void> _clickSignup() async {
    // bool validated = _formKey.currentState!.validate();
    // if (validated) {
    //   _formKey.currentState!.save();
    //   try {
    //     setState(() {
    //       _isLoading = true;
    //     });
    //     final user = await AuthService().createUserWithEmailAndPassword(
    //       email: _userData[User.email]!,
    //       password: _userData[User.password]!,
    //     );

    widget.onClickSignup(_userData);

    //     if (user != null) {
    //       if (!mounted) return;
    //       CustomSnackBarBuilder().showCustomSnackBar(
    //         context,
    //         snackBarType: CustomSnackbar.success,
    //         text: 'Account created successfully...',
    //       );
    //     }
    //   } catch (err) {
    //     if (!mounted) return;
    //     CustomSnackBarBuilder().showCustomSnackBar(
    //       context,
    //       snackBarType: CustomSnackbar.error,
    //       text: err.toString(),
    //     );
    //   }

    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  void _saveInput(
    User identifier,
    String? value,
  ) {
    _userData[identifier] = value!;
  }

  String? _matchPassword(String? value) {
    var password = _userData[User.password]!;
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }
    if (password.length < 6) {
      return 'Password is too small (min 6 char)';
    }
    if (value != password) {
      return 'Password doesn\'t match or Password is too small (min 6 char)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _onPasswordChange(String? value) {
    _userData[User.password] = value ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Durations.short3),
        ScaleEffect(
            duration: Durations.short4,
            alignment: Alignment.center,
            curve: Curves.easeOutCubic,
            begin: Offset(.5, .5)),
      ],
      child: Column(
        children: [
          const SizedBox(
            height: 36,
          ),
          const Text(
            'Please fill out the form below to apply for bus assignment.',
          ),
          const SizedBox(
            height: 24,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  label: 'FullName',
                  placeholderText: 'Enter your Full Name',
                  placeholderIcon: Icons.person_outline,
                  onSave: (value) {
                    _saveInput(User.fullName, value);
                  },
                  onValidation: _validateInput,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  label: 'Email',
                  placeholderText: 'Enter your email address',
                  placeholderIcon: Icons.mail_outline,
                  onSave: (value) {
                    _saveInput(User.email, value);
                  },
                  onValidation: _validateEmail,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  label: 'Student Id',
                  placeholderText: 'Enter your student ID',
                  placeholderIcon: Icons.document_scanner_outlined,
                  onSave: (value) {
                    _saveInput(User.studentId, value);
                  },
                  onValidation: _validateInput,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  label: 'Password',
                  placeholderText: 'Enter password',
                  placeholderIcon: Icons.key_outlined,
                  hideText: true,
                  onChanged: _onPasswordChange,
                  onSave: (value) {
                    _saveInput(User.password, value);
                  },
                  onValidation: _validateInput,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  label: 'Confirm Password',
                  placeholderText: 'Re-enter password',
                  placeholderIcon: Icons.key_outlined,
                  hideText: true,
                  onSave: (value) {
                    // _saveInput(User.confirmPassword, value); extra field
                  },
                  onValidation: _matchPassword,
                ),
                const SizedBox(
                  height: 36,
                ),
                WideButton(
                  onSubmitForm: _clickSignup,
                  buttonText: 'Create Account',
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: Text(
              'Already have an account? Login Now',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
