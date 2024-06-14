import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:voltican_fitness/screens/role_screen.dart';

import 'package:http/http.dart' as http;

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
  var _enteredUsername = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredFullName = '';

  // void _goToRole(BuildContext ctx) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (ctx) => const RoleScreen()));
  // }

  void _submit(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final url = Uri.parse('http://ec2-13-51-254-117.eu-north-1.compute.amazonaws.com/api/v1/auth/register');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _enteredFullName,
            'email': _enteredEmail,
            'password': _enteredPassword,
            'username': _enteredUsername
          }));
          print(response);
     if(!mount) return;
     Navigator.of(context).push(MaterialPageRoute(builder:(context)=> const  RoleScreen());
    }
  }

  void _goToLogin(BuildContext ctx) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const LoginScreen()));
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
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Create your account ',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
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
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Full Name',
                      style:
                          TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFBFBFBF)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFBFBFBF)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredFullName = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Username',
                      style:
                          TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter a username',
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFBFBFBF)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFBFBFBF)),
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Email address',
                      style:
                          TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFBFBFBF)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFFBFBFBF)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Enter a password',
                      style:
                          TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                    ),
                    TextFormField(
                      obscureText: true,
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
                        suffixIcon: const Icon(Icons.visibility_off),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.length < 6) {
                          return "Password must be more than 6 characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredPassword = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: (){
                        _submit(context);
                      },
                      // onTap: () {
                      //   _goToRole(context);
                      // },

                      child: const ButtonWidget(
                          backColor: Colors.red,
                          text: 'Signup',
                          textColor: Colors.white),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const OrDividerWidget(),
            const SizedBox(height: 20),
            // ButtonWithIconWidget(
            //     backColor: Colors.white,
            //     text: 'Continue with Google',
            //     textColor: Colors.black,
            //     svgData: "assets/images/google.svg",
            //     goToRole: () {}),
            // const SizedBox(height: 10),
            // ButtonWithIconWidget(
            //   backColor: Colors.white,
            //   text: 'Continue with Facebook',
            //   textColor: Colors.black,
            //   svgData: "assets/images/facebook.svg",
            //   goToRole: () {},
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already a user?',
                ),
                const SizedBox(width: 0),
                TextButton(
                    onPressed: () {
                      _goToLogin(context);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
