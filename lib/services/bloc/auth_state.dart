import 'package:flutter/foundation.dart';
import 'package:new_begining/services/auth/auth_exceptions.dart';
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

class AppInitializationState extends AuthStates {
  const AppInitializationState();
}


// state when user is logged out
class AuthStateLoggedOut extends AuthStates {
  final GeneralException? exception;
  final bool isLoading;
  const AuthStateLoggedOut({this.exception, required this.isLoading});
}

// state when logout user failed
class AuthStateLoggedOutFailure extends AuthStates {
  final Exception exception;
  const AuthStateLoggedOutFailure({required this.exception});
}

// state when verification is needed
class AuthStateNeedsVerification extends AuthStates {
  const AuthStateNeedsVerification();
}

class GeneralExceptionState extends AuthStates {
  final int? code;
  final String message;
  final Exception? exception;

  const GeneralExceptionState({
    this.code,
    required this.message,
    required this.exception
  });
}

