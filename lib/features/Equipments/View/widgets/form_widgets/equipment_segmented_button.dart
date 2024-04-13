import 'package:flutter/material.dart';

// Widget for a segmented button with icons and labels for each segment
class EquipmentSegmentedButton<T extends Enum> extends StatelessWidget {
  final List<T> enumValues; // List of enum values
  final List<Icon> buttonSegmentIconsList; // List of icons for each segment
  final Set<T> selected; // Set of selected enum values
  final void Function(Set<T>)?
      onSelectionChanged; // Callback function for selection change

  const EquipmentSegmentedButton({
    required this.enumValues,
    required this.buttonSegmentIconsList,
    required this.selected,
    this.onSelectionChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: SegmentedButton<T>(
          segments: <ButtonSegment<T>>[
            for (var entry in enumValues.asMap().entries)
              ButtonSegment(
                value: entry.value, // Current enum value
                // Label for the segment, using enum value name
                label: Text(
                  entry.toString().split('.').last.substring(
                        0,
                        entry.toString().split('.').last.length - 1,
                      ),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                // You can customize the icon as needed
                icon: buttonSegmentIconsList[entry.key],
              ),
          ],
          selected: selected, // Selected enum values
          onSelectionChanged: onSelectionChanged, // Selection change callback
          showSelectedIcon: false, // Whether to show selected icon
        ),
      ),
    );
  }
}
