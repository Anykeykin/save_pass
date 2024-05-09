part of 'passwords_bloc.dart';

enum LoadStatus { loading, success }

class PasswordsState extends Equatable {
  final LoadStatus loadStatus;
  final List<PassModel> passModel;
  @override
  List<Object?> get props => [loadStatus, passModel];

  const PasswordsState({
    this.loadStatus = LoadStatus.loading,
    this.passModel = const [],
  });

  PasswordsState copyWith({
    LoadStatus? loadStatus,
    List<PassModel>? passModel,
  }) {
    return PasswordsState(
      passModel: passModel ?? this.passModel,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }
}
