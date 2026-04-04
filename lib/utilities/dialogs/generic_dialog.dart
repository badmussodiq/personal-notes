import 'package:flutter/material.dart';

// typedef DialogOptionBuilder<T> = Map<String, T?> Function();

typedef DialogWidgetBuilder<T> = List<Widget> Function(BuildContext context);

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogWidgetBuilder optionBuilder,
}) {
  // final options = optionBuilder();
  return showDialog(
    context: context,
    barrierColor: Color(Colors.accents.length),
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: optionBuilder(context),
      );
    },
  );
}
