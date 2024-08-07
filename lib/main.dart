import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voltican_fitness/Features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:voltican_fitness/Features/auth/data/repositories/auth_repo_impl.dart';
import 'package:voltican_fitness/Features/auth/domain/usecases/signup_usecase.dart';
import 'package:voltican_fitness/Features/auth/presentation/bloc/auth_bloc.dart';

import 'package:voltican_fitness/screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    runApp(MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => AuthBloc(
          signUpUseCase: SignUpUseCase(
            AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            ),
          ),
        ),
      )
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
