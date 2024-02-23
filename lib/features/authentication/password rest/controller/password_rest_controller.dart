import 'package:firebase_auth/firebase_auth.dart';

import '../../password%20rest/model/password_rest_model.dart';

class PasswordRestController {
  final PasswordRestModel _passwordRestModel = PasswordRestModel();

  Future<void> passwordRestUser({required String email}) async {
    try {
      await _passwordRestModel.passwordRest(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
