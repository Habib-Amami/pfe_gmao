import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfe_gmao/features/Equipments/services/db_service.dart';

import '../model/equipment.dart';

// Import the profile model for updating profile information

class EquipmentPictureBottomSheet extends StatefulWidget {
  final String equipmentId;
  final String equipmentImageUrl;
  final String TagName;
  const EquipmentPictureBottomSheet({
    super.key,
    required this.equipmentId,
    required this.equipmentImageUrl,
    required this.TagName,
  });

  @override
  State<EquipmentPictureBottomSheet> createState() => Download();
}

class Download extends State<EquipmentPictureBottomSheet> {
  // Variable to store the selected image file
  File? imageFile;

  // Method to pick an image from the gallery or camera using the ImagePicker package
  //and crop it
  Future<CroppedFile?> pickImage({required ImageSource imageSource}) async {
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
        maxHeight: 96,
        maxWidth: 96,
      );
      if (croppedFile != null) {
        return croppedFile;
      } else {
        return null;
      }
    }
    return null;
  }

  // Method to upload the selected profile picture to Firebase Storage and
  //get it D URL
  Future<String> uploadProfilePicture({
    required String equipmentPictureRef,
    required File equipmentPicture,
  }) async {
    // Get references to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();
    Reference profilePicturesDir = rootReference.child("/equipment_pictures");
    Reference imageToUploadRef = profilePicturesDir.child(equipmentPictureRef);
    // Upload the profile picture file to Firebase Storage
    await imageToUploadRef.putFile(
      equipmentPicture,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    // Get the D URL of the uploaded image
    return await imageToUploadRef.getDownloadURL();
  }

  // Build the UI for the EquipmentPictureBottomSheet widget
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the selected or current profile picture
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: imageFile != null
                  ? CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: Image.file(
                          imageFile!,
                          height: 96,
                          width: 96,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 50,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(widget.equipmentImageUrl),
                      ),
                    ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text("Pick an image from :"),
            ),
            // Buttons to choose an image from the gallery or camera
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonal(
                    style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(2)),
                    onPressed: () async {
                      CroppedFile? pickedImage = await pickImage(
                        imageSource: ImageSource.gallery,
                      );
                      if (pickedImage != null) {
                        imageFile = File(pickedImage.path);
                      } else {
                        imageFile = null;
                      }
                      setState(() {});
                    },
                    child: const Text("Gallery"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FilledButton.tonal(
                    style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(2)),
                    onPressed: () async {
                      CroppedFile? pickedImage = await pickImage(
                        imageSource: ImageSource.camera,
                      );
                      if (pickedImage != null) {
                        imageFile = File(pickedImage.path);
                      } else {
                        imageFile = null;
                      }
                      setState(() {});
                    },
                    child: const Text("Camera"),
                  )
                ],
              ),
            ),
            // Button to save the selected image as the new profile picture
            SizedBox(
              width: 220,
              child: FilledButton(
                onPressed: () async {
                  if (imageFile != null) {
                    // Upload and update the new profile picture URL
                    String equipmentImageURL = await uploadProfilePicture(
                      equipmentPictureRef:
                          "${widget.TagName}_equipment_picture",
                      equipmentPicture: imageFile!,
                    );
                    await DatabaseService().updateEquipmentPicture(
                        imageUrl: equipmentImageURL,
                        idEquipment: widget.equipmentId);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                  }
                  // Display a success message as a snackbar
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Equipment picture changed successfully"),
                      ),
                    );
                  }
                },
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
