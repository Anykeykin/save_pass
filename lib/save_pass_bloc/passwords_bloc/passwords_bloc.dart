import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:crypton/crypton.dart';
import 'package:domain/models/pass_model.dart';
import 'package:encrypt_decrypt_plus/cipher/cipher.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/local_repository/local_repository.dart';

part 'passwords_event.dart';
part 'passwords_state.dart';
part 'passwords_utils.dart';

class PasswordsBloc extends Bloc<PasswordsEvent, PasswordsState> {
  final LocalRepository localRepository;
  PasswordsBloc({
    required this.localRepository,
  }) : super(const PasswordsState()) {
    on<SaveSecurityLevel>(_saveSecurityLevel);
    on<GetSecurityLevel>(_getSecurityLevel);
    on<UpdateSecurityLevel>(_updateSecurityLevel);
    on<SavePass>(_savePass);
    on<InitEditPass>(_initEditPass);
    on<EditPass>(_editPass);
    on<DeletePass>(_deletePass);
    on<GetAllPass>(_getAllPass);
    on<MigratePass>(_migratePass);
  }

  FutureOr<void> _savePass(SavePass event, Emitter<PasswordsState> emit) async {
    int passwordId = Random().nextInt(100);
    String firstSecurityKey = state.firstSecurityKey;
    String secondSecurityKey = state.secondSecurityKey;
    String securityLevel = state.securityLevel;
    final String password = await Isolate.run(
      () {
        return securityLevel == 'base'
            ? event.password
            : securityLevel == 'medium'
                ? PasswordsUtils.mediumEncrypt(event.password, firstSecurityKey)
                : PasswordsUtils.hardEncrypt(
                    event.password, firstSecurityKey, secondSecurityKey);
      },
    );

    final PassModel newPass = PassModel(
      passwordName: PasswordsUtils.encodeKey('1234', event.passwordName),
      password: password,
      passwordId: passwordId,
    );
    await localRepository.savePass(newPass);
    add(const GetAllPass());
  }

  FutureOr<void> _editPass(EditPass event, Emitter<PasswordsState> emit) async {
    String firstSecurityKey = state.firstSecurityKey;
    String secondSecurityKey = state.secondSecurityKey;
    String securityLevel = state.securityLevel;
    String userPassword = event.password;
    final PassModel editedPass = state.passModel
        .firstWhere((element) => element.passwordId == state.passwordId);
    final String password = await Isolate.run(() {
      return securityLevel == 'base'
          ? userPassword
          : securityLevel == 'medium'
              ? PasswordsUtils.mediumEncrypt(userPassword, firstSecurityKey)
              : PasswordsUtils.hardEncrypt(
                  userPassword, firstSecurityKey, secondSecurityKey);
    });
    final PassModel newPass = PassModel(
      passwordName: PasswordsUtils.encodeKey('1234', editedPass.passwordName),
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
    String firstSecurityKey = state.firstSecurityKey;
    String secondSecurityKey = state.secondSecurityKey;
    String securityLevel = state.securityLevel;
    for (PassModel passModel in passModels) {
      passModel.password = await Isolate.run(() {
        return securityLevel == 'base'
            ? passModel.password
            : securityLevel == 'medium'
                ? PasswordsUtils.mediumDecrypt(
                    passModel.password,
                    firstSecurityKey,
                  )
                : PasswordsUtils.hardDecrypt(
                    passModel.password,
                    firstSecurityKey,
                    secondSecurityKey,
                  );
      });
      passModel.passwordName = await Isolate.run(() {
        return PasswordsUtils.decodeKey('1234', passModel.passwordName);
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

  FutureOr<void> _getSecurityLevel(
      GetSecurityLevel event, Emitter<PasswordsState> emit) async {
    String encryptedLevel = await localRepository.getLevel();
    String level = '';
    if (encryptedLevel.isEmpty) {
      level = 'base';
      add(SaveSecurityLevel(securityLevel: level));
    }
    if (encryptedLevel.isNotEmpty) {
      level = PasswordsUtils.mediumDecrypt(
          await localRepository.getLevel(), LocalRepository.levelKey);
    }

    emit(
      state.copyWith(
        securityLevel: level,
        firstSecurityKey: LocalRepository.firstKey,
        secondSecurityKey: LocalRepository.secondKey,
      ),
    );
    add(const GetAllPass());
  }

  FutureOr<void> _saveSecurityLevel(
      SaveSecurityLevel event, Emitter<PasswordsState> emit) async {
    final String level = PasswordsUtils.mediumEncrypt(
      event.securityLevel,
      LocalRepository.levelKey,
    );

    await localRepository.saveLevel(level);
  }

  FutureOr<void> _updateSecurityLevel(
      UpdateSecurityLevel event, Emitter<PasswordsState> emit) async {
    final String level = PasswordsUtils.mediumEncrypt(
      event.securityLevel,
      LocalRepository.levelKey,
    );
    emit(state.copyWith(
      securityLevel: event.securityLevel,
    ));
    await localRepository.saveLevel(level);

    add(const MigratePass());
  }

  FutureOr<void> _migratePass(
      MigratePass event, Emitter<PasswordsState> emit) async {
    String firstSecurityKey = state.firstSecurityKey;
    String secondSecurityKey = state.secondSecurityKey;
    String securityLevel = state.securityLevel;
    for (PassModel pass in state.passModel) {
      final PassModel newPass = PassModel(
          passwordName: PasswordsUtils.encodeKey('1234', pass.passwordName),
          password: await Isolate.run(
            () {
              return securityLevel == 'base'
                  ? pass.password
                  : securityLevel == 'medium'
                      ? PasswordsUtils.mediumEncrypt(
                          pass.password, firstSecurityKey)
                      : PasswordsUtils.hardEncrypt(
                          pass.password, firstSecurityKey, secondSecurityKey);
            },
          ),
          passwordId: pass.passwordId);

      await localRepository.editPass(newPass);
    }
  }
}
