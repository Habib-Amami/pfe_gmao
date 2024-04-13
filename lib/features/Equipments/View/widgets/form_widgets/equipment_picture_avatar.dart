import 'dart:io';

import 'package:flutter/material.dart';

// Widget for displaying the equipment picture as an avatar
class EquipmentPictureAvatar extends StatelessWidget {
  final File?
      equipmentPictureFile; // File object representing the equipment picture
  final String defaultPictureURL; // URL of the default picture

  const EquipmentPictureAvatar({
    required this.equipmentPictureFile,
    required this.defaultPictureURL,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        // Check if equipment picture file is not null
        child: equipmentPictureFile != null
            ? SizedBox(
                height: 150,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.file(
                      equipmentPictureFile!, // Display equipment picture
                      height: 145,
                      width: 145,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 150,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 150,
                  child: CircleAvatar(
                    radius: 72,
                    // Using NetworkImage to load the default picture
                    backgroundImage: NetworkImage(
                      defaultPictureURL,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
