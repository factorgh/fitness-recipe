import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:voltican_fitness/Features/auth/domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  AuthBloc({required SignUpUseCase signUpUseCase})
      : _signUpUseCase = signUpUseCase,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) {
      _signUpUseCase(UserSignUpParams(
          fullName: event.fullName,
          username: event.username,
          email: event.email,
          password: event.password));
    });
  }
}
