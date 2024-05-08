part of 'authorization_bloc.dart';

abstract class AuthorizationEvent extends Equatable {
  const AuthorizationEvent();

  @override
  List<Object> get props => [];
}

class Login extends AuthorizationEvent {
  final String email;
  final String password;

  const Login({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class Logout extends AuthorizationEvent {}

class Register extends AuthorizationEvent {
  final String email;
  final String password;

  const Register({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
