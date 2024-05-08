import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  AuthorizationBloc() : super(AuthorizationState()) {
    on<Login>(_login);
    on<Logout>(_logout);
    on<Register>(_register);
  }

  FutureOr<void> _login(Login event, Emitter<AuthorizationState> emit) {}

  FutureOr<void> _logout(Logout event, Emitter<AuthorizationState> emit) {}

  FutureOr<void> _register(Register event, Emitter<AuthorizationState> emit) {}
}
