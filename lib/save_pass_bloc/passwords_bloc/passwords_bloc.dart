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
part 'passwords_utils.dart';

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

    final String password = state.securityLevel == 'base'
        ? event.password
        : state.securityLevel == 'medium'
            ? PasswordsUtils.mediumEncrypt(
                event.password, state.firstSecurityKey)
            : PasswordsUtils.hardEncrypt(event.password, state.firstSecurityKey,
                state.secondSecurityKey);

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
    SecurityLevel securityLevel = await localRepository.getSecurityLevel();
    String level = securityLevel.level == 'base'
        ? securityLevel.level
        : PasswordsUtils.mediumDecrypt(
            securityLevel.level, await localRepository.getLevelKey());

    String firstKey = '';
    String secondKey = '';
    if (level == 'medium') {
      firstKey = await localRepository.getFirstKey();
    }
    if (level == 'hard') {
      firstKey = await localRepository.getFirstKey();
      secondKey = await localRepository.getSecondKey();
    }
    emit(
      state.copyWith(
        securityLevel: level,
        firstSecurityKey: firstKey,
        secondSecurityKey: secondKey,
      ),
    );
    add(const GetAllPass());
  }

  FutureOr<void> _saveSecurityLevel(
      SaveSecurityLevel event, Emitter<PasswordsState> emit) async {
    String firstKey = '';
    String secondKey = '';
    if (event.securityLevel == 'medium') {
      firstKey = await localRepository.getFirstKey();
    }
    if (event.securityLevel == 'hard') {
      firstKey = await localRepository.getFirstKey();
      secondKey = await localRepository.getSecondKey();
    }
    emit(
      state.copyWith(
        securityLevel: event.securityLevel,
        firstSecurityKey: firstKey,
        secondSecurityKey: secondKey,
      ),
    );
    final String level = PasswordsUtils.mediumEncrypt(
      event.securityLevel,
      await localRepository.getLevelKey(),
    );

    await localRepository.saveSecurityLevel(SecurityLevel(level: level));
    add(const GetAllPass());
  }
}
