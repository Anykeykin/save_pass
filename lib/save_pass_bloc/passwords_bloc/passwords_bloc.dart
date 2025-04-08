import 'dart:async';
import 'dart:isolate';
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

    final String password = await encryptIsolatePassword(
      LocalRepository.securityLevel,
      event.password,
      LocalRepository.firstKey,
      LocalRepository.secondKey,
    );

    final PassModel newPass = PassModel(
      passwordName: EncryptUtils.encodeKey('1234', event.passwordName),
      password: password,
      passwordId: passwordId,
    );
    await localRepository.savePass(newPass);
    add(const GetAllPass());
  }

  FutureOr<void> _editPass(EditPass event, Emitter<PasswordsState> emit) async {
    final String password = await encryptIsolatePassword(
        LocalRepository.securityLevel,
        event.password,
        LocalRepository.firstKey,
        LocalRepository.secondKey);

    int id = state.passwordId;
    final PassModel editedPass =
        state.passModel.where((element) => element.passwordId == id).first;
    editedPass.password = password;
    editedPass.passwordName =
        EncryptUtils.encodeKey('1234', editedPass.passwordName);
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
      await decryptIsolatePassword(
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
          passwordName: EncryptUtils.encodeKey('1234', pass.passwordName),
          password: await encryptIsolatePassword(
            LocalRepository.securityLevel,
            pass.password,
            LocalRepository.firstKey,
            LocalRepository.secondKey,
          ),
          passwordId: pass.passwordId);

      await localRepository.editPass(newPass);
    }
  }

  Future<String> encryptIsolatePassword(
    String securityLevel,
    String password,
    String firstSecurityKey,
    String secondSecurityKey,
  ) async {
    return await Isolate.run(
      () {
        return securityLevel == 'base'
            ? password
            : securityLevel == 'medium'
                ? EncryptUtils.mediumEncrypt(password, firstSecurityKey)
                : EncryptUtils.hardEncrypt(
                    password, firstSecurityKey, secondSecurityKey);
      },
    );
  }

  Future<void> decryptIsolatePassword(
    PassModel passModel,
    String securityLevel,
    String firstKey,
    String secondKey,
  ) async {
    passModel.password = await Isolate.run(() {
      return securityLevel == 'base'
          ? passModel.password
          : securityLevel == 'medium'
              ? EncryptUtils.mediumDecrypt(
                  passModel.password,
                  firstKey,
                )
              : EncryptUtils.hardDecrypt(
                  passModel.password,
                  firstKey,
                  secondKey,
                );
    });
    passModel.passwordName = await Isolate.run(() {
      return EncryptUtils.decodeKey('1234', passModel.passwordName);
    });
  }
}
