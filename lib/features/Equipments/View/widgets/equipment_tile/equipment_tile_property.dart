import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Widget for displaying a property of equipment
class EquipmentTileProperty extends StatelessWidget {
  final String propertyName;
  final String propertyValue;

  const EquipmentTileProperty({
    required this.propertyName,
    required this.propertyValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      // Row for displaying property name and value
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            height: 21,
            // Text widget for displaying property name
            child: Text(
              propertyName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          //adding spacing between property name and value
          const SizedBox(
            width: 10,
          ),
          Expanded(
            // Text widget for displaying property value
            child: Text(
              propertyValue,
            ),
          )
        ],
      ),
    );
  }
}
