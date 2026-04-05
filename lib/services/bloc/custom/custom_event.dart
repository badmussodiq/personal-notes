import 'package:flutter/foundation.dart';

@immutable
abstract class CustomEvent {
  const CustomEvent();
}

class CustomEventInitialize extends CustomEvent {
  const CustomEventInitialize();
}

class CustomEventRegister extends CustomEvent {
  final String email, password;

  const CustomEventRegister({
    required this.email, required this.password
  });
}

class CustomEventLogin extends CustomEvent {
  final String email;
  final String password;

  const CustomEventLogin({
    required this.email,
    required this.password,
  });
}

class CustomEventLogout extends CustomEvent {
  const CustomEventLogout();
}

class CustomEventSendEmailVerification extends CustomEvent {
  const CustomEventSendEmailVerification();
}

class CustomEventSendPasswordReset extends CustomEvent {
  final String? email;

  const CustomEventSendPasswordReset({this.email});
}
