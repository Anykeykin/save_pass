part of 'passwords_bloc.dart';

enum LoadStatus { loading, success }

class PasswordsState extends Equatable {
  final LoadStatus loadStatus;
  final List<PassModel> passModel;
  final int passwordId;
  @override
  List<Object?> get props => [loadStatus, passModel, passwordId];

  const PasswordsState({
    this.loadStatus = LoadStatus.loading,
    this.passModel = const [],
    this.passwordId = 0,
  });

  PasswordsState copyWith({
    LoadStatus? loadStatus,
    List<PassModel>? passModel,
    int? passwordId,
  }) {
    return PasswordsState(
        passModel: passModel ?? this.passModel,
        loadStatus: loadStatus ?? this.loadStatus,
        passwordId: passwordId ?? this.passwordId);
  }
}
