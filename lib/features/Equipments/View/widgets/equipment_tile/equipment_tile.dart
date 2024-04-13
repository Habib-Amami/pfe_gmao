import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pfe_gmao/features/Equipments/View/equipment_map.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/alerts/equipment_location_permission_denied_alert.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/alerts/equipment_location_service_alert.dart';

import '../../../model/equipment.dart';
import 'equipment_tile_image.dart';
import 'equipment_tile_property.dart';
import 'equipment_tile_status.dart';
import 'equipment_tile_title.dart';

// Widget for displaying an expansion tile representing equipment details
class EquipmentTile extends StatelessWidget {
  final Equipment equipment;

  const EquipmentTile({
    required this.equipment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ExpansionTile widget to expand and show more details
    return ExpansionTile(
      // EquipmentTileTitle widget for displaying equipment title
      title: EquipmentTileTitle(
        tileTitle: equipment.TagName,
      ),
      // EquipmentTileImage widget for displaying equipment image
      leading: EquipmentTileImage(
        equipmentImageURL: equipment.Photo,
      ),
      // EquipmentTileStatus widget for displaying equipment status
      subtitle: EquipmentTileStatus(
        equipmentStatus: equipment.Status,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              // EquipmentTileProperty widget for displaying equipment description
              EquipmentTileProperty(
                propertyName: "Description:",
                propertyValue: equipment.Description,
              ),
              // EquipmentTileProperty widget for displaying equipment description
              EquipmentTileProperty(
                propertyName: "Created at:",
                propertyValue: DateFormat(
                  'dd-MM-yyyy',
                ).format(
                  DateTime.fromMillisecondsSinceEpoch(
                    equipment.CreatedOn.seconds * 1000,
                  ),
                ),
              ),
              // EquipmentTileProperty widget for displaying equipment priority
              EquipmentTileProperty(
                propertyName: "Priority:",
                propertyValue: equipment.Priority,
              ),
              // EquipmentTileProperty widget for displaying equipment discipline
              EquipmentTileProperty(
                propertyName: "Discipline:",
                propertyValue: equipment.Discipline,
              ),
              // EquipmentTileProperty widget for displaying equipment workshop
              EquipmentTileProperty(
                propertyName: "Workshop:",
                propertyValue: equipment.Workshop,
              ),
              // EquipmentTileProperty widget for displaying equipment area
              EquipmentTileProperty(
                propertyName: "Area:",
                propertyValue: equipment.Area,
              ),
            ],
          ),
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.location_on_rounded,
          ),
          label: const Text(
            "Show equipment location",
          ),
          onPressed: () async {
            await Permission.location.onDeniedCallback(
              () {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const EquipmentLocationPermissionDeniedAlert();
                    },
                  );
                }
              },
            ).onGrantedCallback(
              () async {
                bool serviceEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (serviceEnabled) {
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EquipmentMap(
                            equipmentLatitude: double.parse(
                              equipment.Latitude,
                            ),
                            equipmentLongitude: double.parse(
                              equipment.Longitude,
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const EquipmentLocationServiceAlert(),
                      barrierDismissible: false,
                    );
                  }
                }
              },
            ).onPermanentlyDeniedCallback(
              () {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const EquipmentLocationPermissionDeniedAlert();
                    },
                  );
                }
              },
            ).request();
          },
        ),
      ],
    );
  }
}
