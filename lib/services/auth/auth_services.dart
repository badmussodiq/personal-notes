import 'package:new_begining/services/auth/auth_providers.dart'
    as auth_provider
    show AuthProvider;
import 'package:new_begining/services/auth/auth_users.dart' show AuthUser;

class AuthServices implements auth_provider.AuthProvider {
  final auth_provider.AuthProvider provider;
  const AuthServices(this.provider);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
