import 'package:flutter/material.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:voltican_fitness/widgets/button.dart';
import 'package:voltican_fitness/widgets/or_divider.dart';
import 'package:voltican_fitness/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

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

  void signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await authService.signup(
          context: context,
          fullName: _fullNameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } catch (e) {
        // Handle signup error here (e.g., show a snackbar)
        showSnack(context, 'Signup failed: $e');
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
                    _isLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: signup,
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
