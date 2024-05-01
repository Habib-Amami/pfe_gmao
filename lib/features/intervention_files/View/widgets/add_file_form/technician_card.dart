import 'package:flutter/material.dart';

// Define a custom widget called TechnicianCard
//this widget will display a card with a checkbox
//check what type of technician will execute the intervention

class TechnicianCard extends StatelessWidget {
  final String title; // Title displayed on the card
  final TextStyle? titleStyle; // Style for the title text (optionial)
  final String subtitle; // Subtitle displayed on the card
  final TextStyle? subtitleStyle; // Style for the subtitle text (optionial)
  final bool checkboxValue; // Current state of the checkbox
  final void Function(bool?)
      onChanged; // Callback function when checkbox state changes
  const TechnicianCard({
    super.key,
    required this.title,
    this.titleStyle,
    required this.subtitle,
    this.subtitleStyle,
    required this.checkboxValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        title: Text(
          title,
          // Apply custom title style if provided, otherwise use default style
          style: titleStyle ??
              TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        subtitle: Text(
          subtitle,
          // Apply custom subtitle style if provided, otherwise use default style
          style: subtitleStyle ?? Theme.of(context).textTheme.labelSmall,
        ),
        value: checkboxValue,
        // Callback function triggered when checkbox state changes
        onChanged: onChanged,
      ),
    );
  }
}
