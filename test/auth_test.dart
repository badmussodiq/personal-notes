import 'package:new_begining/services/auth/auth_exceptions.dart';
import 'package:new_begining/services/auth/auth_providers.dart'
    as auth_provider
    show AuthProvider;
import 'package:new_begining/services/auth/auth_users.dart';
import 'package:test/test.dart';

void main() {
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements auth_provider.AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foobar@gmail.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WeakPasswordAuthException();
    _user = AuthUser(isEmailVerified: true, email: email);
    return Future.value(_user);
  }
   
  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    _user = null;
    await Future.delayed(const Duration(seconds: 1));
    return Future.value();
  }

  @override
  Future<void> sendEmailVerification() async{
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'email');
    _user = newUser;
    return Future.value();
  }

  @override
  Future<void> reload() {
    // TODO: implement reload
    throw UnimplementedError();
  }
}
