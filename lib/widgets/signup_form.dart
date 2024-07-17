import 'package:flutter/material.dart';
import 'package:ubts_fyp/pages/login.dart';
import 'package:ubts_fyp/services/auth_service.dart';

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
              Text(
                'Fullname',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                autocorrect: false,
                onSaved: (value) {
                  _fullName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  label: const Row(
                    children: [
                      Icon(Icons.person_outline),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Enter your full name',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Email',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                autocorrect: false,
                onSaved: (value) {
                  _email = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  label: const Row(
                    children: [
                      Icon(Icons.mail_outline),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Enter your email address',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Student ID',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                autocorrect: false,
                onSaved: (value) {
                  _studentId = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  label: const Row(
                    children: [
                      Icon(Icons.document_scanner_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Enter your student ID',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Password',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) {
                  _password = value;
                },
                onSaved: (value) {
                  _password = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  label: const Row(
                    children: [
                      Icon(Icons.key),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Enter your password',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Confirm Password',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onSaved: (value) {
                  _confirmPassword = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required.';
                  }
                  if (value != _password) {
                    return 'Password doesn\'t match or Password is too small (min 6 char)';
                  }
                  if (_password.length < 6) {
                    return 'Password is too small (min 6 char)';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  label: const Row(
                    children: [
                      Icon(Icons.key),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Re-enter your password',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
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
