class SecurityKey {
  String keyName;
  String key;
  SecurityKey({
    required this.keyName,
    required this.key,
  });

  Map<String, Object?> toMap() {
    return {
      'key_name': keyName,
      'key': key,
    };
  }

  static SecurityKey fromMap(Map<String, dynamic> map) {
    return SecurityKey(
      keyName: map['key_name'],
      key: map['key'],
    );
  }
}
