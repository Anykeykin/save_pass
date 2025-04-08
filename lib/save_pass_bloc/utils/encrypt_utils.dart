import 'dart:convert';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:crypton/crypton.dart';
import 'package:domain/models/pass_model.dart';
import 'package:encrypt_decrypt_plus/cipher/cipher.dart';

class EncryptUtils {
  static String decodeKey(String password, String key) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    Cipher cipher = Cipher();
    return cipher.xorDecode(key, secretKey: base64Encode(digest.bytes));
  }

  static String encodeKey(String password, String key) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    Cipher cipher = Cipher();
    return cipher.xorEncode(key, secretKey: base64Encode(digest.bytes));
  }

  static String mediumEncrypt(String password, String firstSecurityKey) {
    RSAKeypair firstKeyPair =
        RSAKeypair(RSAPrivateKey.fromString(firstSecurityKey));
    return firstKeyPair.publicKey.encrypt(password);
  }

  static String hardEncrypt(
      String password, String firstSecurityKey, String secondSecurityKey) {
    RSAKeypair firstKeyPair =
        RSAKeypair(RSAPrivateKey.fromString(firstSecurityKey));
    RSAKeypair secondKeyPair =
        RSAKeypair(RSAPrivateKey.fromString(secondSecurityKey));
    String encryptedPass = '';

    String pass = firstKeyPair.publicKey.encrypt(password);
    List<String> passList = pass.split('');

    for (int i = 0; i < passList.length; i++) {
      String pass2 = '';
      if (i % 2 == 0) {
        pass2 = secondKeyPair.publicKey.encrypt(passList[i]);
      }
      if (i % 2 != 0) {
        pass2 = firstKeyPair.publicKey.encrypt(passList[i]);
      }
      encryptedPass = encryptedPass + pass2;
    }

    return encryptedPass;
  }

  static String mediumDecrypt(String password, String firstSecurityKey) {
    try {
      RSAKeypair firstKeyPair =
          RSAKeypair(RSAPrivateKey.fromString(firstSecurityKey));
      String pass = firstKeyPair.privateKey.decrypt(password);
      return pass;
    } catch (e) {
      print(e);
      return '';
    }
  }

  static String hardDecrypt(
      String password, String firstSecurityKey, String secondSecurityKey) {
    RSAKeypair firstKeyPair =
        RSAKeypair(RSAPrivateKey.fromString(firstSecurityKey));
    RSAKeypair secondKeyPair =
        RSAKeypair(RSAPrivateKey.fromString(secondSecurityKey));

    String encryptedPass = '';
    for (var i = 0; i < 344; i++) {
      String pass2 = password.substring(0, 344);
      password = password.substring(344);
      if (i % 2 == 0) {
        pass2 = secondKeyPair.privateKey.decrypt(pass2);
      }
      if (i % 2 != 0) {
        pass2 = firstKeyPair.privateKey.decrypt(pass2);
      }
      encryptedPass = encryptedPass + pass2;
    }

    String pass = firstKeyPair.privateKey.decrypt(encryptedPass);

    return pass;
  }

  static Future<String> encryptIsolatePassword(
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

  static Future<void> decryptIsolatePassword(
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
