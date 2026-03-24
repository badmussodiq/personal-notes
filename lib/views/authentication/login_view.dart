import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/services/auth/bloc/auth_bloc.dart';
import 'package:new_begining/services/auth/bloc/auth_events.dart';
import 'package:new_begining/services/auth/bloc/auth_state.dart';
import 'package:new_begining/utilities/dialogs/show_error_dialog.dart'
    show showErrorDialog;
import 'package:new_begining/services/auth/auth_exceptions.dart';

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
    return BlocListener<AuthBloc, AuthStates>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut && state.exception != null) {
          if (!context.mounted) return;

          if (state.exception is BadCredentialsAuthException) {
            await showErrorDialog(context, "Wrong credentials");
          } else if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, "User not found");
          } else {
            await showErrorDialog(context, "Authentication error");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
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
            // email field
            // password field
            TextButton(
              onPressed: () async {
                // update loading state
                setState(() {
                  _loading = true;
                });
                // Get email and password
                final email = _email.text;
                final password = _password.text;

                context.read<AuthBloc>().add(
                  AuthEventLogin(email: email, password: password),
                );
              },
              child: !_loading
                  ? Text('Login')
                  : const CircularProgressIndicator(
                      padding: EdgeInsets.all(4.0),
                    ),
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
      ),
    );
  }
}
