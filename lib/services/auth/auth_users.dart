import 'package:firebase_auth/firebase_auth.dart' as fire_base_auth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final fire_base_auth.User firebaseUser;
  final String email;

  const AuthUser({
    required this.isEmailVerified,
    required this.firebaseUser,
    required this.email,
  });

  factory AuthUser.fromFirebase(fire_base_auth.User user) => AuthUser(
    isEmailVerified: user.emailVerified,
    firebaseUser: user,
    email: user.email ?? '',
  );

  Future<void> reload() async => await firebaseUser.reload();
}
