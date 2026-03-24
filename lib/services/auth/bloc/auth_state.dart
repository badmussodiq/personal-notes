import 'package:flutter/foundation.dart';
import 'package:new_begining/services/auth/auth_users.dart';

// base class for all auth states
@immutable
abstract class AuthStates {
  const AuthStates();
}

// state when user is logged in
class AuthStateLoggedIn extends AuthStates {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user});
}

// state when auth process is in loading
class AuthStateLoading extends AuthStates {
  const AuthStateLoading();
}

// state when user is logged out
class AuthStateLoggedOut extends AuthStates {
  final Exception? exception;
  const AuthStateLoggedOut({this.exception});
}

// state when login fails
// class AuthStateLoginFailure extends AuthStates {
//   final Exception exception;
//   const AuthStateLoginFailure({required this.exception});
// }

class AuthStateLoggedOutFailure extends AuthStates {
  final Exception exception;
  const AuthStateLoggedOutFailure({required this.exception});
}

// state when verification is needed
class AuthStateNeedsVerification extends AuthStates {
  const AuthStateNeedsVerification();
}
