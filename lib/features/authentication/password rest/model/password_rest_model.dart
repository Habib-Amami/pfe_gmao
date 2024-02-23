import '../../../../firebase_services.dart';

class PasswordRestModel {
  Future<void> passwordRest({required String email}) async {
    await FirebaseService.instance.authInstance
        .sendPasswordResetEmail(email: email);
  }
}
