part of 'authorization_bloc.dart';

enum OpenStatus { loading, access, denied, create, error }

class AuthorizationState extends Equatable {
  final OpenStatus openStatus;
  final String levelKey;
  final String firstKey;
  final String secondKey;
  @override
  List<Object?> get props => [openStatus, levelKey, firstKey, secondKey];

  const AuthorizationState({
    this.openStatus = OpenStatus.loading,
    this.levelKey = '',
    this.firstKey = '',
    this.secondKey = '',
  });

  AuthorizationState copyWith({
    OpenStatus? openStatus,
    String? levelKey,
    String? firstKey,
    String? secondKey,
  }) {
    return AuthorizationState(
      openStatus: openStatus ?? this.openStatus,
      levelKey: levelKey ?? this.levelKey,
      firstKey: firstKey ?? this.firstKey,
      secondKey: secondKey ?? this.secondKey,
    );
  }
}
