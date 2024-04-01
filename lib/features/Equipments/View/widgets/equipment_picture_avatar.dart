import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

class EquipmentPictureAvatar extends StatelessWidget {
  final File? equipmentPictureFile;

  const EquipmentPictureAvatar({
    this.equipmentPictureFile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: equipmentPictureFile != null
            ? SizedBox(
                height: 150,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.file(
                      equipmentPictureFile!,
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
                  child: const CircleAvatar(
                    radius: 72,
                    // Using NetworkImage to load the default picture
                    backgroundImage: NetworkImage(
                      defaultEquipmentPicture,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
