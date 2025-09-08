import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_begining/firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: const Color.fromARGB(255, 121, 121, 20),
      ),
      body: FutureBuilder(
        // initialize app
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              debugPrint('user info=> $user');
              if (user?.emailVerified ?? false) {
                debugPrint('YOU ARE VERIFIED');
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  debugPrint('YOU ARE NOT VERIFIED!');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context1) => const VerifyEmailView(),
                    ),
                  );
                });
              }

              return const Text('Done');
            default:
              return const Text('Loading....');
          }
        },
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return const Text("Verify your email");
  }
}
