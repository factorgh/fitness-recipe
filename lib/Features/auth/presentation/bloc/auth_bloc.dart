import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:voltican_fitness/Features/auth/domain/usecases/login_usecase.dart';

import 'package:voltican_fitness/Features/auth/domain/usecases/signup_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LoginUseCase _loginUseCase;
  // final CurrentUserUsecase _currentUserUsecase;
  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required LoginUseCase loginUseCase,
    // required CurrentUserUsecase currentUserUseCase
  })  : _signUpUseCase = signUpUseCase,
        _loginUseCase = loginUseCase,
        // _currentUserUsecase = currentUserUseCase,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final res = await _signUpUseCase(UserSignUpParams(
          fullName: event.fullName,
          username: event.username,
          email: event.email,
          password: event.password));

      // Check if the signup was successful
      res.fold((l) => emit(AuthFailure(errorMessage: l.message)),
          (r) => emit(AuthSuccess(userId: r.id)));
    });

    // Auth login bloc
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      final res = await _loginUseCase(
        UserLoginParams(username: event.username, password: event.password),
      );
      // Check if the signup was successful
      res.fold((l) => emit(AuthFailure(errorMessage: l.message)),
          (r) => emit(AuthSuccess(userId: r.id)));
    });
    // on<IsUserLoggedIn>((event, emit) async {
    //   emit(AuthLoading());
    //   final res = await _currentUserUsecase(CurrentParams(event.userId));

    //   // Check if the signup was successful
    //   res.fold((l) => emit(AuthFailure(errorMessage: l.message)),
    //       (r) => emit(AuthSuccess(userId: r.id)));
    // });
  }
}
