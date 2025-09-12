import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:new_begining/constants/routes.dart' show loginRoute, notesRoute;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _loading = false;

  //This method set the initial state of application
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  // This method dispose our states
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(hintText: 'Enter your email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 11.0,
              vertical: 10.0,
            ),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              // keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              //set loading state to true
              setState(() {
                _loading = true;
              });
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // set load state to false
                setState(() {
                  _loading = false;
                });
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (_) => false);
                }
              } on FirebaseAuthException catch (e) {
                // set load state to false
                setState(() {
                  _loading = false;
                });
                if (e.code == 'weak-password') {
                  devtools.log("Weak Password");
                } else if (e.code == 'email-already-in-use') {
                  devtools.log('User already Exist');
                } else if (e.code == 'invalid-email') {
                  devtools.log('Invalid Email format');
                }
              }
            },
            child: !_loading
                ? Text('Register')
                : const CircularProgressIndicator(),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => LoginView()),
              //   );
              // });
            },
            child: const Text('Already have an account? Login here!'),
          ),
        ],
      ),
    );
  }
}
