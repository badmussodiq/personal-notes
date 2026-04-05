import '../../auth/auth_exceptions.dart';
import '../../auth/auth_users.dart';

enum CustomStatus {
  unknown,
  authenticated,
  unauthenticated,
  verifyingEmail,
  loading,
}

class CustomState {
  final CustomStatus status;
  final AuthUser? user;
  final GeneralException? exception;
  final bool isLoading;

  const CustomState({
    required this.status,
    this.user,
    this.exception,
    required this.isLoading,
  });

  factory CustomState.unknown() =>
      const CustomState(status: CustomStatus.unknown, isLoading: true);

  factory CustomState.loading() =>
      const CustomState(status: CustomStatus.loading, isLoading: false);

  factory CustomState.loggedOut({GeneralException? exception}) => CustomState(
    status: CustomStatus.unauthenticated,
    exception: exception,
    isLoading: false,
  );

  factory CustomState.loggedIn(AuthUser user) => CustomState(
    status: CustomStatus.authenticated,
    user: user,
    isLoading: false,
    exception: null,
  );

  factory CustomState.verifying() =>
      const CustomState(status: CustomStatus.verifyingEmail, isLoading: true);

  factory CustomState.verifiedCompleted () =>
  const CustomState(status: CustomStatus.authenticated, isLoading: false);

  CustomState copyWith({
    CustomStatus? status,
    AuthUser? user,
    GeneralException? exception,
    bool? isLoading,
  }) {
    return CustomState(
      status: status ?? this.status,
      user: user ?? this.user,
      exception: exception != null ? this.exception : null,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
