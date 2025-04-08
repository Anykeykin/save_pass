part of 'security_level_bloc.dart';

abstract class SecurityLevelEvent extends Equatable {
  const SecurityLevelEvent();

  @override
  List<Object> get props => [];
}

class GetSecurityLevel extends SecurityLevelEvent {
  const GetSecurityLevel();
}

class SaveSecurityLevel extends SecurityLevelEvent {
  final String securityLevel;
  const SaveSecurityLevel({required this.securityLevel});
}