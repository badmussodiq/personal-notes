import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:new_begining/constants/routes.dart';
import 'package:new_begining/enums/menu_actions_enum.dart';
import 'package:new_begining/services/auth/auth_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        backgroundColor: Colors.amber,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  devtools.log(value.toString());
                  // display logout dialog
                  final shouldLogout = await showLogOutDialog(context);
                  if (!shouldLogout) return;
                  // ignore: use_build_context_synchronously
                  // sign out the user from firebase
                  await AuthServices.firebase().logOut();
                  if (context.mounted) {
                    // navigate to login view and remove all previous routes
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
                case MenuAction.settings:
                  devtools.log(value.toString());
                  break;
                case MenuAction.profile:
                  devtools.log(value.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text('Settings'),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Text('Dashboard'),
    );
  }
}

/// Show dialog
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        // these are the buttons
        actions: [
          // cancle button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          // sign out button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sign out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
