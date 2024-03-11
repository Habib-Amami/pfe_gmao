import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionDeniedAlert extends StatelessWidget {
  const CameraPermissionDeniedAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Permissiondenied !"),
      content: const Text(
        "you can't manage your profile picture, please change the camera permission from the settings",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("cancel"),
        ),
        TextButton(
          onPressed: () => openAppSettings(),
          child: const Text(
            "Settings",
          ),
        )
      ],
    );
  }
}
