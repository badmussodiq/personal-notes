import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:new_begining/firebase_options.dart';
import 'package:new_begining/services/auth/auth_exceptions.dart';
import 'package:new_begining/services/auth/auth_providers.dart'
    as my_auth_provider
    show AuthProvider;
import 'package:new_begining/services/auth/auth_users.dart' show AuthUser;

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
        throw GeneralException(
          message: "Creation Failed,Please Contact Support",
          code: 500,
        );
      }
    } on FirebaseAuthException catch (e) {
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
        throw GeneralException(
            message: "Invalid Credentials",
            code: 401,
        );
      }
    } on FirebaseAuthException catch (e) {
      int code = 400;
      if (e.code == 'invalid-credentials') code = 401;
      if (e.code == 'user-not-found') code = 404;
      throw GeneralException(
          message: e.code,
          code: code,
      );
    } catch (e) {
      throw GeneralException(
        code: e.hashCode,
        message: e.runtimeType.toString(),
      );
    }
  }

  @override
  Future<void> logOut() async {
    try {
      final user = currentUser;
      if (user != null) {
        await FirebaseAuth.instance.signOut();
      } else {
        throw GeneralException(
          message: "User instance not available",
          code: 500,
        );
      }
    } on FirebaseException catch (e) {
      throw GeneralException(message: e.code, code: 400);
    } catch (e) {
      throw GeneralException(
          message: "Application error",
          code: 500,
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return await user.sendEmailVerification();
      } else {
        throw GeneralException(
          message: "User instance is not available",
          code: 500,
        );
      }
    } on FirebaseException catch (e) {
      throw GeneralException(message: e.code, code: 400);
    } catch (e) {
      throw GeneralException(
        message: "Application Error",
        code: 500,
      );
    }
  }

  @override
  Future<void> reload() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
    } else {
      throw GeneralException(
          message: "User instance not found",
          code: 500,
      );
    }
  }
}
