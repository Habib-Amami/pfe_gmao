import 'package:flutter/material.dart';

class EquipmentSegmentedButton<T extends Enum> extends StatelessWidget {
  final List<T> enumValues;
  final List<Icon> buttonSegmentIconsList;
  final Set<T> selected;
  final void Function(Set<T>)? onSelectionChanged;

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
                value: entry.value,
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
          selected: selected,
          onSelectionChanged: onSelectionChanged,
          showSelectedIcon: false,
        ),
      ),
    );
  }
}
