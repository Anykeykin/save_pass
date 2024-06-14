part of 'passwords_bloc.dart';

class PasswordsUtils extends Equatable {
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
    RSAKeypair firstKeyPair =
        RSAKeypair(RSAPrivateKey.fromString(firstSecurityKey));
    String pass = firstKeyPair.privateKey.decrypt(password);
    return pass;
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

  @override
  List<Object?> get props => [];
}
