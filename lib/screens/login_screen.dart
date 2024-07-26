import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/calendar_screen.dart';
import 'package:voltican_fitness/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:voltican_fitness/widgets/button.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredUsername = '';
  var _enteredPassword = '';
  bool _isLoading = false;
  bool _passwordVisible = false;

  void _submit(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final url = Uri.parse('https://fitness.adroit360.com/api/v1/auth/login');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
              {'password': _enteredPassword, 'username': _enteredUsername}),
        );

        print(response.body);
        // Get token from response body
        final token = json.decode(response.body)['token'];


        // Save user token to shared preferences
        final  prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', token);

        if (response.statusCode == 201) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const TabsScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToSignup(BuildContext ctx) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => const SignupScreen()));
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
              const SizedBox(height: 60),
              const Text('Welcome to Fitness Recipe',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
              const SizedBox(height: 50),
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
                style: TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Enter username',
                        style: TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                      ),
                       const SizedBox(height: 3),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter a username',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFFBFBFBF)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFFBFBFBF)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a username";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredUsername = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Enter a password',
                        style: TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                      ),
                       const SizedBox(height: 3),
                      TextFormField(
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter a password',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB(255, 22, 19, 19)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFFBFBFBF)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty || value.length < 6) {
                            return "Password must be more than 6 characters";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        InkWell(
                          onTap: () => _submit(context),
                          child: const ButtonWidget(
                              backColor: Colors.red,
                              text: 'Login',
                              textColor: Colors.white),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
