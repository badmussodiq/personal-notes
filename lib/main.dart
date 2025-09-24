// entry point
import 'package:flutter/material.dart';

import 'package:new_begining/constants/routes.dart'
    show
        loginRoute,
        createOrUpdateNoteRoute,
        notesRoute,
        registerRoute,
        verifyEmailRoute;

import 'package:new_begining/services/auth/auth_services.dart'
    show AuthServices;

import 'package:new_begining/views/authentication/login_view.dart'
    show LoginView;

import 'package:new_begining/views/authentication/register_view.dart'
    show RegisterView;

import 'package:new_begining/views/authentication/verify_view.dart'
    show VerifyEmailView;
import 'package:new_begining/views/notes/create_update_note_view.dart'
    show CreateUpdateNoteView;
import 'package:new_begining/views/notes/notes_view.dart' show NotesView;

import 'package:new_begining/views/root.dart' show Root;

void main() async {
  // initialize widget flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  await AuthServices.firebase().initialize();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Root(),
      routes: {
        notesRoute: (context) => const NotesView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
      // onGenerateRoute: (setting) {
      //   if (setting.name == verifyEmailRoute) {
      //     final user = setting.arguments as AuthUser;
      //     return MaterialPageRoute(
      //       builder: (context) {
      //         return VerifyEmailView(user: user);
      //       },
      //     );
      //   }
      //   return null;
      // },
    ),
  );
}
