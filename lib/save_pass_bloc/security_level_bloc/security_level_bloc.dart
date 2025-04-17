import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/local_repository/local_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:save_pass/save_pass_bloc/utils/encrypt_utils.dart';

part 'security_level_event.dart';
part 'security_level_state.dart';

class SecurityLevelBloc extends Bloc<SecurityLevelEvent, SecurityLevelState> {
  final LocalRepository localRepository;
  SecurityLevelBloc({required this.localRepository})
      : super(const SecurityLevelState()) {
    on<SaveSecurityLevel>(_saveSecurityLevel);
    on<GetSecurityLevel>(_getSecurityLevel);
  }

  FutureOr<void> _getSecurityLevel(
      GetSecurityLevel event, Emitter<SecurityLevelState> emit) async {
    String? encryptedLevel = await localRepository.getLevel();
    String level = '';
    if (encryptedLevel == null) {
      level = 'base';
      add(SaveSecurityLevel(securityLevel: level));
    }
    if (encryptedLevel != null) {
      level = EncryptUtils.mediumDecrypt(
          encryptedLevel, LocalRepository.levelKey);

      LocalRepository.securityLevel = level;
      
      emit(
        state.copyWith(
          securityLevel: level,
        ),
      );
    }
  }

  FutureOr<void> _saveSecurityLevel(
      SaveSecurityLevel event, Emitter<SecurityLevelState> emit) async {
    final String level = EncryptUtils.mediumEncrypt(
      event.securityLevel,
      LocalRepository.levelKey,
    );

    await localRepository.saveLevel(level);
    LocalRepository.securityLevel = event.securityLevel;
    emit(
      state.copyWith(
        securityLevel: event.securityLevel,
      ),
    );
  }
}
