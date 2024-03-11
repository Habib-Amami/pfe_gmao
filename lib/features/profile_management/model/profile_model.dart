import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../../firebase/firebase_services.dart';
import 'user.dart';

class ProfileModel {
  final _usersCollection = FirebaseService.instance.firestoreInstance
      .collection(userCollectionRef)
      .doc(FirebaseService.instance.authInstance.currentUser!.uid)
      .withConverter(
        fromFirestore: UserModel.fromFirestore,
        toFirestore: (UserModel user, _) => user.toFirestore(),
      );

  Future<void> reauthenticateWithPassword({required String password}) async {
    User user = FirebaseService.instance.authInstance.currentUser!;
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(
      credential,
    );
  }

  Future<void> updateUserName({required String newUserName}) async {
    await _usersCollection.update({usernameFieldRef: newUserName});
    await FirebaseService.instance.authInstance.currentUser!.updateDisplayName(
      newUserName,
    );
    await _usersCollection
        .update({updateAtFieldRef: FieldValue.serverTimestamp()});
  }

  Future<void> updateEmail({required String newEmail}) async {
    await FirebaseService.instance.authInstance.currentUser!
        .verifyBeforeUpdateEmail(
          newEmail,
        )
        .then(
          (_) => _usersCollection.update(
            {emailFieldRef: newEmail},
          ),
        );
    await _usersCollection
        .update({updateAtFieldRef: FieldValue.serverTimestamp()});
  }

  Future<void> updatePassword({required String newPassword}) async {
    await FirebaseService.instance.authInstance.currentUser!.updatePassword(
      newPassword,
    );
  }

  Future<void> updatePhoneNumber({required String newPhoneNumber}) async {
    await _usersCollection.update(
      {
        phoneNumberFieldRef: newPhoneNumber,
      },
    );
    await _usersCollection
        .update({updateAtFieldRef: FieldValue.serverTimestamp()});
  }

  // Method to upload the selected profile picture to Firebase Storage and
  //get it doawload URL
  Future<String> uploadProfilePicture({
    required String profilePictureRef,
    required File profilePicture,
  }) async {
    // Get references to Firebase Storage
    Reference rootReference = FirebaseStorage.instance.ref();
    Reference profilePicturesDir =
        rootReference.child("users_profile_pictures");
    Reference imageToUploadRef = profilePicturesDir.child(profilePictureRef);
    // Upload the profile picture file to Firebase Storage
    await imageToUploadRef.putFile(
      profilePicture,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    // Get the download URL of the uploaded image
    return await imageToUploadRef.getDownloadURL();
  }

  Future<void> updatePhotoURL({required String newPhotoURL}) async {
    await _usersCollection.update(
      {
        photoURLFieldRef: newPhotoURL,
      },
    );
    await _usersCollection
        .update({updateAtFieldRef: FieldValue.serverTimestamp()});
  }
}
