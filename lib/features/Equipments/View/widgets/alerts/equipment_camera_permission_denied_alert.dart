import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Alert dialog widget displayed when camera permission is denied
class EquipmentCameraPermissionDeniedAlert extends StatefulWidget {
  const EquipmentCameraPermissionDeniedAlert({super.key});

  @override
  State<EquipmentCameraPermissionDeniedAlert> createState() =>
      _EquipmentCameraPermissionDeniedAlertState();
}

class _EquipmentCameraPermissionDeniedAlertState
    extends State<EquipmentCameraPermissionDeniedAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeScaleTransition(
      animation: _animation,
      child: AlertDialog(
        title: const Text("Permission denied !"),
        content: const Text(
          "you can't add a equipment's picture, please change the camera permission from the settings",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text("cancel"),
          ),
          TextButton(
            // Open app settings and close the dialog
            onPressed: () => openAppSettings().then(
              (_) => Navigator.pop(context),
            ),
            child: const Text(
              "Settings",
            ),
          )
        ],
      ),
    );
  }
}
