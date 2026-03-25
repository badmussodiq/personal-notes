import 'package:new_begining/services/auth/auth_users.dart' show AuthUser;

abstract class AuthProvider {
  // initialize
  Future<void> initialize();

  // get user instance
  AuthUser? get currentUser;

  // create user4
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  // login user
  Future<AuthUser> logIn({required String email, required String password});

  //logout
  Future<void> logOut();

  // send email verification
  Future<void> sendEmailVerification();

  Future<void> reload();

  // Future<void> sendPasswordReset({required String toEmail});
}
