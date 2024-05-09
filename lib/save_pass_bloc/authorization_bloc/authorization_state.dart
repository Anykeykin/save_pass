part of 'authorization_bloc.dart';

enum AuthorizationStatus { access, denied, error }

class AuthorizationState extends Equatable {
  final AuthorizationStatus registrationStatus;

  @override
  List<Object?> get props => [registrationStatus];

  const AuthorizationState({
    this.registrationStatus = AuthorizationStatus.denied,
  });

  AuthorizationState copyWith(
    AuthorizationStatus? registrationStatus,
  ) {
    return AuthorizationState(
      registrationStatus: registrationStatus ?? this.registrationStatus,
    );
  }
}
