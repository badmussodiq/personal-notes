import 'package:flutter/widgets.dart';
import 'package:new_begining/components/CustomTextButtonComponent.dart';
import 'package:new_begining/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionBuilder: (context) => [
      CustomTextButtonComponent(
        text: "Cancel",
        onPressed: () => Navigator.pop(context, false),
      ),
      CustomTextButtonComponent(
        text: "Delete",
        onPressed: () => Navigator.pop(context, true),
      ),
    ],
  ).then((value) => value ?? false);
}
