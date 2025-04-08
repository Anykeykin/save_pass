class PassModel {
  String passwordName;
  String password;
  int passwordId;
  PassModel({
    required this.passwordName,
    required this.password,
    required this.passwordId,
  });

  // Метод copyWith
  PassModel copyWith({
    String? passwordName,
    String? password,
    int? passwordId,
  }) {
    return PassModel(
      passwordName: passwordName ?? this.passwordName,
      password: password ?? this.password,
      passwordId: passwordId ?? this.passwordId,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'password': password,
      'password_name': passwordName,
      'password_id': passwordId
    };
  }

  static PassModel fromMap(Map<String, dynamic> map) {
    return PassModel(
      passwordName: map['password_name'] as String,
      password: map['password'] as String,
      passwordId: map['password_id'] as int,
    );
  }

  @override
  String toString() {
    return 'PassModel(passwordName: $passwordName, password: [hidden], passwordId: $passwordId)';
  }
}