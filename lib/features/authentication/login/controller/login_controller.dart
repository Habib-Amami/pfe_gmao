import 'package:firebase_auth/firebase_auth.dart';

import '../model/login_model.dart';

class LoginController {
  final LoginModel _loginModel = LoginModel();

  Future<User> loginUser(
      {required String emailAddress, required String password}) async {
    try {
      User? user = await _loginModel.login(
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
      await _loginModel.saveCredentialsToLocalDB(
        email: email,
        password: password,
      );
    }
  }

  String? getCachedEmailFromLocalDB() {
    return _loginModel.getCachedEmail();
  }

  String? getCachedPasswordFromLocalDB() {
    return _loginModel.getCachedPassword();
  }
}
