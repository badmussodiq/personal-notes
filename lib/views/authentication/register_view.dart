import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_begining/constants/routes.dart'
    show loginRoute;
import 'package:new_begining/services/bloc/custom/custom_bloc.dart';
import 'package:new_begining/services/bloc/custom/custom_state.dart';
import 'package:new_begining/utilities/dialogs/show_error_dialog.dart'
    show showErrorDialog;
import '../../services/bloc/custom/custom_event.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email, _password;

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
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 11.0,
                  vertical: 10.0,
                ),
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
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<CustomBloc>().add(
                    CustomEventRegister(email: email, password: password),
                  );
                  // try {
                  //   await AuthServices.firebase().createUser(
                  //     email: email,
                  //     password: password,
                  //   );
                  //   // set load state to false
                  //   loading = false;
                  //   await AuthServices.firebase().sendEmailVerification();
                  //
                  //   if (context.mounted) {
                  //     Navigator.of(context).pushNamed(verifyEmailRoute);
                  //   }
                  // } on WeakPasswordAuthException catch (_) {
                  //
                  //   if (context.mounted) {
                  //     await showErrorDialog(context, 'Weak Password');
                  //   }
                  // } on EmailAlreadyInUseAuthException catch (_) {
                  //
                  //   if (context.mounted) {
                  //     await showErrorDialog(context, 'User already Exist');
                  //   }
                  // } on InvalidEmailAuthException catch (_) {
                  //
                  //   if (context.mounted) {
                  //     await showErrorDialog(context, 'Invalid Email format');
                  //   }
                  // } on GenericAuthException catch (e) {
                  //   if (context.mounted) {
                  //
                  //     await showErrorDialog(context, e.toString());
                  //   }
                  // }
                },
                child: !state.isLoading
                    ? Text('Register')
                    : const CircularProgressIndicator(),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (context) => LoginView()),
                  //   );
                  // });
                },
                child: const Text('Already have an account? Login here!'),
              ),
            ],
          ),
        );
      },
    );
  }
}
