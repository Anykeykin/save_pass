class AppUser {
  String email;
  String password;
  String uid;

  AppUser({
    required this.email,
    required this.password,
    required this.uid,
  });

  Map<String, Object?> toMap() {
    return {
      'password': password,
      'email': email,
      'uid': uid,
    };
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'],
      password: map['password'],
      uid: 'uid',
    );
  }
}
