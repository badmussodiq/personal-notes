import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:new_begining/constants/routes.dart';
import 'package:new_begining/enums/menu_actions_enum.dart';
import 'package:new_begining/services/auth/auth_services.dart';
import 'package:new_begining/services/auth/auth_users.dart';
import 'package:new_begining/services/crud/notes_services.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesView();
}

class _NotesView extends State<NotesView> {
  late final NotesServices _notesServices;
  AuthUser get authUser => AuthServices.firebase().currentUser!;

  @override
  void initState() {
    _notesServices = NotesServices();
    _notesServices.initialize(user: authUser);
    super.initState();
  }

  @override
  void dispose() {
    _notesServices.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () {
              if (context.mounted) {
                Navigator.of(context).pushNamed(newNoteRoute);
              }
            },
            icon: const Icon(Icons.add),
          ),
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
      body: FutureBuilder(
        future: _notesServices.getOrCreateUser(email: authUser.email),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesServices.allNotes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Waiting for all notes......');
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No notes found');
                  }

                  final notes = snapshot.data!;
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return ListTile(
                        title: Text(
                          note.text.isEmpty ? 'Empty Note' : note.text,
                        ),
                        subtitle: Text('Synced: ${note.isSyncedWithCloud}'),
                      );
                    },
                  );
                  // switch (snapshot.connectionState) {
                  //   case ConnectionState.waiting:
                  //     return const Text('Waiting for all notes......');
                  //   default:
                  //     devtools.log("Inside the stream builder");
                  //     return const CircularProgressIndicator();
                  // }
                },
              );
            default:
              devtools.log("Inside the future builder");
              return const CircularProgressIndicator();
          }
        },
      ),
      // body: const Text(''),
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
