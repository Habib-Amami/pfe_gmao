import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../alerts/equipment_camera_permission_denied_alert.dart';

// Widget for selecting a picture from the camera or gallery
// ignore: must_be_immutable
class EquipmentPictureButton extends StatelessWidget {
  final String buttonLable; // Label for the button
  final ImageSource imageSource; // Source of the image (camera or gallery)
  final Function(File?)
      onImageSelected; // Callback function for when an image is selected

  const EquipmentPictureButton({
    required this.buttonLable,
    required this.imageSource,
    required this.onImageSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    File? imageFile; // Variable to hold the selected image file
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
          if (context.mounted) {
            CroppedFile? pickedImge = await pickImage(
              imageSource: imageSource,
            );
            if (pickedImge != null) {
              imageFile = File(pickedImge.path); // Convert picked image to file
            } else {
              imageFile = null;
            }
            onImageSelected(
              imageFile, // Call the callback function with the selected image file
            );
          }
        }).onPermanentlyDeniedCallback(() {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) =>
                  const EquipmentCameraPermissionDeniedAlert(),
              barrierDismissible: false,
            );
          }
        }).request(); // Request camera permission
      },
      label: Text(
        buttonLable, // Button label
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  // Future method to pick an image from the gallery or camera
  Future<CroppedFile?> pickImage({
    required ImageSource imageSource, // Image source (camera or gallery)
  }) async {
    // Use ImagePicker to pick an image
    ImagePicker picker = ImagePicker();
    // Pick image from source
    final XFile? pickedImage = await picker.pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 100,
    );
    if (pickedImage != null) {
      // If image is picked
      // Crop the selected image using the ImageCropper package
      ImageCropper cropper = ImageCropper();
      CroppedFile? croppedFile = await cropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        maxHeight: 145,
        maxWidth: 145,
      );
      if (croppedFile != null) {
        return croppedFile; // Return the cropped image file
      } else {
        return null; // Return the cropped image file
      }
    }
    return null; // Return null if no image is picked
  }
}
