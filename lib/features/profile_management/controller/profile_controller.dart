import 'dart:io';

import '../model/profile_model.dart';

// ignore: camel_case_types
class reauthenticate {
  final ProfileModel _profileModel = ProfileModel();

  // Verify the entered password for reauthenticate
  Future<bool> verifyPassword({required String enteredPassword}) async {
    try {
      await _profileModel.reauthenticateWithPassword(
        password: enteredPassword,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update the user's username.
  Future<void> updateUserName({required String newUserName}) async {
    try {
      await _profileModel.updateUserNameDB(newUserName: newUserName);
    } catch (e) {
      rethrow;
    }
  }

  // Update the user's phone number
  Future<void> updatePhoneNumber({required String newPhoneNumber}) async {
    try {
      await _profileModel.updatePhoneNumberDB(newPhoneNumber: newPhoneNumber);
    } catch (e) {
      rethrow;
    }
  }

  // Update the user's email
  Future<void> updateEmail({
    required String newEmail,
  }) async {
    await _profileModel.updateEmailDB(
      newEmail: newEmail,
    );
  }

  // Update the user's password
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _profileModel.updatePasswordDB(
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Method to upload the selected profile picture to Firebase Storage and
  //get it download URL
  Future<String> uploadProfilePicture({
    required String profilePictureRef,
    required File profilePicture,
  }) async {
    return await _profileModel.uploadProfilePictureDB(
      profilePictureRef: profilePictureRef,
      profilePicture: profilePicture,
    );
  }

  Future<void> updatePhotoURL({required String newPhotoURL}) async {
    await _profileModel.updatePhotoURLDB(
      newPhotoURL: newPhotoURL,
    );
  }
}
