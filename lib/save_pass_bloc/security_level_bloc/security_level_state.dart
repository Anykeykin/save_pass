part of 'security_level_bloc.dart';

class SecurityLevelState extends Equatable {
  final String securityLevel;
  const SecurityLevelState({
    this.securityLevel = 'base',
  });

  @override
  List<Object> get props => [securityLevel];

  SecurityLevelState copyWith({
    String? securityLevel,
  }) {
    return SecurityLevelState(
      securityLevel: securityLevel ?? this.securityLevel,
    );
  }
}
