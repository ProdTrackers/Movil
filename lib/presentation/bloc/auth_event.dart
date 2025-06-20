part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupButtonPressed extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const SignupButtonPressed({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password];
}

class LogoutButtonPressed extends AuthEvent {}