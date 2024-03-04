import 'package:firebase_auth/firebase_auth.dart';

import '../model/login_local_model.dart';
import '../model/login_remote_model.dart';

class LoginController {
  final RemoteLoginModel _remoteLoginModel = RemoteLoginModel();
  final LocalLoginModel _localLoginModel = LocalLoginModel();

  Future<User> loginUser(
      {required String emailAddress, required String password}) async {
    try {
      User? user = await _remoteLoginModel.login(
        emailAddress: emailAddress,
        password: password,
      );
      if (user != null) {
        return user;
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  void rememberMe({
    required bool isChecked,
    required String email,
    required String password,
  }) async {
    if (isChecked) {
      await _localLoginModel.saveCredentialsToLocalDB(
        email: email,
        password: password,
      );
    }
  }

  String? getCachedEmailFromLocalDB() {
    return _localLoginModel.getCachedEmail();
  }

  String? getCachedPasswordFromLocalDB() {
    return _localLoginModel.getCachedPassword();
  }
}
