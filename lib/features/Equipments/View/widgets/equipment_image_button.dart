import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../alerts/equipment_camera_permission_denied_alert.dart';

// ignore: must_be_immutable
class EquipmentPictureButton extends StatelessWidget {
  final String buttonLable;
  final ImageSource imageSource;
  final Function(File?) onImageSelected;

  const EquipmentPictureButton({
    required this.buttonLable,
    required this.imageSource,
    required this.onImageSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    File? imageFile;
    return FilledButton.icon(
      icon: Icon(
        Icons.add_a_photo_outlined,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(2),
        backgroundColor: MaterialStatePropertyAll(
          Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
      onPressed: () async {
        // Handle camera permissions and image picking
        await Permission.camera.onDeniedCallback(() {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) =>
                  const EquipmentCameraPermissionDeniedAlert(),
              barrierDismissible: false,
            );
          }
        }).onGrantedCallback(() async {
          CroppedFile? pickedImge = await pickImage(
            imageSource: imageSource,
          );
          if (pickedImge != null) {
            imageFile = File(pickedImge.path);
          } else {
            imageFile = null;
          }
          onImageSelected(
            imageFile,
          );
        }).onPermanentlyDeniedCallback(() {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) =>
                  const EquipmentCameraPermissionDeniedAlert(),
              barrierDismissible: false,
            );
          }
        }).request();
      },
      label: Text(
        buttonLable,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  // Future method to pick an image from the gallery or camera
  Future<CroppedFile?> pickImage({
    required ImageSource imageSource,
  }) async {
    // Use ImagePicker to pick an image
    ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 100,
    );
    if (pickedImage != null) {
      // Crop the selected image using the ImageCropper package
      ImageCropper cropper = ImageCropper();
      CroppedFile? croppedFile = await cropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        maxHeight: 145,
        maxWidth: 145,
      );
      if (croppedFile != null) {
        return croppedFile;
      } else {
        return null;
      }
    }
    return null;
  }
}
