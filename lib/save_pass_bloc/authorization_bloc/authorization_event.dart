part of 'authorization_bloc.dart';

abstract class AuthorizationEvent extends Equatable {
  const AuthorizationEvent();

  @override
  List<Object> get props => [];
}

class Enter extends AuthorizationEvent {
  final String password;

  const Enter({required this.password});

  @override
  List<Object> get props => [password];
}

class Create extends AuthorizationEvent {
  final String password;

  const Create({required this.password});

  @override
  List<Object> get props => [password];
}

class Check extends AuthorizationEvent {
  const Check();

  @override
  List<Object> get props => [];
}
