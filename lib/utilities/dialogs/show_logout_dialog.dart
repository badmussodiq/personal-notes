import 'package:flutter/material.dart';
import 'package:new_begining/components/CustomTextButtonComponent.dart';
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
    optionBuilder: (context) => [
      CustomTextButtonComponent(
        text: "Cancel",
        onPressed: () => Navigator.pop(context, false),
      ),
      CustomTextButtonComponent(
        text: "Log out",
        onPressed: () => Navigator.pop(context, true),
      ),
    ],
  ).then((value) => value ?? false);
}
