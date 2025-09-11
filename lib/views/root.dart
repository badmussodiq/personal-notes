import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_begining/views/authentication/login_view.dart';
import 'package:new_begining/views/authentication/verify_view.dart';
import 'package:new_begining/views/home_page.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  User? _user;
  late final StreamSubscription<User?> _authSub;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        try {
          await user.reload();
          setState(() {
            _user = FirebaseAuth.instance.currentUser;
            _loading = false; // ✅ finished loading
          });
        } catch (_) {
          // If reload fails (e.g., user deleted remotely), sign out
          await FirebaseAuth.instance.signOut();
          setState(() {
            _user = null;
            _loading = false;
          });
        }
      } else {
        setState(() {
          _user = null;
          _loading = false;
        });
      }
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
      // 👈 show loader while waiting for auth state
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.cyan)),
      );
    }

    if (_user == null) {
      return const LoginView();
    } else if (!_user!.emailVerified) {
      return VerifyEmailView(user: _user!);
    } else {
      return const Dashboard();
    }
  }
}
