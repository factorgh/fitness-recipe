import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voltican_fitness/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voltican_fitness/core/error/common/Loader.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:voltican_fitness/widgets/button.dart';
import 'package:voltican_fitness/widgets/or_divider.dart';
import 'package:voltican_fitness/Features/auth/presentation/pages/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool _isPasswordVisible = false;

  void _goToLogin(BuildContext ctx) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                          controller: _fullNameController,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? "Please enter your full name"
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Username',
                          hint: 'Enter a username',
                          controller: _usernameController,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? "Please enter a username"
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Email address',
                          hint: 'Enter your email address',
                          controller: _emailController,
                          validator: (value) => value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')
                              ? "Please enter a valid email"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
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
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    AuthSignUp(
                                      _emailController.text,
                                      _passwordController.text,
                                      _usernameController.text,
                                      _fullNameController.text,
                                    ),
                                  );
                            }
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
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
          controller: controller,
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
        ),
      ],
    );
  }
}
