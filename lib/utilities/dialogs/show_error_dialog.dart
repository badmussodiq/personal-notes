// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:new_begining/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: "An error occured",
    content: text,
    optionBuilder: ()=> {
      'Ok': null,
    },
  );
}

// import 'package:flutter/material.dart';

// Future<void> showErrorDialog(BuildContext context, String text) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('An error occurred'),
//         content: Text(text),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }
