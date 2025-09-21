import 'package:new_begining/services/auth/auth_providers.dart'
    as auth_provider
    show AuthProvider;
import 'package:new_begining/services/auth/auth_users.dart' show AuthUser;
import 'package:new_begining/services/firebase/firebase_auth_provider.dart'
    show FirebaseAuthProvider;

class AuthServices implements auth_provider.AuthProvider {
  final auth_provider.AuthProvider authProvider;
  const AuthServices(this.authProvider);

  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => authProvider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => authProvider.currentUser;

  @override
  Future<void> initialize() => authProvider.initialize();

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      authProvider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => authProvider.logOut();

  @override
  Future<void> sendEmailVerification() => authProvider.sendEmailVerification();

  @override
  Future<void> reload() {
    return authProvider.reload();
  }
}
