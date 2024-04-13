import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Alert dialog widget displayed when location service is disabled
class EquipmentLocationServiceAlert extends StatelessWidget {
  const EquipmentLocationServiceAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Location service disabled !"),
      content: const Text(
        "you can't locate an equipment, please enable the location service from the settings",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close the dialog
          child: const Text("cancel"),
        ),
        TextButton(
          // Open location settings and close the dialog
          onPressed: () => Geolocator.openLocationSettings().then(
            (_) => Navigator.pop(context),
          ),
          child: const Text(
            "Settings",
          ),
        )
      ],
    );
  }
}
