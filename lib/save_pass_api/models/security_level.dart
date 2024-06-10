class SecurityLevel {
  String level;
  SecurityLevel({
    required this.level,
  });

  Map<String, Object?> toMap() {
    return {
      'level_id': 0,
      'level': level,
    };
  }

  static SecurityLevel fromMap(Map<String, dynamic> map) {
    return SecurityLevel(
      level: map['level'],
    );
  }
}
