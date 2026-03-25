import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:new_begining/firebase_options.dart';
import 'package:new_begining/services/auth/auth_exceptions.dart';
import 'package:new_begining/services/auth/auth_providers.dart'
    as my_auth_provider
    show AuthProvider;
import 'package:new_begining/services/auth/auth_users.dart' show AuthUser;
import 'dart:developer' as devtools show log;

class FirebaseAuthProvider implements my_auth_provider.AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     throw WeakPasswordAuthException();
    //   } else if (e.code == 'email-already-in-use') {
    //     throw EmailAlreadyInUseAuthException();
    //   } else if (e.code == 'invalid-email') {
    //     throw InvalidEmailAuthException();
    //   } else {
    //     throw GenericAuthException();
    //   }
    // } catch (_) {
    //   throw GenericAuthException();

      throw GeneralException(code: 500, message: e.code);
    } catch (e) {
      throw GeneralException(
        code: e.hashCode,
        message: e.runtimeType.toString(),
      );
    }
  }

  /// Get the current user
  /// If no user is logged in, return null
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        devtools.log(e.message!);
        devtools.log(e.code);
        throw BadCredentialsAuthException();
      } else {
        devtools.log(e.code);
        devtools.log(e.message!);
        throw GeneralException(message: e.code, code: 400);
      }
    } catch (e) {
      devtools.log(e.toString());
      throw GeneralException(message: "Internal Server Error", code: 500);
    }
  }

  @override
  Future<void> logOut() async {
    final user = currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> reload() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
