import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/profile_model.dart';

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
  File? imageFile;

  Future<CroppedFile?> pickImage({required ImageSource imageSource}) async {
    ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 100,
    );
    if (pickedImage != null) {
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

  Future<String> uploadProfilePicture({
    required String profilePictureRef,
    required File profilePicture,
  }) async {
    Reference rootReference = FirebaseStorage.instance.ref();
    Reference profilePicturesDir =
        rootReference.child("users_profile_pictures");
    Reference imageToUploadRef = profilePicturesDir.child(profilePictureRef);
    await imageToUploadRef.putFile(
      profilePicture,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await imageToUploadRef.getDownloadURL();
  }

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
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
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
                  ElevatedButton(
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
            SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: () async {
                  if (imageFile != null) {
                    String profileImageURL = await uploadProfilePicture(
                      profilePictureRef:
                          "${widget.serialNumber}_profile_picture",
                      profilePicture: imageFile!,
                    );
                    await ProfileModel().updatePhotoURL(
                      newPhotoURL: profileImageURL,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                  }
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
