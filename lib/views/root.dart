import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/services/bloc/custom/custom_bloc.dart';
import 'package:new_begining/services/bloc/custom/custom_state.dart';
import 'package:new_begining/views/authentication/login_view.dart';
import 'package:new_begining/views/authentication/verify_view.dart';
import 'package:new_begining/views/notes/notes_view.dart';
import '../services/bloc/custom/custom_event.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    context.read<CustomBloc>().add(const CustomEventInitialize());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomBloc, CustomState>(
      builder: (context, state) {
        // if (state is AuthStateLoggedIn) {
        //   return const NotesView();
        // } else if (state is AuthStateNeedsVerification) {
        //   return const VerifyEmailView();
        // } else if (state is AuthStateLoggedOut) {
        //   return const LoginView();
        // }
        // else {
        //   return const Scaffold(
        //     body: Center(child: CircularProgressIndicator(color: Colors.cyan)),
        //   );
        // }

        switch (state.status) {
          case CustomStatus.authenticated:
            return const NotesView();
          case CustomStatus.unauthenticated:
            return const LoginView();
          case CustomStatus.verifyingEmail:
            return const VerifyEmailView();
          case CustomStatus.loading:
          case CustomStatus.unknown:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.cyan),
              ),
            );
        }
      },
    );
  }
}
