import '../model/notification_model.dart';

class NotificationController {
  final NotificationsModel model = NotificationsModel();

  ///
  ///Push notification methodes
  ///

  // Function to send a push notification to a specific device
  Future<void> sendNotificationToDevice({
    required String deviceToken,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    try {
      model.sendNotificationToDevice(
        deviceToken: deviceToken,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
      );
    } catch (e) {
      rethrow;
    }
  }

  //get the current user FCM token
  Future<String?> getCurrentUserToken() async {
    try {
      return model.getCurrentUserToken();
    } catch (e) {
      rethrow;
    }
  }

  //get all the admin of a dicsipline tokens
  Future<List<String>> getAdminsTokens({
    required String equipmentDiscipline,
  }) async {
    try {
      return model.getAdminsTokens(equipmentDiscipline: equipmentDiscipline);
    } catch (e) {
      rethrow;
    }
  }

  // Function to send a push notification to all administrators with a specific discipline
  Future<void> sendIFValidationRequestNotification({
    //list of admins tokens
    required List<String> adminsTokens,
    // Discipline for which the notification is sent
    required String notificationTitle,
    required String equipmentDiscipline,
    required String notificationBody,
  }) async {
    try {
      model.sendIFValidationRequestNotification(
        adminsTokens: adminsTokens,
        notificationTitle: notificationTitle,
        equipmentDiscipline: equipmentDiscipline,
        notificationBody: notificationBody,
      );
    } catch (e) {
      rethrow;
    }
  }
}
