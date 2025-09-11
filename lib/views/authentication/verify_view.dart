import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  final User user;

  const VerifyEmailView({super.key, required this.user});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Please Verify Your Email address before you can continue'),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () async {
            await widget.user.sendEmailVerification();
          },
          child: const Text('Send email verification'),
        ),
      ],
    );
  }
}
