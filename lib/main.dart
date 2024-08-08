import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voltican_fitness/Features/auth/presentation/bloc/auth_bloc.dart';

import 'package:voltican_fitness/init_dependencies.dart';
import 'package:voltican_fitness/recipe_inject_container.dart';

import 'package:voltican_fitness/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await initRecipe();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    runApp(MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
    ], child: const MyApp()));
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
