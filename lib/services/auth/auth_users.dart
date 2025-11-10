import 'package:firebase_auth/firebase_auth.dart' as fire_base_auth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  // final fire_base_auth.User firebaseUser;

  final String email;

  const AuthUser({required this.id, required this.isEmailVerified, required this.email});

  factory AuthUser.fromFirebase(fire_base_auth.User user) =>
      AuthUser(id: user.uid ,isEmailVerified: user.emailVerified, email: user.email!);
}
 