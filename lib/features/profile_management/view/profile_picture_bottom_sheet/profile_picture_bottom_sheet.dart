import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/profile_controller.dart';

class ProfilePictureBottomsheet extends StatefulWidget {
  final String profileImageURL;
  final String serialNumber;
  const ProfilePictureBottomsheet({
    super.key,
    required this.profileImageURL,
    required this.serialNumber,
  });

  @override
  State<ProfilePictureBottomsheet> createState() =>
      _ProfilePictureBottomsheetState();
}

class _ProfilePictureBottomsheetState extends State<ProfilePictureBottomsheet> {
  // Create an instance of the ProfileController for managing profile-related actions
  final ProfileController _profileController = ProfileController();
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

  // Build the UI for the ProfilePictureBottomsheet widget
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
                        backgroundImage: NetworkImage(widget.profileImageURL),
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
                      CroppedFile? pickedImge = await pickImage(
                        imageSource: ImageSource.gallery,
                      );
                      if (pickedImge != null) {
                        imageFile = File(pickedImge.path);
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
                      CroppedFile? pickedImge = await pickImage(
                        imageSource: ImageSource.camera,
                      );
                      if (pickedImge != null) {
                        imageFile = File(pickedImge.path);
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
                    String profileImageURL =
                        await _profileController.uploadProfilePicture(
                      profilePictureRef:
                          "${widget.serialNumber}_profile_picture",
                      profilePicture: imageFile!,
                    );
                    await _profileController.updatePhotoURL(
                      newPhotoURL: profileImageURL,
                    );
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
                        content: Text("Profile picture changed successfully"),
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
