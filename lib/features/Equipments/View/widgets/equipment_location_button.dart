import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pfe_gmao/features/Equipments/View/alerts/equipment_location_permission_denied_alert.dart';
import 'package:pfe_gmao/features/Equipments/View/alerts/equipment_location_service_alert.dart';

class EquipmentLocationButton extends StatelessWidget {
  final Function(Position) onPositionSelected;

  const EquipmentLocationButton({
    required this.onPositionSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: FilledButton.icon(
          icon: Icon(
            Icons.my_location_outlined,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(2),
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          onPressed: () async {
            await Permission.location.onDeniedCallback(() {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      const EquipmentLocationPermissionDeniedAlert(),
                );
              }
            }).onGrantedCallback(() async {
              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (serviceEnabled) {
                Position currentPosition =
                    await Geolocator.getCurrentPosition();
                onPositionSelected(currentPosition);
              } else {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => const EquipmentLocationServiceAlert(),
                    barrierDismissible: false,
                  );
                }
              }
            }).onPermanentlyDeniedCallback(() {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      const EquipmentLocationPermissionDeniedAlert(),
                );
              }
            }).request();
          },
          label: Text(
            "Locate equipment",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
