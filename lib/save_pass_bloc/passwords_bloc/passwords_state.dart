part of 'passwords_bloc.dart';

enum LoadStatus { loading, success }

class PasswordsState extends Equatable {
  final LoadStatus loadStatus;
  final List<PassModel> passModel;
  final int passwordId;
  final String securityLevel;
  @override
  List<Object?> get props => [
        loadStatus,
        passModel,
        passwordId,
        securityLevel,
      ];

  const PasswordsState({
    this.loadStatus = LoadStatus.loading,
    this.passModel = const [],
    this.passwordId = 0,
    this.securityLevel = 'base',
  });

  PasswordsState copyWith({
    LoadStatus? loadStatus,
    List<PassModel>? passModel,
    int? passwordId,
    String? securityLevel,
  }) {
    return PasswordsState(
      passModel: passModel ?? this.passModel,
      loadStatus: loadStatus ?? this.loadStatus,
      passwordId: passwordId ?? this.passwordId,
      securityLevel: securityLevel ?? this.securityLevel,
    );
  }
}
