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
}
