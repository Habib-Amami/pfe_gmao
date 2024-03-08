import 'package:firebase_auth/firebase_auth.dart';

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
    _usersCollection.update({usernameFieldRef: newUserName});
    await FirebaseService.instance.authInstance.currentUser!.updateDisplayName(
      newUserName,
    );
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
  }

  Future<void> updatePhotoURL({required String newPhotoURL}) async {
    await _usersCollection.update(
      {
        photoURLFieldRef: newPhotoURL,
      },
    );
  }
}
