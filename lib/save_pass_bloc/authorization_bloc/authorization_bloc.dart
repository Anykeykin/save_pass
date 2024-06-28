import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:crypton/crypton.dart';
import 'package:encrypt_decrypt_plus/cipher/cipher.dart';
import 'package:equatable/equatable.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/models/security_level.dart';

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
      String firstKey = decodeKey(event.password, state.firstKey);
      String secondKey = decodeKey(event.password, state.secondKey);
      String levelKey = decodeKey(event.password, state.levelKey);

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

    String encFirstKey = encodeKey(event.password, firstKey);
    await localRepository
        .saveSecurityKey(SecurityKey(keyName: encodeKey('1234', 'first_key') , key: encFirstKey));

    String encSecondKey = encodeKey(event.password, secondKey);
    await localRepository
        .saveSecurityKey(SecurityKey(keyName: encodeKey('1234', 'second_key'), key: encSecondKey));

    String encLevelKey = encodeKey(event.password, levelKey);
    await localRepository
        .saveSecurityKey(SecurityKey(keyName: encodeKey('1234', 'level_key'), key: encLevelKey));

    emit(
      state.copyWith(
        openStatus: OpenStatus.denied,
        firstKey: firstKey,
        secondKey: secondKey,
        levelKey: levelKey,
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
        String keyName = decodeKey('1234', key.keyName);
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
    var digest = sha256.convert(bytes);

    Cipher cipher = Cipher();
    return cipher.xorDecode(key, secretKey: base64Encode(digest.bytes));
  }

  String encodeKey(String password, String key) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    Cipher cipher = Cipher();
    return cipher.xorEncode(key, secretKey: base64Encode(digest.bytes));
  }
}
