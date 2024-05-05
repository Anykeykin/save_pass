class PassModel {
  String passwordName;
  String password;
  int passwordId;
  PassModel({
    required this.passwordName,
    required this.password,
    required this.passwordId,
  });

  Map<String, Object?> toMap() {
    return {
      'password': password,
      'password_name': passwordName,
      'password_id': passwordId
    };
  }
}
