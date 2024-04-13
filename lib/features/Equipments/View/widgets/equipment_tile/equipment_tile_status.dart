import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// Widget for displaying the status of equipment
class EquipmentTileStatus extends StatelessWidget {
  final String equipmentStatus;

  const EquipmentTileStatus({
    required this.equipmentStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    // Switch statement to determine the icon and color based on equipment status
    switch (equipmentStatus.toLowerCase()) {
      case 'active':
        iconData = Ionicons.checkmark_sharp;
        iconColor = Colors.green;
        break;
      case 'shutdown':
        iconData = Icons.power_off_outlined;
        iconColor = Colors.red;
        break;
      case 'standby':
        iconData = Ionicons.pause_circle_outline;
        iconColor = Colors.yellow;
        break;
      default:
        iconData = Icons.error_outline;
        iconColor = Colors.grey;
    }

    // Row for displaying status label and icon
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Status:",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        const SizedBox(width: 10),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
          ),
          child: Icon(
            size: 18,
            iconData,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
