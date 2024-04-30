import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class InterventionFileStatus extends StatelessWidget {
  final String status;
  const InterventionFileStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    switch (status.toLowerCase()) {
      case 'confirmed':
        iconData = Ionicons.checkmark_sharp;
        iconColor = Colors.green;
        break;
      case 'denied':
        iconData = Icons.close_rounded;
        iconColor = Colors.red;
        break;
      case 'in progress':
        iconData = Ionicons.pause_circle_outline;
        iconColor = Colors.yellow;
        break;
      default:
        iconData = Icons.error_outline;
        iconColor = Colors.grey;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("Status:"),
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
