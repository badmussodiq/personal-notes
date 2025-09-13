import 'package:firebase_auth/firebase_auth.dart' as fire_base_auth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase(fire_base_auth.User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
}
