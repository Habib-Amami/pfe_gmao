import 'package:pfe_gmao/features/profile_management/model/profile_model.dart';

class ProfileController {
  final ProfileModel _profileModel = ProfileModel();

  Future<bool> verifyPassword({required String entredPassword}) async {
    try {
      await _profileModel.reauthenticateWithNewPassword(
        password: entredPassword,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateUserName({required String newUserName}) async {
    await _profileModel.updateUserName(newUserName: newUserName);
  }

  Future<void> updatePhoneNumber({required String newPhoneNumber}) async {
    await _profileModel.updatePhoneNumber(newPhoneNumber: newPhoneNumber);
  }

  Future<void> updateEmail(
      {required String newEmail, required String password}) async {
    await _profileModel.updateEmail(
      newEmail: newEmail,
      password: password,
    );
  }
}
