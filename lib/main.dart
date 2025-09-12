// entry point
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_begining/constants/routes.dart'
    show loginRoute, registerRoute, notesRoute;
import 'package:new_begining/firebase_options.dart';
import 'package:new_begining/views/authentication/login_view.dart';
import 'package:new_begining/views/authentication/register_view.dart';
import 'package:new_begining/views/home_page.dart';

import 'package:new_begining/views/root.dart';

void main() async {
  // initialize widget flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        notesRoute: (context) => const Home(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
      },
      // onGenerateRoute: (setting) {
      //   if (setting.name == '/verify/') {
      //     final user = setting.arguments as User;
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
