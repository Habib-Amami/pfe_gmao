import 'package:flutter/material.dart';

// Widget for displaying the title of equipment tile
class EquipmentTileTitle extends StatelessWidget {
  final String tileTitle;

  const EquipmentTileTitle({
    required this.tileTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Text widget for displaying the title
    return Text(
      tileTitle, // Title texts
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
