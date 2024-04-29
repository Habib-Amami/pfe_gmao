import 'package:flutter/material.dart';

// Widget for displaying a title in the intervntion file form
class InterventionFileFormTitle extends StatelessWidget {
  final String title; // Title text
  final TextStyle? textStyle; // Text style for the title
  const InterventionFileFormTitle({
    required this.title,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        // Title text
        title,
        // Text style, use provided style or default theme style
        style: textStyle ?? Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.start,
      ),
    );
  }
}
