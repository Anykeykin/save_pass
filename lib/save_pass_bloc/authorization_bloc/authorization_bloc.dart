import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:crypton/crypton.dart';
import 'package:domain/models/security_level.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/local_repository/local_repository.dart';
import 'package:smart_encrypt/smart_encrypt.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final LocalRepository localRepository;
  AuthorizationBloc(this.localRepository) : super(const AuthorizationState()) {
    on<Enter>(_enter);
    on<Create>(_create);
    on<Check>(_check);
  }

  FutureOr<void> _enter(Enter event, Emitter<AuthorizationState> emit) async {
    try {
      String password = event.password;
      while (password.length != 16) {
        password = password + password[0];
      }
      String firstKey = decodeKey(password, state.firstKey);
      String secondKey = decodeKey(password, state.secondKey);
      String levelKey = decodeKey(password, state.levelKey);

      LocalRepository.levelKey = levelKey;
      LocalRepository.secondKey = secondKey;
      LocalRepository.firstKey = firstKey;

      emit(
        state.copyWith(
          openStatus: OpenStatus.access,
          firstKey: firstKey,
          secondKey: secondKey,
          levelKey: levelKey,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          openStatus: OpenStatus.error,
        ),
      );
    }
  }

  FutureOr<void> _create(Create event, Emitter<AuthorizationState> emit) async {
    String firstKey = RSAKeypair.fromRandom().privateKey.toString();
    String secondKey = RSAKeypair.fromRandom().privateKey.toString();
    String levelKey = RSAKeypair.fromRandom().privateKey.toString();
    String password = event.password;
    while (password.length != 16) {
      password = password + password[0];
    }
    String encFirstKey = encodeKey(password, firstKey);
    await localRepository.saveSecurityKey(SecurityKey(
        keyName: encodeKey('1234567890123456', 'first_key'), key: encFirstKey));

    String encSecondKey = encodeKey(password, secondKey);
    await localRepository.saveSecurityKey(SecurityKey(
        keyName: encodeKey('1234567890123456', 'second_key'),
        key: encSecondKey));

    String encLevelKey = encodeKey(password, levelKey);
    await localRepository.saveSecurityKey(SecurityKey(
        keyName: encodeKey('1234567890123456', 'level_key'), key: encLevelKey));

    emit(
      state.copyWith(
        openStatus: OpenStatus.denied,
        firstKey: encFirstKey,
        secondKey: encSecondKey,
        levelKey: encLevelKey,
      ),
    );
  }

  FutureOr<void> _check(Check event, Emitter<AuthorizationState> emit) async {
    List<SecurityKey> keys = await localRepository.getKeys();
    if (keys.isEmpty) {
      // TODO: реализовать также удаление всех данных при этом случае
      emit(state.copyWith(openStatus: OpenStatus.create));
    }
    if (keys.isNotEmpty) {
      String firstKey = '';
      String secondKey = '';
      String levelKey = '';
      for (SecurityKey key in keys) {
        String keyName = decodeKey('1234567890123456', key.keyName);
        if (keyName == 'first_key') firstKey = key.key;
        if (keyName == 'second_key') secondKey = key.key;
        if (keyName == 'level_key') levelKey = key.key;
      }
      emit(
        state.copyWith(
          openStatus: OpenStatus.denied,
          firstKey: firstKey,
          secondKey: secondKey,
          levelKey: levelKey,
        ),
      );
    }
  }

  String decodeKey(String password, String key) {
    var bytes = utf8.encode(password);
    var iv = utf8.encode(password);

    return SmartEncrypt.decrypt(key, bytes, iv);
  }

  String encodeKey(String password, String key) {
    var bytes = utf8.encode(password);
    var iv = utf8.encode(password);

    return SmartEncrypt.encrypt(key, bytes, iv);
  }
}
