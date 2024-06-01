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

  ///
  /// intervention file notification methodes
  ///

  //add a intervention files notification the the admins documents
  Future<void> addInterventionFileValidationNotification({
    required String notificationID,
    required String notificationTitle,
    required String notificationBody,
    required String interventionFileCreatorID,
    required String interventionFileCreatorToken,
    required String interventionFileID,
    required String interventionType,
    required String equipmentID,
    required String equipmentTagName,
    required String equipmentDiscipline,
  }) async {
    try {
      model.addInterventionFileValidationNotificationDB(
        notificationID: notificationID,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
        interventionFileCreatorID: interventionFileCreatorID,
        interventionFileCreatorToken: interventionFileCreatorToken,
        interventionFileID: interventionFileID,
        interventionType: interventionType,
        equipmentID: equipmentID,
        equipmentTagName: equipmentTagName,
        equipmentDiscipline: equipmentDiscipline,
      );
    } catch (e) {
      rethrow;
    }
  }

  //add a notification validation update to the file creator using this FCM token
  Future<void> addValidationNotificationUpdateDB({
    required String notificationID,
    required String notificationTitle,
    required String notificationBody,
    required String interventionFileCreatorID,
    required String interventionFileCreatorToken,
    required String interventionFileID,
    required String interventionType,
    required String equipmentID,
    required String equipmentTagName,
    required String equipmentDiscipline,
  }) async {
    try {
      model.addValidationNotificationUpdateDB(
        notificationID: notificationID,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
        interventionFileCreatorID: interventionFileCreatorID,
        interventionFileCreatorToken: interventionFileCreatorToken,
        interventionFileID: interventionFileID,
        interventionType: interventionType,
        equipmentID: equipmentID,
        equipmentTagName: equipmentTagName,
        equipmentDiscipline: equipmentDiscipline,
      );
    } catch (e) {
      rethrow;
    }
  }

  //method to delete intervention files notifications
  Future<void> deleteIFNotification({
    required String notificationID,
  }) async {
    try {
      model.deleteIFNotificationDB(
        notificationID: notificationID,
      );
    } catch (e) {
      return;
    }
  }

  ///
  /// work order notification methods
  ///

  //Function to add a notification to the engineer that he got a new work order
  Future<void> sendDispatchWorkorderNotification({
    required String notificationID,
    required String notificationTitle,
    required String notificationBody,
    required String workorderCreatorID,
    required String technicianID,
    required String workOrderID,
    required String interventionID,
  }) async {
    try {
      model.sendDispatchWorkorderNotificationDB(
        notificationID: notificationID,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
        workorderCreatorID: workorderCreatorID,
        technicianID: technicianID,
        workOrderID: workOrderID,
        interventionID: interventionID,
      );
    } catch (e) {
      rethrow;
    }
  }

  // method to validate or deny the termination request
  Future<void> validateOrDenyRequestNotification({
    required String notificationID,
    required String notificationTitle,
    required String notificationBody,
    required String workorderCreatorID,
    required String technicianID,
    required String workOrderID,
    required String interventionID,
  }) async {
    try {
      model.validateOrDenyRequestNotificationDB(
        notificationID: notificationID,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
        workorderCreatorID: workorderCreatorID,
        technicianID: technicianID,
        workOrderID: workOrderID,
        interventionID: interventionID,
      );
    } catch (e) {
      rethrow;
    }
  }

  //method to change the work order status
  Future<void> sendWorkorderValidationRequestorStandByNotification({
    required String notificationID,
    required String notificationTitle,
    required String notificationBody,
    required String workorderCreatorID,
    required String technicianID,
    required String workOrderID,
    required String interventionID,
  }) async {
    try {
      model.sendWorkorderValidationRequestorStandByNotificationDB(
        notificationID: notificationID,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
        workorderCreatorID: workorderCreatorID,
        technicianID: technicianID,
        workOrderID: workOrderID,
        interventionID: interventionID,
      );
    } catch (e) {
      rethrow;
    }
  }

  //method to delete work order notifications
  Future<void> deleteWONotification({
    required String notificationID,
  }) async {
    try {
      model.deleteWONotificationDB(notificationID: notificationID);
    } catch (e) {
      rethrow;
    }
  }
}
