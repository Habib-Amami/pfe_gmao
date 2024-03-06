import '../model/profile_model.dart';

class ProfileController {
  final ProfileModel _profileModel = ProfileModel();

  Future<bool> verifyPassword({required String entredPassword}) async {
    try {
      await _profileModel.reauthenticateWithPassword(
        password: entredPassword,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateUserName({required String newUserName}) async {
    try {
      await _profileModel.updateUserName(newUserName: newUserName);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePhoneNumber({required String newPhoneNumber}) async {
    await _profileModel.updatePhoneNumber(newPhoneNumber: newPhoneNumber);
  }

  Future<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    await _profileModel.updateEmail(
      newEmail: newEmail,
      password: password,
    );
  }

  Future<void> updatePassword({required String newPassword}) async {
    await _profileModel.updatePassword(
      newPassword: newPassword,
    );
  }
}
