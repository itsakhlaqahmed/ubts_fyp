import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ubts_fyp/models/user.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ubts_fyp/widgets/common/color_theme.dart';
import 'package:ubts_fyp/widgets/common/text_field.dart';
import 'package:ubts_fyp/widgets/common/wide_button.dart';

// AIzaSyCUccOgqZ2hXFluNq5lQMDolyt7wWFiDfs

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.onClickSignup,
  });

  final Future<void> Function(Map<UserData, String> formData) onClickSignup;

  @override
  State<StatefulWidget> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<UserData, String> _userData = {};
  bool _isLoading = false;

  void _clickSignup() {
    bool validated = _formKey.currentState!.validate();
    if (validated) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });

        widget.onClickSignup(_userData);
      } catch (err) {
        // handle error here
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  void _saveInput(
    UserData identifier,
    String? value,
  ) {
    _userData[identifier] = value!;
  }

  String? _matchPassword(String? value) {
    var password = _userData[UserData.password];
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }
    if (password!.length < 6) {
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
    _userData[UserData.password] = value ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        ScaleEffect(
            duration: Durations.medium2,
            alignment: Alignment.center,
            curve: Curves.easeOutCubic,
            begin: Offset(0, 0)),
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
                    _saveInput(UserData.fullName, value);
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
                    _saveInput(UserData.email, value);
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
                    _saveInput(UserData.studentId, value);
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
                    _saveInput(UserData.password, value);
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
                    // _saveInput(UserData.confirmPassword, value); extra field
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
                    color: ColorTheme.primaryShade1,
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
