import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvents {
  const AuthEvents();
}

class AuthEventInitialize extends AuthEvents {
  const AuthEventInitialize();
}

class AuthEventRegister extends AuthEvents {
  final String email, password;

  const AuthEventRegister({
    required this.email, required this.password
  });
}

class AuthEventLogin extends AuthEvents {
  final String email;
  final String password;

  const AuthEventLogin({
    required this.email,
    required this.password,
  });
}

class AuthEventLogout extends AuthEvents {
  const AuthEventLogout();
}

class AuthEventSendEmailVerification extends AuthEvents {
  const AuthEventSendEmailVerification();
}