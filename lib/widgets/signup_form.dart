import 'package:flutter/material.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/services/auth_service.dart';
import 'package:ubts_fyp/widgets/text_field.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.onClickSignup,
  });

  final Function(Map<String, String> formData) onClickSignup;

  @override
  State<StatefulWidget> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _studentId = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;

  Map<String, String> formData = {};

  Future<void> _clickSignup() async {
    bool validated = _formKey.currentState!.validate();
    if (validated) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        final user = await AuthService().createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        widget.onClickSignup({
          'fullname': _fullName,
          'email': _email,
          'studentId': _studentId,
          'password': _password,
        });

        if (user != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully'),
            ),
          );
        }
      } catch (err) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
          ),
        );
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

  void _saveInput(String? value) {}
  String? _matchPassword(value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }
    if (_password.length < 6) {
      return 'Password is too small (min 6 char)';
    }
    if (value != _password) {
      return 'Password doesn\'t match or Password is too small (min 6 char)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  onSave: _saveInput,
                  onValidation: _validateInput),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                  label: 'Email',
                  placeholderText: 'Enter your email address',
                  placeholderIcon: Icons.mail_outline,
                  onSave: _saveInput,
                  onValidation: _validateInput),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                  label: 'Student Id',
                  placeholderText: 'Enter your student ID',
                  placeholderIcon: Icons.document_scanner_outlined,
                  onSave: _saveInput,
                  onValidation: _validateInput),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                  label: 'Passowrd',
                  placeholderText: 'Enter password',
                  placeholderIcon: Icons.key_outlined,
                  onSave: _saveInput,
                  onValidation: _validateInput),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                label: 'Confirm Password',
                placeholderText: 'Re-enter password',
                placeholderIcon: Icons.key_outlined,
                onSave: _matchPassword,
                onValidation: _validateInput,
              ),
              const SizedBox(
                height: 36,
              ),
              GestureDetector(
                onTap: () {
                  _isLoading ? null : _clickSignup();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 117, 75, 243),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Signup',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                  ),
                ),
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
    );
  }
}
