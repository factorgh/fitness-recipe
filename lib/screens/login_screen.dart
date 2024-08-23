// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/screens/signup_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/utils/native_alert.dart';
import 'package:voltican_fitness/widgets/button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final NativeAlerts alerts = NativeAlerts();

  bool _passwordVisible = false;
  bool _isLoading = false; // New: To manage loading state

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _goToSignup(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (ctx) => const SignupScreen()),
    );
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await authService.signIn(
          context: context,
          ref: ref, // Use ref from the state
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );
        alerts.showSuccessAlert(context, "LoggedIn successfully");
      } catch (e) {
        // Handle the error, e.g., show a snackbar or dialog with the error message
        alerts.showErrorAlert(context,
            'Login failed: Please check your credentials and try again');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Fitness Recipe',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign in to your account',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Enter your details to continue',
                    style: TextStyle(
                      color: Color.fromARGB(255, 133, 132, 132),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter username',
                          style: TextStyle(
                            color: Color.fromARGB(255, 133, 132, 132),
                          ),
                        ),
                        const SizedBox(height: 3),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Enter a username',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFBFBFBF),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFBFBFBF),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter a username";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Enter a password',
                          style: TextStyle(
                            color: Color.fromARGB(255, 133, 132, 132),
                          ),
                        ),
                        const SizedBox(height: 3),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Enter a password',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 22, 19, 19),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFBFBFBF),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < 6) {
                              return "Password must be more than 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: _isLoading
                        ? null
                        : () => _login(context), // Only pass context here
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.red,
                          )
                        : ButtonWidget(
                            backColor: _isLoading ? Colors.grey : Colors.red,
                            text: _isLoading ? 'Logging in...' : 'Login',
                            textColor: Colors.white,
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('First time here?'),
                      TextButton(
                        onPressed: () => _goToSignup(context),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
