import 'package:flutter/material.dart';
import 'package:new_begining/services/auth/auth_services.dart';

class VerifyEmailView extends StatelessWidget {
  // final AuthUser user;

  const VerifyEmailView({super.key});
  // const VerifyEmailView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                await AuthServices.firebase().sendEmailVerification();
              },
              child: const Text(
                'Resend Email Verification',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
