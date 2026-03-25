import 'package:flutter/foundation.dart';

@immutable
abstract class BaseException implements Exception{
  final String message;
  const BaseException({required this.message});
}

//

class UserNotLoggedInAuthException implements Exception {
  // final String message;
  // const UserNotLoggedInAuthException._([
  //   this.message = "User account is not verified"
  // ]);
}

// class UserNotLoggedInAuthException implements Exception {
//   final String message;
//
//   const UserNotLoggedInAuthException._(this.message);
//
//   factory UserNotLoggedInAuthException() {
//     return const UserNotLoggedInAuthException._(
//         "User is not logged in"
//     );
//   }
//
//   @override
//   String toString() => message;
// }

class UserNotVerifiedAuthException implements Exception {
  // final String message;
  //
  // const UserNotVerifiedAuthException._([
  //   this.message = "User account is not verified"
  // ]);
}

class UserNotFoundAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class GeneralException extends BaseException {
  final int code;
  const GeneralException({
    required super.message,
    required this.code,
  });
}

class BadCredentialsAuthException implements Exception {}
