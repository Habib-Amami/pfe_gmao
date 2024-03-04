import 'package:firebase_auth/firebase_auth.dart';

import '../../../firebase/firebase_references.dart';
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

  // Future<User?> getProfileInfo() async {
  //   final docSnap = await _usersCollection.get();
  //   final userInfo = docSnap.data();
  //   return userInfo;
  // }
  Future<void> reauthenticateWithNewPassword({required String password}) async {
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
    _usersCollection.update({"userName": newUserName});
    await FirebaseService.instance.authInstance.currentUser!.updateDisplayName(
      newUserName,
    );
  }

  Future<void> updateEmail(
      {required String newEmail, required String password}) async {
    await reauthenticateWithNewPassword(password: password);
    await FirebaseService.instance.authInstance.currentUser!
        .verifyBeforeUpdateEmail(
          newEmail,
        )
        .then(
          (_) => _usersCollection.update(
            {"email": newEmail},
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
        "phoneNumber": newPhoneNumber,
      },
    );
  }
}
