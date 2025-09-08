import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_begining/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
      body: FutureBuilder(
        // initialize app
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    // keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      //
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-credential') {
                          print('Username or password incorrect');
                        }
                      }
                    },
                    child: Text('Login'),
                  ),
                ],
              );
            // case ConnectionState.none:
            //   break;
            // case ConnectionState.waiting:
            //   break;
            // case ConnectionState.active:
            //   break;
            default:
              return const Text('Loading....');
          }
        },
      ),
    );
  }
}
