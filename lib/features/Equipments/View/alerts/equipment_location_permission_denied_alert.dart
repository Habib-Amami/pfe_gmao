import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EquipmentLocationPermissionDeniedAlert extends StatelessWidget {
  const EquipmentLocationPermissionDeniedAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Permission denied !"),
      content: const Text(
        "you can't locate an equipment, please change the location permission from the settings",
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
