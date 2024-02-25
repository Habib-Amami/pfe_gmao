import 'package:firebase_auth/firebase_auth.dart';

import '../../../../firebase_services.dart';

class RemoteLoginModel {
  Future<User?> login({
    required emailAddress,
    required password,
  }) async {
    UserCredential userCredential =
        await FirebaseService.instance.authInstance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return userCredential.user;
  }
}
