import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/services/auth/auth_services.dart';
import 'package:new_begining/services/auth/bloc/auth_bloc.dart' show AuthBloc;
import 'package:new_begining/services/auth/bloc/auth_events.dart';
import 'package:new_begining/services/auth/bloc/auth_state.dart' show AuthStates;

class VerifyEmailView extends StatelessWidget {
  // final AuthUser user;

  const VerifyEmailView({super.key});

  // const VerifyEmailView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthStates>(
      listener: (context, state) async {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            // title: const Text('Verify Email'),
            // backgroundColor: Colors.amber,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "We've send you an email verification, Please open it to verify your account",
                ),
                const Text(
                  "If you haven't received a verification email yet, press the button below",
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    await AuthServices.firebase().sendEmailVerification();
                  },
                  child: const Text(
                    'Resend Email Verification',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    context.read<AuthBloc>().add(AuthEventLogout());
                  },
                  child: const Text(
                    'Back To Login',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/**
 *
 */
