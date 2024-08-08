import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voltican_fitness/Features/auth/presentation/bloc/auth_bloc.dart';

import 'package:voltican_fitness/Features/auth/presentation/pages/signup_screen.dart';
import 'package:voltican_fitness/core/error/common/Loader.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';

import 'package:voltican_fitness/widgets/button.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();

    super.dispose();
  }

  void _goToSignup(BuildContext ctx) {
    Navigator.of(ctx)
        .push(MaterialPageRoute(builder: (ctx) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnack(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: MyLoader());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 120),
                      const Text(
                        'Welcome to Fitness Recipe',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Sign in to your account',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Enter your details to continue',
                        style: TextStyle(
                            color: Color.fromARGB(255, 133, 132, 132)),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enter username',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 133, 132, 132)),
                            ),
                            const SizedBox(height: 3),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: 'Enter a username',
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFBFBFBF)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFBFBFBF)),
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
                                  color: Color.fromARGB(255, 133, 132, 132)),
                            ),
                            const SizedBox(height: 3),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                hintText: 'Enter a password',
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 22, 19, 19)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFBFBFBF)),
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
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthLogin(
                                _passwordController.text.trim(),
                                _usernameController.text.trim()));
                          }
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (ctx) => const TabsScreen(userRole: 1)));
                        },
                        child: const ButtonWidget(
                            backColor: Colors.red,
                            text: 'Login',
                            textColor: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('First time here?'),
                          const SizedBox(width: 0),
                          TextButton(
                              onPressed: () => _goToSignup(context),
                              child: const Text(
                                "SignUp",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
