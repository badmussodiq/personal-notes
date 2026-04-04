import 'package:flutter/widgets.dart';
import 'package:new_begining/components/CustomTextButtonComponent.dart';
import 'package:new_begining/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNotDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Sharing",
    content: "You cannot share an empty note!",
    optionBuilder: (context) => [
      CustomTextButtonComponent(
        text: "Ok",
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}
