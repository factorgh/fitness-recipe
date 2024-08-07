// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voltican_fitness/screens/role_screen.dart';
import 'package:voltican_fitness/Features/auth/presentation/widgets/button.dart';
import 'package:voltican_fitness/Features/auth/presentation/widgets/or_divider.dart';
import 'package:voltican_fitness/Features/auth/presentation/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredUsername = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredFullName = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _submit(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final url =
            Uri.parse('https://fitness.adroit360.com/api/v1/auth/register');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _enteredFullName,
            'email': _enteredEmail,
            'password': _enteredPassword,
            'username': _enteredUsername,
          }),
        );

        // Get token from response body
        final token = json.decode(response.body)['token'];

        // Save user token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', token);

        if (response.statusCode == 200) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RoleScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup failed. Please try again.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _goToLogin(BuildContext ctx) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Enter your details to continue',
                style: TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    _buildTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      onSaved: (value) => _enteredFullName = value!,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Please enter your full name"
                              : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Username',
                      hint: 'Enter a username',
                      onSaved: (value) => _enteredUsername = value!,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Please enter a username"
                              : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Email address',
                      hint: 'Enter your email address',
                      onSaved: (value) => _enteredEmail = value!,
                      validator: (value) => value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')
                          ? "Please enter a valid email"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Enter a password',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 22, 19, 19)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFBFBFBF)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) => value == null ||
                              value.trim().isEmpty ||
                              value.length < 6
                          ? "Password must be more than 6 characters"
                          : null,
                      onSaved: (value) => _enteredPassword = value!,
                    ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const RoleScreen()),
                          );
                        },
                        child: const ButtonWidget(
                          backColor: Colors.red,
                          text: 'Signup',
                          textColor: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const OrDividerWidget(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a user?'),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _goToLogin(context),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFBFBFBF)),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFBFBFBF)),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
