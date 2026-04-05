import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/constants/routes.dart';
import 'package:new_begining/services/bloc/custom/custom_bloc.dart';
import 'package:new_begining/services/bloc/custom/custom_state.dart';
import 'package:new_begining/utilities/dialogs/show_error_dialog.dart'
    show showErrorDialog;
import '../../services/bloc/custom/custom_event.dart';
import '../../utilities/controllers/loading_screen.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _email;

  // bool _loading = false;

  //This method set the initial state of application
  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  // This method dispose our states
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomBloc, CustomState>(
      listener: (context, state) async {
        if (state.exception != null) {
          await showErrorDialog(context, state.exception!.message);
        }

        if (context.mounted && state.isLoading) {
          LoadingScreen().show(context: context, text: 'Loading...');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Forget Password'),
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
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  context.read<CustomBloc>().add(
                    CustomEventSendPasswordReset(email: email),
                  );
                  // _email.dispose();
                },
                child: !state.isLoading
                    ? Text('Send Reset Link')
                    : const CircularProgressIndicator(
                        padding: EdgeInsets.all(4.0),
                      ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text('Login'),
              ),
            ],
          ),
        );
      },
      // ),
    );
  }
}
