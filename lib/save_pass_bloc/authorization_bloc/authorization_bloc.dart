import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:save_pass/save_pass_api/remote_api/repository/user_repository.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final UserRepository userRepository;
  AuthorizationBloc(this.userRepository) : super(const AuthorizationState()) {
    on<Login>(_login);
    on<Logout>(_logout);
    on<Register>(_register);
  }

  FutureOr<void> _login(Login event, Emitter<AuthorizationState> emit) async {
    final data = await userRepository.login(event.email, event.password);
    if (data != null) {
      emit(state.copyWith(AuthorizationStatus.access));
    } else {
      emit(state.copyWith(AuthorizationStatus.error));
    }
  }

  FutureOr<void> _logout(Logout event, Emitter<AuthorizationState> emit) async {
    await userRepository.logout();
    emit(state.copyWith(AuthorizationStatus.denied));
  }

  FutureOr<void> _register(
      Register event, Emitter<AuthorizationState> emit) async {
    final data = await userRepository.register(event.email, event.password);
    if (data != null) {
      emit(state.copyWith(AuthorizationStatus.access));
    } else {
      emit(state.copyWith(AuthorizationStatus.error));
    }
  }
}
