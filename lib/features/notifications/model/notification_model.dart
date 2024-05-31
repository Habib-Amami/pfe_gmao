import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../profile_management/model/user.dart';
import 'data_models/intervention_file_validation_notification.dart';
import 'data_models/work_order_notification.dart';

class NotificationsModel {
  //firestore intace
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //FCM server key
  static const String serverKey =
      'AAAA9fFEmCY:APA91bEy-GjdAEtorrreIqwoyauRzSs3lxAQadTcloqMxyaXzhTSs8Tik7ZB_B0E1vyv-SY3D8TJ7iOIv5J9-4UssDefCblAHGnhjLA6I6iIl5o2-cnN26vp8sH_6ts68S4Zw_YijO2l';

  //notification channel for android to override the default FCM channel
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
  );

  //initialization Settings for the android local notifications
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  //local nitifcation settings
  static const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // firebase background message handler
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    if (kDebugMode) {
      print('A Background message just showed up :  ${message.messageId}');
    }
  }

  ///
  ///Push notification methodes
  ///

  // Function to send a push notification to a specific device
  Future<void> sendNotificationToDevice({
    required String deviceToken,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    // Define FCM endpoint
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    // Define FCM message
    final payload = {
      'notification': {
        'title': notificationTitle,
        'body': notificationBody,
      },
      // FCM token of the device
      'to': deviceToken,
    };
    // Encode FCM message to JSON
    final jsonPayload = json.encode(payload);
    // Make POST request to FCM endpoint
    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'key=$serverKey', // Server key from Firebase Console
      },
      body: jsonPayload,
    );
    // Check response status
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('FCM notification sent successfully');
      }
    } else {
      if (kDebugMode) {
        print(
            'Failed to send FCM notification. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }

  //get the current user FCM token
  Future<String?> getCurrentUserToken() async {
    //getting the current user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;
    //getting the stored token
    String? currentUserToken;
    await firestore.collection(userCollectionRef).doc(userId).get().then(
      (DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        currentUserToken = data["FCMtoken"];
      },
    );
    return currentUserToken;
  }

  //get all the admin of a dicsipline tokens
  Future<List<String>> getAdminsTokens({
    required String equipmentDiscipline,
  }) async {
    List<String> adminsToken = [];
    // Retrieve FCM tokens of all administrators with the specified discipline
    await firestore
        .collection(userCollectionRef)
        .where(
          'role',
          isEqualTo: Roles.Administrator.toShortString(),
        )
        .where(
          'discipline',
          isEqualTo: equipmentDiscipline,
        )
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String fcmToken = doc['FCMtoken'];
        adminsToken.add(fcmToken);
        if (kDebugMode) {
          print(adminsToken);
        }
      }
    });
    return adminsToken;
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
    // Retrieve the current user's data
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot currentUserDoc =
        await firestore.collection(userCollectionRef).doc(currentUserID).get();
    Map<String, dynamic>? userData =
        currentUserDoc.data() as Map<String, dynamic>?;

    //retrieve the role from user collection
    String userRole = userData!['role'].toString();

    // If the current user is an administrator, remove their token from the list
    if (userRole == Roles.Administrator.toShortString()) {
      String? currentUserToken = await FirebaseMessaging.instance.getToken();
      if (currentUserToken != null) {
        adminsTokens.remove(currentUserToken);
      }
    }
    //check if the admins tokens exists
    if (adminsTokens.isNotEmpty) {
      // Send the notification to each administrator's device
      for (String token in adminsTokens) {
        sendNotificationToDevice(
          deviceToken: token,
          notificationTitle: notificationTitle,
          notificationBody: notificationBody,
        );
        if (kDebugMode) {
          print(adminsTokens);
        }
      }
    }
  }

  ///
  /// intervention file notification methodes
  ///

  //add a intervention files notification the the admins documents
  Future<void> addInterventionFileValidationNotificationDB({
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
    // Retrieve the current user ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    // getting the current user data
    DocumentSnapshot currentUserDoc =
        await firestore.collection(userCollectionRef).doc(currentUserID).get();
    Map<String, dynamic>? userData =
        currentUserDoc.data() as Map<String, dynamic>?;

    //retrieve the role from current user  collection
    String currentUserRole = userData!['role'].toString();

    // Query admins with the specified discipline
    QuerySnapshot usersSnapshot = await firestore
        .collection(userCollectionRef)
        .where('role', isEqualTo: Roles.Administrator.toShortString())
        .where('discipline', isEqualTo: equipmentDiscipline)
        .get();

    //if the current user is an admin
    //user his fcm token to element him from the admins who will receieve the notification
    if (currentUserRole == Roles.Administrator.toShortString()) {
      // Query admins specific discipline
      usersSnapshot = await firestore
          .collection(userCollectionRef)
          .where('role', isEqualTo: Roles.Administrator.toShortString())
          .where('discipline', isEqualTo: equipmentDiscipline)
          .where('FCMtoken', isNotEqualTo: interventionFileCreatorToken)
          .get();
    } else {
      //if the user is not an admin make a query for all admins
      // with thta discipline
      usersSnapshot = await firestore
          .collection(userCollectionRef)
          .where('role', isEqualTo: Roles.Administrator.toShortString())
          .where('discipline', isEqualTo: equipmentDiscipline)
          .get();
    }

    //creating a batch to write in mutiple documents
    WriteBatch batch = firestore.batch();

    // Iterate over the query snapshot to get each user's document ID
    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      //user doc id
      String userId = userDoc.id;
      //generate a new notification document id
      String notificationDocId = const Uuid().v4();

      //creating an instance of validation notification
      InterventionFileValidationNotification notification =
          InterventionFileValidationNotification(
        notificationID: notificationDocId,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
        interventionFileCreatorID: interventionFileCreatorID,
        interventionFileCreatorToken: interventionFileCreatorToken,
        interventionFileID: interventionFileID,
        interventionType: interventionType,
        equipmentID: equipmentID,
        equipmentTagName: equipmentTagName,
        equipmentDiscipline: equipmentDiscipline,
        createdAt: DateTime.now(),
      );
      // Add a subcollection called 'notifications' and write the desired data to it
      batch.set(
        firestore
            .collection('users')
            .doc(userId)
            .collection('IF_notifications')
            .doc(notificationDocId),
        notification.toJson(),
      );
    }
    //commiting the batch
    await batch.commit();
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
    //creating an instance of validation notification
    InterventionFileValidationNotification notification =
        InterventionFileValidationNotification(
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
      createdAt: DateTime.now(),
    );
    //adding notification to the file creator document using this fcm token
    await firestore
        .collection(userCollectionRef)
        .doc(interventionFileCreatorID)
        .collection('IF_notifications')
        .doc(notificationID)
        .set(notification.toJson());
  }

  //method to delete intervention files notifications
  Future<void> deleteIFNotification({
    required String notificationID,
  }) async {
    // Retrieve the current user ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //
    await firestore
        .collection(userCollectionRef)
        .doc(currentUserID)
        .collection("IF_notifications")
        .doc(notificationID)
        .delete();
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
    //creating a work order notification
    WorkorderNotification notification = WorkorderNotification(
      notificationID: notificationID,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
      workorderCreatorID: workorderCreatorID,
      technicianID: technicianID,
      createdAt: DateTime.now(),
      workOrderID: workOrderID,
      interventionID: interventionID,
    );
    await firestore
        .collection(userCollectionRef)
        .doc(technicianID)
        .collection("WO_notifications")
        .doc(notificationID)
        .set(notification.toJson());
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
    //creating a work order notification
    WorkorderNotification notification = WorkorderNotification(
        notificationID: notificationID,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
        workorderCreatorID: workorderCreatorID,
        technicianID: technicianID,
        createdAt: DateTime.now(),
        workOrderID: workOrderID,
        interventionID: interventionID);
    //adding a notification in the engineer side
    await firestore
        .collection(userCollectionRef)
        .doc(technicianID)
        .collection("WO_notifications")
        .doc(notificationID)
        .set(notification.toJson());
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
    //creating a work order notification
    WorkorderNotification notification = WorkorderNotification(
      notificationID: notificationID,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
      workorderCreatorID: workorderCreatorID,
      technicianID: technicianID,
      createdAt: DateTime.now(),
      workOrderID: workOrderID,
      interventionID: interventionID,
    );
    //adding a notification in the admin side
    await firestore
        .collection(userCollectionRef)
        .doc(workorderCreatorID)
        .collection("WO_notifications")
        .doc(notificationID)
        .set(notification.toJson());
  }

  //method to delete work order notifications
  Future<void> deleteWONotification({
    required String notificationID,
  }) async {
    // Retrieve the current user ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //
    await firestore
        .collection(userCollectionRef)
        .doc(currentUserID)
        .collection("WO_notifications")
        .doc(notificationID)
        .delete();
  }
}
