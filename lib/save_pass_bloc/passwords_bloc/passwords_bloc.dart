import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:crypton/crypton.dart';
import 'package:encrypt_decrypt_plus/cipher/cipher.dart';
import 'package:equatable/equatable.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:save_pass/save_pass_bloc/authorization_bloc/authorization_bloc.dart';

part 'passwords_event.dart';
part 'passwords_state.dart';
part 'passwords_utils.dart';

class PasswordsBloc extends Bloc<PasswordsEvent, PasswordsState> {
  final AuthorizationBloc authorizationBloc;
  final LocalRepository localRepository;
  PasswordsBloc(
    this.authorizationBloc,
    this.localRepository,
  ) : super(const PasswordsState()) {
    on<SaveSecurityLevel>(_saveSecurityLevel);
    on<GetSecurityLevel>(_getSecurityLevel);
    on<UpdateSecurityLevel>(_updateSecurityLevel);
    on<SavePass>(_savePass);
    on<InitEditPass>(_initEditPass);
    on<EditPass>(_editPass);
    on<DeletePass>(_deletePass);
    on<GetAllPass>(_getAllPass);
  }

  FutureOr<void> _savePass(SavePass event, Emitter<PasswordsState> emit) async {
    int passwordId = Random().nextInt(100);

    final String password = state.securityLevel == 'base'
        ? event.password
        : state.securityLevel == 'medium'
            ? PasswordsUtils.mediumEncrypt(
                event.password, state.firstSecurityKey)
            : PasswordsUtils.hardEncrypt(event.password, state.firstSecurityKey,
                state.secondSecurityKey);

    final PassModel newPass = PassModel(
      passwordName: PasswordsUtils.encodeKey('1234',event.passwordName),
      password: password,
      passwordId: passwordId,
    );
    await localRepository.savePass(newPass);
    add(const GetAllPass());
  }

  FutureOr<void> _editPass(EditPass event, Emitter<PasswordsState> emit) async {
    final PassModel editedPass = state.passModel
        .firstWhere((element) => element.passwordId == state.passwordId);
    editedPass.password = state.securityLevel == 'base'
        ? event.password
        : state.securityLevel == 'medium'
            ? PasswordsUtils.mediumEncrypt(
                event.password, state.firstSecurityKey)
            : PasswordsUtils.hardEncrypt(event.password, state.firstSecurityKey,
                state.secondSecurityKey);

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
      passModel.passwordName = PasswordsUtils.decodeKey('1234',passModel.passwordName);
      passModel.password = state.securityLevel == 'base'
          ? passModel.password
          : state.securityLevel == 'medium'
              ? PasswordsUtils.mediumDecrypt(
                  passModel.password, state.firstSecurityKey)
              : PasswordsUtils.hardDecrypt(passModel.password,
                  state.firstSecurityKey, state.secondSecurityKey);
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
          await localRepository.getLevel(), authorizationBloc.state.levelKey);
    }

    emit(
      state.copyWith(
        securityLevel: level,
        firstSecurityKey: authorizationBloc.state.firstKey,
        secondSecurityKey: authorizationBloc.state.secondKey,
      ),
    );
    add(const GetAllPass());
  }

  FutureOr<void> _saveSecurityLevel(
      SaveSecurityLevel event, Emitter<PasswordsState> emit) async {
    final String level = PasswordsUtils.mediumEncrypt(
      event.securityLevel,
      authorizationBloc.state.levelKey,
    );

    await localRepository.saveLevel(level);
  }

  FutureOr<void> _updateSecurityLevel(
      UpdateSecurityLevel event, Emitter<PasswordsState> emit) async {
    final String level = PasswordsUtils.mediumEncrypt(
      event.securityLevel,
      authorizationBloc.state.levelKey,
    );

    await localRepository.saveLevel(level);
    add(const GetSecurityLevel());
  }
}
