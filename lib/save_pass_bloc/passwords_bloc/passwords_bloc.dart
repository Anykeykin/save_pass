import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:domain/models/pass_model.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/local_repository/local_repository.dart';
import 'package:save_pass/save_pass_bloc/utils/encrypt_utils.dart';

part 'passwords_event.dart';
part 'passwords_state.dart';

class PasswordsBloc extends Bloc<PasswordsEvent, PasswordsState> {
  final LocalRepository localRepository;
  PasswordsBloc({
    required this.localRepository,
  }) : super(const PasswordsState()) {
    on<SavePass>(_savePass);
    on<InitEditPass>(_initEditPass);
    on<EditPass>(_editPass);
    on<DeletePass>(_deletePass);
    on<GetAllPass>(_getAllPass);
    on<MigratePass>(_migratePass);
  }

  FutureOr<void> _savePass(SavePass event, Emitter<PasswordsState> emit) async {
    int passwordId = Random().nextInt(100);

    final String password = await EncryptUtils.encryptIsolatePassword(
      LocalRepository.securityLevel,
      event.password,
      LocalRepository.firstKey,
      LocalRepository.secondKey,
    );

    final PassModel newPass = PassModel(
      passwordName: EncryptUtils.encodeKey('1234567890123456', event.passwordName),
      password: password,
      passwordId: passwordId,
    );
    await localRepository.savePass(newPass);
    add(const GetAllPass());
  }

  FutureOr<void> _editPass(EditPass event, Emitter<PasswordsState> emit) async {
    final String password = await EncryptUtils.encryptIsolatePassword(
        LocalRepository.securityLevel,
        event.password,
        LocalRepository.firstKey,
        LocalRepository.secondKey);

    int id = state.passwordId;
    final PassModel editedPass =
        state.passModel.where((element) => element.passwordId == id).first;
    editedPass.password = password;
    editedPass.passwordName =
        EncryptUtils.encodeKey('1234567890123456', editedPass.passwordName);
    await localRepository.editPass(editedPass);

    add(const GetAllPass());
  }

  FutureOr<void> _deletePass(
      DeletePass event, Emitter<PasswordsState> emit) async {
    await localRepository.deletePass(event.passwordId);
    add(const GetAllPass());
  }

  FutureOr<void> _getAllPass(
      GetAllPass event, Emitter<PasswordsState> emit) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    List<PassModel> passModels = await localRepository.getAllPass();

    for (PassModel passModel in passModels) {
      await EncryptUtils.decryptIsolatePassword(
        passModel,
        LocalRepository.securityLevel,
        LocalRepository.firstKey,
        LocalRepository.secondKey,
      );
    }

    emit(state.copyWith(
      loadStatus: LoadStatus.success,
      passModel: passModels,
      passwordId: 0,
    ));
  }

  FutureOr<void> _initEditPass(
      InitEditPass event, Emitter<PasswordsState> emit) {
    emit(state.copyWith(passwordId: event.passwordId));
  }

  FutureOr<void> _migratePass(
      MigratePass event, Emitter<PasswordsState> emit) async {
    for (PassModel pass in state.passModel) {
      final PassModel newPass = PassModel(
          passwordName: EncryptUtils.encodeKey('1234567890123456', pass.passwordName),
          password: await EncryptUtils.encryptIsolatePassword(
            LocalRepository.securityLevel,
            pass.password,
            LocalRepository.firstKey,
            LocalRepository.secondKey,
          ),
          passwordId: pass.passwordId);

      await localRepository.editPass(newPass);
    }
  }

  
}
