import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Alert dialog widget displayed when location permission is denied
class EquipmentLocationPermissionDeniedAlert extends StatefulWidget {
  const EquipmentLocationPermissionDeniedAlert({super.key});

  @override
  State<EquipmentLocationPermissionDeniedAlert> createState() =>
      _EquipmentLocationPermissionDeniedAlertState();
}

class _EquipmentLocationPermissionDeniedAlertState
    extends State<EquipmentLocationPermissionDeniedAlert>
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
          "you can't locate an equipment, please change the location permission from the settings",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text("cancel"),
          ),
          TextButton(
            onPressed: () => openAppSettings().then(
              (_) => Navigator.pop(
                  context), // Open app settings and close the dialog
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
