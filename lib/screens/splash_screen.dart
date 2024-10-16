import 'dart:async';

import 'package:fit_cibus/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFB3B3),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100))),
          child: const Center(
            child: Text(
              "FitCibus",
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();

    // Timer to delay the navigation
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const OnboardingScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
          (route) => false,
        );
      }
    });
  }
}
