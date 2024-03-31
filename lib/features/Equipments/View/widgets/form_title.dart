import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  const FormTitle({
    required this.title,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: textStyle ?? Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.start,
      ),
    );
  }
}
