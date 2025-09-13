import 'package:new_begining/services/auth/auth_users.dart' show AuthUser;

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  // Future<void> sendPasswordReset({required String toEmail});
}