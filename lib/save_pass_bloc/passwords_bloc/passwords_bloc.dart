import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:save_pass/save_pass_api/remote_api/repository/remote_repository.dart';

part 'passwords_event.dart';
part 'passwords_state.dart';

class PasswordsBloc extends Bloc<PasswordsEvent, PasswordsState> {
  final RemoteRepository remoteRepository;
  final LocalRepository localRepository;
  PasswordsBloc(
    this.remoteRepository,
    this.localRepository,
  ) : super(const PasswordsState()) {
    on<SavePass>(_savePass);
    on<EditPass>(_editPass);
    on<DeletePass>(_deletePass);
    on<GetAllPass>(_getAllPass);
  }

  FutureOr<void> _savePass(SavePass event, Emitter<PasswordsState> emit) async {
    int passwordId = Random().nextInt(100);
    final PassModel newPass = PassModel(
        passwordName: event.passwordName,
        password: event.password,
        passwordId: passwordId);
    await localRepository.savePass(newPass);
    await remoteRepository.savePass(newPass);
  }

  FutureOr<void> _editPass(EditPass event, Emitter<PasswordsState> emit) async {
    final PassModel editedPass = state.passModel
        .firstWhere((element) => element.passwordId == event.passwordId);
    editedPass.password = event.password;
    await localRepository.savePass(editedPass);
    await remoteRepository.editPass(editedPass);
  }

  FutureOr<void> _deletePass(
      DeletePass event, Emitter<PasswordsState> emit) async {
    await localRepository.deletePass(event.passwordId);
    await remoteRepository.deletePass(event.passwordId);
  }

  FutureOr<void> _getAllPass(
      GetAllPass event, Emitter<PasswordsState> emit) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    List<PassModel> passModel = await localRepository.getAllPass();
    emit(state.copyWith(passModel: passModel));
    final List<PassModel> onlinePassModel = await remoteRepository.getAllPass();
    passModel.addAll(onlinePassModel);
    emit(state.copyWith(loadStatus: LoadStatus.success, passModel: passModel));
  }
}
