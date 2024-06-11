part of 'passwords_bloc.dart';

enum LoadStatus { loading, success }

class PasswordsState extends Equatable {
  final LoadStatus loadStatus;
  final List<PassModel> passModel;
  final int passwordId;
  final String securityLevel;
  final String firstSecurityKey;
  final String secondSecurityKey;

  @override
  List<Object?> get props => [
        loadStatus,
        passModel,
        passwordId,
        securityLevel,
        firstSecurityKey,
        secondSecurityKey,
      ];

  const PasswordsState({
    this.loadStatus = LoadStatus.loading,
    this.passModel = const [],
    this.passwordId = 0,
    this.securityLevel = 'base',
    this.firstSecurityKey = '',
    this.secondSecurityKey = '',
  });

  PasswordsState copyWith({
    LoadStatus? loadStatus,
    List<PassModel>? passModel,
    int? passwordId,
    String? securityLevel,
    String? firstSecurityKey,
    String? secondSecurityKey,
  }) {
    return PasswordsState(
      passModel: passModel ?? this.passModel,
      loadStatus: loadStatus ?? this.loadStatus,
      passwordId: passwordId ?? this.passwordId,
      securityLevel: securityLevel ?? this.securityLevel,
      firstSecurityKey: firstSecurityKey ?? this.firstSecurityKey,
      secondSecurityKey: secondSecurityKey ?? this.secondSecurityKey,
    );
  }
}
