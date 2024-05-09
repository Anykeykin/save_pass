import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';

part 'passwords_event.dart';
part 'passwords_state.dart';

class PasswordsBloc extends Bloc<PasswordsEvent, PasswordsState> {
  PasswordsBloc() : super(const PasswordsState()) {
    on<SavePass>(_savePass);
    on<EditPass>(_editPass);
    on<DeletePass>(_deletePass);
    on<GetAllPass>(_getAllPass);
  }

  FutureOr<void> _savePass(
      SavePass event, Emitter<PasswordsState> emit) async {}

  FutureOr<void> _editPass(
      EditPass event, Emitter<PasswordsState> emit) async {}

  FutureOr<void> _deletePass(
      DeletePass event, Emitter<PasswordsState> emit) async {}

  FutureOr<void> _getAllPass(
      GetAllPass event, Emitter<PasswordsState> emit) async {}
}
