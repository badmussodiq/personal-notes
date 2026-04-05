import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/bloc/custom/custom_bloc.dart';
import '../../services/bloc/custom/custom_event.dart';
import '../../services/bloc/custom/custom_state.dart';

class VerifyEmailView extends StatelessWidget {

  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomBloc, CustomState>(
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
                    context.read<CustomBloc>().add(
                      const CustomEventSendEmailVerification(),
                    );
                  },
                  child: const Text(
                    'Resend Email Verification',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    context.read<CustomBloc>().add(CustomEventLogout());
                  },
                  child: const Text(
                    'Login',
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
