import 'package:flutter/material.dart';

import 'package:new_begining/constants/routes.dart'
    show notesRoute, verifyEmailRoute;
import 'package:new_begining/functions/show_error_dialog.dart'
    show showErrorDialog;
import 'package:new_begining/services/auth/auth_exceptions.dart';
import 'package:new_begining/services/auth/auth_services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text('Login'), backgroundColor: Colors.amber),
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
            padding: const EdgeInsets.all(8.0),
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
              // update loading state
              setState(() {
                _loading = true;
              });
              // Get email and password
              final email = _email.text;
              final password = _password.text;

              // return;
              //
              try {
                final authUser = await AuthServices.firebase().logIn(
                  email: email,
                  password: password,
                );
                setState(() {
                  _loading = false;
                });
                if (authUser.isEmailVerified && context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (_) => false);
                } else if (context.mounted) {
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                    // arguments: authUser.firebaseUser,
                  );
                }
              } on BadCredentialsAuthException catch (_) {
                if (context.mounted) {
                  setState(() {
                    _loading = false;
                  });
                  await showErrorDialog(context, "User or Password is wrong");
                }
              } on GenericAuthException catch (e) {
                if (context.mounted) {
                  setState(() {
                    _loading = false;
                  });
                  await showErrorDialog(context, e.toString());
                }
              }
              // catch (e) {
              //   if (context.mounted) {
              //     setState(() {
              //       _loading = false;
              //     });
              //     await showErrorDialog(context, e.toString());
              //   }
              // }
            },
            child: !_loading
                ? Text('Login')
                : const CircularProgressIndicator(padding: EdgeInsets.all(4.0)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
