import 'package:flutter/material.dart';

// Custom widget to display a message when selection is empty
class EmptySelectionContainer extends StatelessWidget {
  final String message; // Message to be displayed
  const EmptySelectionContainer({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
          color: Colors.grey[300],
        ),
        child: Center(
          child: Text(
            // Display the message text
            message,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
