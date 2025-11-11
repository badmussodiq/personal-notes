import 'package:flutter/widgets.dart';
import 'package:new_begining/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNotDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Sharing",
    content: "You cannot share an empty note!",
    optionBuilder: () => {"OK": null},
  );
}
