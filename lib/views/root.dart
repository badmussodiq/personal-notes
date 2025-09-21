import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_begining/services/auth/auth_services.dart';
import 'package:new_begining/services/auth/auth_users.dart';
import 'package:new_begining/views/authentication/login_view.dart';
import 'package:new_begining/views/authentication/verify_view.dart';
import 'package:new_begining/views/notes/notes_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthUser? _authUser;
  late final StreamSubscription<AuthUser?> _authSub;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _authSub = FirebaseAuth.instance
        .authStateChanges()
        .map((user) {
          return user != null ? AuthUser.fromFirebase(user) : null;
        })
        .listen((authUser) async {
          // if (mounted) return; // prevents setState on disposed widget
          // Future.microtask(() async {
          if (authUser != null) {
            try {
              await AuthServices.firebase().reload();
              if (mounted) {
                setState(() {
                  _authUser = AuthServices.firebase().currentUser;
                  _loading = false; // finished loading
                });
              }
            } catch (_) {
              // If reload fails (e.g., user deleted remotely), sign out
              await AuthServices.firebase().logOut();
              if (mounted) {
                setState(() {
                  _authUser = null;
                  _loading = false;
                });
              }
            }
          } else {
            if (mounted) {
              setState(() {
                // if (mounted) return;
                _authUser = null;
                _loading = false;
              });
            }
          }
          // });
        });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(color: Colors.cyan),
          ),
        ),
      );
    }

    if (_authUser == null) {
      return const LoginView();
    } else if (!_authUser!.isEmailVerified) {
      return VerifyEmailView();
    } else {
      return const NotesView();
    }
  }
}
