import '../model/profile_model.dart';

class ProfileController {
  final ProfileModel _profileModel = ProfileModel();

  // Verify the entered password for reauthentication
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

  // Update the user's username.
  Future<void> updateUserName({required String newUserName}) async {
    try {
      await _profileModel.updateUserName(newUserName: newUserName);
    } catch (e) {
      rethrow;
    }
  }

  // Update the user's phone number
  Future<void> updatePhoneNumber({required String newPhoneNumber}) async {
    try {
      await _profileModel.updatePhoneNumber(newPhoneNumber: newPhoneNumber);
    } catch (e) {
      rethrow;
    }
  }

  // Update the user's email
  Future<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    await _profileModel.updateEmail(
      newEmail: newEmail,
      password: password,
    );
  }

  // Update the user's password
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _profileModel.updatePassword(
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }
}
