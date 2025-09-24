import 'package:flutter/material.dart';
import 'package:new_begining/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
  String content,
  String title,
) {
  return showGenericDialog<bool>(
    context: context,
    title: title,
    content: content,
    optionBuilder: () => {'Cancel': false, 'Log out': true},
  ).then((value) => value ?? false);
}

  // return showDialog(
  //   context: context,
  //   builder: (context) {
  //     return AlertDialog(
  //       title: const Text('Sign out'),
  //       content: const Text('Are you sure you want to sign out?'),
  //       // these are the buttons
  //       actions: [
  //         // cancle button
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop(false);
  //           },
  //           child: const Text('Cancel'),
  //         ),
  //         // sign out button
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop(true);
  //           },
  //           child: const Text('Sign out'),
  //         ),
  //       ],
  //     );
  //   },
  // ).then((value) => value ?? false);
