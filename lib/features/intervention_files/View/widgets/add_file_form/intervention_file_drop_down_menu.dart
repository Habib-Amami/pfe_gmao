import 'package:flutter/material.dart';

// Widget for displaying a dropdown menu for intervention form
class InterventionFileDropDownMenu extends StatelessWidget {
  final List<IconData> iconsList;
  final List<String> valuesList; // List of dropdown menu items
  final Object? initialValue; // Selected value
  final void Function(dynamic)?
      onChanged; // Callback function for value changes

  InterventionFileDropDownMenu({
    required this.iconsList,
    required this.valuesList,
    required this.initialValue,
    required this.onChanged,
    super.key,
  })  : assert(
          iconsList.length == valuesList.length,
          "values list length must be equal the icons list length",
        ),
        assert(
          valuesList.contains(initialValue),
          "initial values must me a elemnt from the values list",
        );

  @override
  Widget build(BuildContext context) {
    Map<String, IconData> valuesTOicons =
        Map.fromIterables(valuesList, iconsList);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
          width: 1.2,
        ),
      ),
      child: Center(
        // DropdownButtonFormField widget
        child: DropdownButtonFormField(
          padding: const EdgeInsets.only(right: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(valuesTOicons[initialValue]),
            border: InputBorder.none,
          ),
          items: valuesList
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
          value: initialValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
