import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:crypton/crypton.dart';
import 'package:equatable/equatable.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:save_pass/save_pass_api/models/security_level.dart';
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
    on<SaveSecurityLevel>(_saveSecurityLevel);
    on<GetSecurityLevel>(_getSecurityLevel);
    on<SavePass>(_savePass);
    on<InitEditPass>(_initEditPass);
    on<EditPass>(_editPass);
    on<DeletePass>(_deletePass);
    on<GetAllPass>(_getAllPass);
  }

  FutureOr<void> _savePass(SavePass event, Emitter<PasswordsState> emit) async {
    int passwordId = Random().nextInt(100);
    final String password = savePassword(event.password);
    final PassModel newPass = PassModel(
      passwordName: event.passwordName,
      password: password,
      passwordId: passwordId,
    );
    await localRepository.savePass(newPass);
    add(const GetAllPass());
  }

  FutureOr<void> _editPass(EditPass event, Emitter<PasswordsState> emit) async {
    final PassModel editedPass = state.passModel
        .firstWhere((element) => element.passwordId == state.passwordId);
    editedPass.password = savePassword(event.password);
    await localRepository.savePass(editedPass);
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
      passModel.password = decryptPassword(passModel.password);
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
    final SecurityLevel securityLevel =
        await localRepository.getSecurityLevel();
    String firstKey = '';
    String secondKey = '';
    if (securityLevel.level == 'medium') {
      firstKey = await localRepository.getFirstKey();
    }
    if (securityLevel.level == 'hard') {
      firstKey = await localRepository.getFirstKey();
      secondKey = await localRepository.getSecondKey();
    }
    emit(
      state.copyWith(
        securityLevel: securityLevel.level,
        firstSecurityKey: firstKey,
        secondSecurityKey: secondKey,
      ),
    );
    add(const GetAllPass());
  }

  FutureOr<void> _saveSecurityLevel(
      SaveSecurityLevel event, Emitter<PasswordsState> emit) async {
    await localRepository
        .saveSecurityLevel(SecurityLevel(level: event.securityLevel));
    emit(state.copyWith(
      securityLevel: event.securityLevel,
    ));
    add(const GetSecurityLevel());
  }

  String savePassword(String password) {
    if (state.securityLevel == 'medium') {
      RSAKeypair firstKeyPair =
          RSAKeypair(RSAPrivateKey.fromString(state.firstSecurityKey));
      String pass = firstKeyPair.publicKey.encrypt(password);
      return pass;
    }
    if (state.securityLevel == 'hard') {
      RSAKeypair firstKeyPair =
          RSAKeypair(RSAPrivateKey.fromString(state.firstSecurityKey));
      RSAKeypair secondKeyPair =
          RSAKeypair(RSAPrivateKey.fromString(state.secondSecurityKey));
      String pass = firstKeyPair.publicKey.encrypt(password);
      List<String> passList = pass.split('');
      String encryptedPass = '';
      for (int i = 0; i < passList.length; i++) {
        String pass2 = '';
        if (i % 2 == 0) {
          pass2 = secondKeyPair.publicKey.encrypt(passList[i]);
        }
        if (i % 2 != 0) {
          pass2 = firstKeyPair.publicKey.encrypt(passList[i]);
        }
        print(pass2.length);
        encryptedPass = encryptedPass + pass2;
      }

      return encryptedPass;
    }
    return password;
  }

  String decryptPassword(String password) {
    try {
      if (state.securityLevel == 'medium') {
        RSAKeypair firstKeyPair =
            RSAKeypair(RSAPrivateKey.fromString(state.firstSecurityKey));
        String pass = firstKeyPair.privateKey.decrypt(password);
        return pass;
      }
      if (state.securityLevel == 'hard') {
        RSAKeypair firstKeyPair =
            RSAKeypair(RSAPrivateKey.fromString(state.firstSecurityKey));
        RSAKeypair secondKeyPair =
            RSAKeypair(RSAPrivateKey.fromString(state.secondSecurityKey));
        List testPass = [];
        for (var i = 0; i < 344; i++) {
          testPass.add(password.substring(344));
          password = password.substring(344);
          print(password.length);
        }
        print(testPass);
        String encryptedPass = '';
        for (int i = 0; i < testPass.length; i++) {
          String pass2 = '';
          if (i % 2 == 0) {
            pass2 = secondKeyPair.privateKey.decrypt(testPass[i]);
          }
          if (i % 2 != 0) {
            pass2 = firstKeyPair.privateKey.decrypt(testPass[i]);
          }
          encryptedPass = encryptedPass + pass2;
        }
        String pass = firstKeyPair.privateKey.decrypt(encryptedPass);

        return pass;
      }
    } catch (e) {
      return password;
    }
    return password;
  }
}
