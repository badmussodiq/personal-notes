import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/constants/routes.dart';
import 'package:new_begining/services/bloc/custom/custom_bloc.dart';
import 'package:new_begining/services/bloc/custom/custom_state.dart';
import 'package:new_begining/utilities/dialogs/show_error_dialog.dart'
    show showErrorDialog;
import '../../services/bloc/custom/custom_event.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email, _password;
  // bool _loading = false;

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
    return BlocConsumer<CustomBloc, CustomState>(
      listener: (context, state) async {
        if(state.exception != null){
          await showErrorDialog(context, state.exception!.message);
        }else if(state.isLoading){

        }
      },
      builder: (context, state) {
        return Scaffold(
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
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                  ),
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
                  // Get email and password
                  final email = _email.text;
                  final password = _password.text;
                  context.read<CustomBloc>().add(
                    CustomEventLogin(email: email, password: password),
                  );
                },
                child: !state.isLoading
                    ? Text('Login')
                    : const CircularProgressIndicator(
                        padding: EdgeInsets.all(4.0),
                      ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('Not registered yet? Register here!'),
              ),
            ],
          ),
        );
      },
      // ),
    );
  }
}
