part of 'passwords_bloc.dart';

abstract class PasswordsEvent extends Equatable {
  const PasswordsEvent();

  @override
  List<Object> get props => [];
}

class SavePass extends PasswordsEvent {
  final String passwordName;
  final String password;

  const SavePass({required this.passwordName, required this.password});

  @override
  List<Object> get props => [passwordName, password];
}

class InitEditPass extends PasswordsEvent {
  final int passwordId;

  const InitEditPass({required this.passwordId});

  @override
  List<Object> get props => [passwordId];
}

// class GetSecurityLevel extends PasswordsEvent {
//   const GetSecurityLevel();
// }

// class UpdateSecurityLevel extends PasswordsEvent {
//   final String securityLevel;
//   const UpdateSecurityLevel({required this.securityLevel});
// }

class MigratePass extends PasswordsEvent {
  const MigratePass();
}

// class SaveSecurityLevel extends PasswordsEvent {
//   final String securityLevel;
//   const SaveSecurityLevel({required this.securityLevel});
// }

class EditPass extends PasswordsEvent {
  final String password;

  const EditPass({required this.password});

  @override
  List<Object> get props => [password];
}

class DeletePass extends PasswordsEvent {
  final int passwordId;

  const DeletePass({required this.passwordId});

  @override
  List<Object> get props => [passwordId];
}

class GetAllPass extends PasswordsEvent {
  const GetAllPass();
}
