part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String fullName;

  const AuthSignUp(this.email, this.password, this.username, this.fullName);

  @override
  List<Object> get props => [email, password];
}

final class AuthLogin extends AuthEvent {
  final String password;
  final String username;

  const AuthLogin(
    this.password,
    this.username,
  );

  @override
  List<Object> get props => [username, password];
}
