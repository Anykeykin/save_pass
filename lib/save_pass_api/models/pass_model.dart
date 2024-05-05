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

  static PassModel fromMap(Map<String, dynamic> map) {
    return PassModel(
      passwordName: map['password_name'],
      password: map['password'],
      passwordId: map['password_id'],
    );
  }
}
