import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
          onPressed: () => Navigator.pop(context),
          child: const Text("cancel"),
        ),
        TextButton(
          onPressed: () => openAppSettings().then(
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
