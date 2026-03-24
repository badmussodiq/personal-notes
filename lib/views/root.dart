import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/services/auth/bloc/auth_bloc.dart';
import 'package:new_begining/services/auth/bloc/auth_events.dart';
import 'package:new_begining/services/auth/bloc/auth_state.dart';
import 'package:new_begining/views/authentication/login_view.dart';
import 'package:new_begining/views/authentication/verify_view.dart';
import 'package:new_begining/views/notes/notes_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthEventInitialize());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.cyan)),
          );
        }
      },
    );
  }
}