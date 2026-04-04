import 'package:flutter/material.dart';

class CustomTextButtonComponent extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomTextButtonComponent({
    super.key,
    required this.text,

    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(text));
  }
}
