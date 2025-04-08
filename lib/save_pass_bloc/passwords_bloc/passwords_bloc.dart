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
    String firstSecurityKey = LocalRepository.firstKey;
    String secondSecurityKey = LocalRepository.secondKey;
    String securityLevel = LocalRepository.securityLevel;
    final String password = await Isolate.run(
      () {
        return securityLevel == 'base'
            ? event.password
            : securityLevel == 'medium'
                ? EncryptUtils.mediumEncrypt(event.password, firstSecurityKey)
                : EncryptUtils.hardEncrypt(
                    event.password, firstSecurityKey, secondSecurityKey);
      },
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
    String firstSecurityKey = LocalRepository.firstKey;
    String secondSecurityKey = LocalRepository.secondKey;
    String securityLevel = LocalRepository.securityLevel;
    String userPassword = event.password;
    final PassModel editedPass = state.passModel
        .firstWhere((element) => element.passwordId == state.passwordId);
    final String password = await Isolate.run(() {
      return securityLevel == 'base'
          ? userPassword
          : securityLevel == 'medium'
              ? EncryptUtils.mediumEncrypt(userPassword, firstSecurityKey)
              : EncryptUtils.hardEncrypt(
                  userPassword, firstSecurityKey, secondSecurityKey);
    });
    final PassModel newPass = PassModel(
      passwordName: EncryptUtils.encodeKey('1234', editedPass.passwordName),
      password: password,
      passwordId: state.passwordId,
    );
    await localRepository.editPass(newPass);

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

    String firstKey = LocalRepository.firstKey;
    String secondKey = LocalRepository.secondKey;
    String securityLevel = LocalRepository.securityLevel;

    for (PassModel passModel in passModels) {
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
    String firstSecurityKey = LocalRepository.firstKey;
    String secondSecurityKey = LocalRepository.secondKey;
    String securityLevel = LocalRepository.securityLevel;
    for (PassModel pass in state.passModel) {
      final PassModel newPass = PassModel(
          passwordName: EncryptUtils.encodeKey('1234', pass.passwordName),
          password: await Isolate.run(
            () {
              return securityLevel == 'base'
                  ? pass.password
                  : securityLevel == 'medium'
                      ? EncryptUtils.mediumEncrypt(
                          pass.password, firstSecurityKey)
                      : EncryptUtils.hardEncrypt(
                          pass.password, firstSecurityKey, secondSecurityKey);
            },
          ),
          passwordId: pass.passwordId);

      await localRepository.editPass(newPass);
    }
  }
}
