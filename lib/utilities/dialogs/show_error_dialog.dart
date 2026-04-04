// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:new_begining/components/CustomTextButtonComponent.dart';
import 'package:new_begining/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: "An error occured",
    content: text,
    optionBuilder: (context) => [
      CustomTextButtonComponent(
        text: "Ok",
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}

