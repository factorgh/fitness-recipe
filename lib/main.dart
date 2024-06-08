import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voltican_fitness/screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: OnboardingScreen());
  }
}
